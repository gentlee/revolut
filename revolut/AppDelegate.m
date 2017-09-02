//
//  AppDelegate.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
    
@synthesize apiService = _apiService;
@synthesize currencyManager = _currencyManager;
@synthesize userManager = _userManager;
    
+ (AppDelegate *)sharedInstance{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
    
- (instancetype)init {
    self = [super init];
    if (self) {
        _apiService = [ApiService new];
        _currencyManager = [[CurrencyManager alloc] initWithApiService: _apiService];
        _userManager = [UserManager new];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [_currencyManager startUpdatingRates];
    
    return YES;
}

@end
