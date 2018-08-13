//
//  ExchangeViewController.swift
//  revolut
//
//  Created by Alexander Danilov on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import Foundation

class ExchangeViewController: UITableViewController {
    @IBOutlet weak var exchangeButton: UIBarButtonItem!
    
    private let viewModel: ExchangeViewModel
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = AppDelegate.shared.exchangeViewModel
        super.init(coder: aDecoder)
    }
    
    func exchange() {
        do {
            try viewModel.exchange()
        } catch let error {
            AppDelegate.shared.onError(error: error)
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeButton.target = self
        exchangeButton.action = #selector(exchange)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.addObserver(self, forKeyPath: "canExchange", options: [.new, .initial], context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.removeObserver(self, forKeyPath: "canExchange")
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeTableCell", for: indexPath)
        
        let pageControl = cell.contentView.subviews[1] as! UIPageControl
        
        let accountPicker = cell.contentView.subviews[0] as! ExchangeAccountPickerView
        accountPicker.backgroundColor = accountPicker.backgroundColor?.withAlphaComponent(indexPath.row == 0 ? 0.7 : 1)
        accountPicker.pageControl = pageControl
        accountPicker.setViewModel(viewModel, andType: indexPath.row == 0 ? .from : .to)
        
        return cell
    }
    
    // MARK: - NSObject
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "canExchange") { // TODO add and check observeContext
            exchangeButton.isEnabled = viewModel.canExchange
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
