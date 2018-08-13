//
//  AppDelegate.swift
//  revolut
//
//  Created by Alexander Danilov on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate;
    }
    
    var window: UIWindow?

    let apiService: ApiService
    let currencyManager: CurrencyManager
    let accountManager: AccountManager
    let exchangeViewModel: ExchangeViewModel
    
    override init() {
        self.apiService = ApiService()
        self.currencyManager = CurrencyManager(apiService: self.apiService)
        self.accountManager = AccountManager(currencyManager: self.currencyManager)
        self.exchangeViewModel = ExchangeViewModel(accountManager: self.accountManager, currencyManager: self.currencyManager)
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let _ = self.currencyManager.subscribeOnError(self.onError)
        self.currencyManager.startUpdatingRates()
    }
    
    func onError(error: Error) {
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
