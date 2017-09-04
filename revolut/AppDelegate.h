//
//  AppDelegate.h
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyManager.h"
#import "AccountManager.h"
#import "ApiService.h"
#import "ExchangeViewModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedInstance;
    
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) ApiService *apiService;

@property (nonatomic, readonly) CurrencyManager *currencyManager;
@property (nonatomic, readonly) AccountManager *accountManager;

@property (nonatomic, readonly) ExchangeViewModel *exchangeViewModel;

@end

