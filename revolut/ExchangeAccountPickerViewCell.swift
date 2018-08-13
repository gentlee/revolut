//
//  ExchangeAccountPickerViewCell.swift
//  revolut
//
//  Created by Alexander Danilov on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import Foundation

//
//  CurrencyView.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//
class ExchangeAccountPickerViewCell: UICollectionViewCell, UITextFieldDelegate {
    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.currencySymbol = ""
        return formatter
    }()
    
    static let removeLeadingZerosRegex = {
        return try! NSRegularExpression(pattern: "^(0*)(\\d.*)", options: .caseInsensitive)
    }()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var accountValueLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var transferField: UITextField!
    private var fieldLeftView: UILabel!
    private var tapGesture: UITapGestureRecognizer!
    
    private let accountManager: AccountManager
    private let currencyManager: CurrencyManager
    
    var currency: String?
    var viewModel: ExchangeViewModel?
    var type: AccountPickerType?
    private var accountsKeyPath: String?
    private var ratesKeyPath: String?
    
    required init?(coder aDecoder: NSCoder) {
        self.accountManager = AppDelegate.shared.accountManager
        self.currencyManager = AppDelegate.shared.currencyManager
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: self.transferField.frame.size.height))
        self.fieldLeftView.textColor = self.transferField.textColor
        self.fieldLeftView.font = self.transferField.font
        
        self.transferField.leftView = self.fieldLeftView
        self.transferField.leftViewMode = .always
        self.transferField.delegate = self
        
        self.tapGesture = UITapGestureRecognizer(target: self.transferField, action: #selector(self.becomeFirstResponder))
        self.addGestureRecognizer(tapGesture)
    }
    
    func setViewModel(_ viewModel: ExchangeViewModel, withType type: AccountPickerType, andCurrency currency: String) {
        self.setSubscribed(false)
        
        self.viewModel = viewModel
        self.type = type
        self.currency = currency
        
        self.accountsKeyPath = "accounts.\(currency).balance"
        self.ratesKeyPath = "rates.\(currency)"
        
        if (self.window != nil) {
            self.setSubscribed(true)
        }
    
        self.currencyLabel.text = currency
        self.fieldLeftView.text = type == .from ? "-" : "+"
    }
    
    func setSubscribed(_ subscribed: Bool) {
        if (subscribed) {
            if let viewModel = self.viewModel {
                viewModel.addObserver(self, forKeyPath:"valueFrom", options:.new, context:nil)
                viewModel.addObserver(self, forKeyPath:"currencyFrom", options:.new, context:nil)
                viewModel.addObserver(self, forKeyPath:"currencyTo", options:.new, context:nil)
            }
    
            if self.currency != nil {
                self.accountManager.addObserver(self, forKeyPath:accountsKeyPath!, options:[.new, .initial], context:nil)
                self.currencyManager.addObserver(self, forKeyPath:ratesKeyPath!, options:[.new, .initial], context:nil)
            }
        } else {
            if let viewModel = viewModel {
                viewModel.removeObserver(self, forKeyPath: "valueFrom")
                viewModel.removeObserver(self, forKeyPath: "currencyFrom")
                viewModel.removeObserver(self, forKeyPath: "currencyTo")
            }
    
            if self.currency != nil {
                self.accountManager.removeObserver(self, forKeyPath:self.accountsKeyPath!)
                self.currencyManager.removeObserver(self, forKeyPath:self.ratesKeyPath!)
            }
        }
    }

    // MARK: - UITextField

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numbersOnly = CharacterSet(charactersIn: "0123456789,.")
        let characterSetFromTextField = CharacterSet(charactersIn: string)
        let isNumber = numbersOnly.isSuperset(of: characterSetFromTextField)
        if isNumber {
            var finalString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            var number = NSDecimalNumber(string: finalString)
            if number == NSDecimalNumber.notANumber {
                number = NSDecimalNumber.zero
                finalString = "0"
            }
            
            finalString = ExchangeAccountPickerViewCell.removeLeadingZerosRegex.stringByReplacingMatches(
                in: finalString,
                options: [],
                range: NSRange(location: 0, length: finalString.count),
                withTemplate: "$2")
        
            textField.text = finalString
            
            if type == .from {
                self.viewModel!.valueFrom = number
            } else {
                self.viewModel!.valueTo = number
            }
        }
        
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ExchangeAccountPickerViewCell.decimalFormatter.string(from: type == .from ? self.viewModel!.valueFrom : self.viewModel!.valueTo)
    }
    
    // MARK: - UIView
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.setSubscribed(self.window != nil)
    }
    
    // MARK: - NSObject
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == accountsKeyPath) {
            ExchangeAccountPickerViewCell.currencyFormatter.currencyCode = currency
            let account: Account = self.accountManager.accounts[currency!]! as! Account
            accountValueLabel.text = String.localizedStringWithFormat("You have %@", ExchangeAccountPickerViewCell.currencyFormatter.string(from: account.balance)!)
        } else if (keyPath == ratesKeyPath) || (keyPath == "valueFrom") || (keyPath == "currencyFrom") || (keyPath == "currencyTo") {
            ExchangeAccountPickerViewCell.currencyFormatter.currencyCode = currency
            let fromValue = NSDecimalNumber(value: 1)
            let fromText = ExchangeAccountPickerViewCell.currencyFormatter.string(from: fromValue) ?? ""
            
            let currencyTo: String = type == .from ? viewModel!.currencyTo : viewModel!.currencyFrom
            ExchangeAccountPickerViewCell.currencyFormatter.currencyCode = currencyTo
            let toValue = currencyManager.getExchangeRate(ofValue: fromValue, from: self.currency!, to: currencyTo) ?? NSDecimalNumber.notANumber
            let toText = ExchangeAccountPickerViewCell.currencyFormatter.string(from: toValue) ?? ""
            
            rateLabel.text = "\(fromText) = \(toText)"
            let currentExchangeValue: NSDecimalNumber = type == .from ? viewModel!.valueFrom : viewModel!.valueTo
            if NSDecimalNumber(string: transferField.text) != currentExchangeValue {
                transferField.text = ExchangeAccountPickerViewCell.decimalFormatter.string(from: currentExchangeValue)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
