//
//  AccountManager.swift
//  revolut
//
//  Created by Alexander Danilov on 13/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class AccountManager: NSObject {
    let currencyManager: CurrencyManager
    
    var accounts: NSDictionary
    
    init(currencyManager: CurrencyManager) {
        self.currencyManager = currencyManager
        self.accounts = NSDictionary(dictionary: [
            "EUR": Account(currency: "EUR", balance: NSDecimalNumber(value: 100)),
            "GBP": Account(currency: "GBP", balance: NSDecimalNumber(value: 100)),
            "USD": Account(currency: "USD", balance: NSDecimalNumber(value: 100))
        ])
        
        super.init()
    }

    func canExchange(amount: NSDecimalNumber, from fromCurrency: String) -> Bool {
        let fromAccount: Account = self.accounts[fromCurrency]! as! Account
        let result: Bool = fromAccount.balance.compare(amount) != .orderedAscending
        print("canExchange: \(amount) from: \(fromCurrency) accountAmount: \(fromAccount.balance) result: \(result)")
        return result
    }
    
    func exchange(amount: NSDecimalNumber, from fromCurrency: String, to toCurrency: String) throws {
        print("exchangeAmount: \(amount) from: \(fromCurrency) to: \(toCurrency)")
        
        let fromAccount: Account = accounts[fromCurrency]! as! Account
        let toAccount: Account = accounts[toCurrency]! as! Account
        if !canExchange(amount: amount, from: fromCurrency) {
            throw NSError(domain: "revolut", code: 0, userInfo: [NSLocalizedDescriptionKey: "You don't have enough money"])
        }
        
        self.setValue(fromAccount.balance.subtracting(amount), forKeyPath: "accounts.\(fromCurrency).balance")
        
        let amountToAdd: NSDecimalNumber = currencyManager.getExchangeRate(ofValue: amount, from: fromCurrency, to: toCurrency)!
        self.setValue(toAccount.balance.adding(amountToAdd), forKeyPath: "accounts.\(toCurrency).balance")

        print("exchangeAmount Success, newFromAmount: \(fromAccount.balance) newToAmount: \(toAccount.balance)")
    }
}
