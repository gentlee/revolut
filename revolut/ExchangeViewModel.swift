//
//  ExchangeViewModel.swift
//  revolut
//
//  Created by Alexander Danilov on 13/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class ExchangeViewModel: NSObject {
    let accountManager: AccountManager
    let currencyManager: CurrencyManager
    
    dynamic var valueFrom: NSDecimalNumber
    dynamic var currencyFrom: String
    dynamic var currencyTo: String
    dynamic private(set) var canExchange = false
    
    init(accountManager: AccountManager, currencyManager: CurrencyManager) {
        self.accountManager = accountManager
        self.currencyManager = currencyManager
        
        let currencies = accountManager.accounts.allKeys as! [String]
        self.currencyFrom = currencies[0]
        self.currencyTo = currencies[1]
        self.valueFrom = NSDecimalNumber.zero
        
        super.init()
        
        self.addObserver(self, forKeyPath: "valueFrom", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "currencyFrom", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "currencyTo", options: [.new, .initial], context: nil)
    }
    
    var valueTo: NSDecimalNumber {
        get {
            return self.currencyManager.getExchangeRate(ofValue: self.valueFrom, from: self.currencyFrom, to: self.currencyTo) ?? NSDecimalNumber.zero
        }
        set {
            self.valueFrom = self.currencyManager.getExchangeRate(ofValue: newValue, from: self.currencyTo, to: self.currencyFrom) ?? NSDecimalNumber.zero
        }
    }
    
    func exchange() throws {
        try self.accountManager.exchange(amount: valueFrom, from: currencyFrom, to: currencyTo)
        self.valueFrom = NSDecimalNumber.zero
    }
    
    // MARK: - NSObject
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "valueFrom" || keyPath == "currencyFrom" || keyPath == "currencyTo" {
            let canExchangeAmount =
                currencyFrom != currencyTo &&
                valueFrom.compare(NSDecimalNumber.zero) != .orderedSame &&
                accountManager.canExchange(amount: valueFrom, from: currencyFrom)
            
            self.canExchange = canExchangeAmount ? true : false
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
