//
//  ExchangeAccountPickerView.swift
//  revolut
//
//  Created by Alexander Danilov on 13/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import Foundation

enum AccountPickerType {
    case from
    case to
}

class ExchangeAccountPickerView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var pageControl: UIPageControl?
    
    let accountManager: AccountManager
    var currencies: [String]
    
    var viewModel: ExchangeViewModel?
    var type: AccountPickerType?
    
    required init?(coder aDecoder: NSCoder) {
        self.accountManager = AppDelegate.shared.accountManager
        self.currencies = []
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
    }
    
    var currentPage: Int {
        let contentCenterOffset: CGFloat = self.contentOffset.x + self.frame.size.width / 2
        return Int(contentCenterOffset / self.frame.size.width) % self.currencies.count
    }
    
    var currentCurrency: String? {
        return self.currencies[currentPage]
    }
    
    func setViewModel(_ viewModel: ExchangeViewModel, andType type: AccountPickerType) {
        self.viewModel = viewModel
        self.type = type
        scrollToProperAccount()
    }

    func scrollToProperAccount() {
        guard let viewModel = viewModel else { return }
        
        let optionalCurrency: String? = type == .from ? viewModel.currencyFrom : viewModel.currencyTo
        guard let currency = optionalCurrency, optionalCurrency != self.currentCurrency else { return }

        // HACK simulate infinite scroll #2
        let accountIndex: Int = self.currencies.index(of: currency)!
        let centerPosition: Int = self.numberOfItems(inSection: 0) / 2
        let centerCurrencyPosition: Int = centerPosition - centerPosition % self.currencies.count + accountIndex
        
        // HACK layoutIfNeeded makes scrollToItem always work
        self.layoutIfNeeded()
        
        self.scrollToItem(at: IndexPath(row: centerCurrencyPosition, section: 0), at: .left, animated: false)
    }

    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000 // HACK simulate infinite scroll #1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeAccountPickerViewCell", for: indexPath) as! ExchangeAccountPickerViewCell
        cell.setViewModel(self.viewModel!, withType: type!, andCurrency: currencies[indexPath.row % currencies.count])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let pageControl = pageControl {
            if self.currentPage != pageControl.currentPage {
                pageControl.currentPage = currentPage
                self.viewModel?.setValue(currencies[currentPage], forKey: type == .from ? "currencyFrom" : "currencyTo")
                self.endEditing(true)
            }
        }
    }

    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = frame.size
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            accountManager.addObserver(self, forKeyPath: "accounts", options: [.new, .initial], context: nil)
            scrollToProperAccount()
        } else {
            accountManager.removeObserver(self, forKeyPath: "accounts")
        }
    }

    // MARK: - NSObject
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "accounts") {
            let currencies = accountManager.accounts.allKeys as! [String] // show currencies for each account
            if currencies != self.currencies {
                self.currencies = currencies
                reloadData()
                scrollToProperAccount()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
