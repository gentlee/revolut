//
//  CurrencyManager.swift
//  revolut
//
//  Created by Alexander Danilov on 13/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class CurrencyManager: NSObject {
    static let RATE_UPDATE_INTERVAL = 30.0
    
    let apiService: ApiService
    
    var rates: NSDictionary?
    
    init(apiService: ApiService) {
        self.apiService = apiService
        
        super.init()
    }
    
    func startUpdatingRates() {
        self.apiService.getCurrencyRates({ newRates, error in
            if let error = error {
                self.onError(error)
                return
            }
            
            if var newRates = newRates {
                newRates["EUR"] = NSDecimalNumber(value: 1)
                self.setValue(newRates, forKey: "rates")
            }
            
            self.perform(#selector(self.startUpdatingRates), with: nil, afterDelay: CurrencyManager.RATE_UPDATE_INTERVAL) // TODO delay can be estimated using last request time
        })
    }

    func subscribeOnError(_ handler: @escaping (Error) -> Void) -> () -> Void {
        let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name("Error"), object: self, queue: nil, using: { notificaion in
            let error = notificaion.userInfo!["error"] as! Error
            handler(error)
        })
        return {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func onError(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("Error"), object: self, userInfo: ["error": error])
    }
    
    func getExchangeRate(ofValue value: NSDecimalNumber, from fromCurrency: String, to toCurrency: String) -> NSDecimalNumber? {
        guard
            let rates = self.rates as? [String: NSDecimalNumber],
            let fromRate = rates[fromCurrency],
            let toRate = rates[toCurrency]
            else { return nil }
        
        return value.multiplying(by: toRate).dividing(by: fromRate)
    }

}
