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
        // TODO use container
        _apiService = [ApiService new];
        _currencyManager = [[CurrencyManager alloc] initWithApiService: _apiService];
        _accountManager = [[AccountManager alloc] initWith:_currencyManager];
        _exchangeViewModel = [[ExchangeViewModel alloc] initWith:_accountManager and:_currencyManager];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [_currencyManager subscribeOnError:^(NSError *error) { [self onError:error]; }];
    [_currencyManager startUpdatingRates];
    
    return YES;
}

-(void)onError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"Dismiss" style:0 handler:nil]];
    [[self.window rootViewController] presentViewController:alert animated:true completion:nil];
}

@end
