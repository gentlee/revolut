//
//  AppDelegate.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
    
+ (AppDelegate *)sharedInstance{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
    
- (instancetype)init {
    self = [super init];
    if (self) {
        _apiService = [ApiService new];
        _currencyManager = [[CurrencyManager alloc] initWithApiService: _apiService];
        _accountManager = [[AccountManager alloc] initWith:_currencyManager];
        _exchangeViewModel = [[ExchangeViewModel alloc] initWith:_accountManager and:_currencyManager];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // handle errors
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Error" object:nil queue:nil usingBlock:^(NSNotification *notificaion){
        NSString *errorMessage = [notificaion.userInfo valueForKey:@"error"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"Dismiss" style:0 handler:nil]];
        [[self.window rootViewController] presentViewController:alert animated:true completion:nil];
    }];
    
    // start updating currency rates
    
    [_currencyManager startUpdatingRates];
    
    return YES;
}

@end
