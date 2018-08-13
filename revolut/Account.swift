//
//  Account.swift
//  revolut
//
//  Created by Alexander Danilov on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class Account: NSObject {
    var currency: String
    var balance: NSDecimalNumber
    
    init(currency: String, balance: NSDecimalNumber) {
        self.currency = currency
        self.balance = balance
    }
}
