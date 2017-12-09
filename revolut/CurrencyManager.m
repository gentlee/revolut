//
//  CurrencyManager.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "CurrencyManager.h"
#import "ApiService.h"

@implementation CurrencyManager {
    ApiService *_apiService;
}
    
double const RATE_UPDATE_INTERVAL = 30.0;
    
@synthesize rates;

-(instancetype)initWithApiService:(ApiService *)apiService {
    self = [super init];
    if (self) {
        _apiService = apiService;
    }
    return self;
}
    
-(void)startUpdatingRates {
    [self updateRates];
}
    
-(void)updateRates {
    [_apiService getCurrencyRates:^(NSDictionary *newRates, NSError *error) {
        if (error == nil) {
            [newRates setValue:[[NSDecimalNumber alloc] initWithInt:1] forKey:@"EUR"];
            [self setValue:newRates forKey:@"rates"];
        } else {
            [self onError:error];
        }
        [self performSelector:@selector(updateRates) withObject:nil afterDelay:RATE_UPDATE_INTERVAL]; // delay can be estimated using last request time
    }];
}

-(void (^)())subscribeOnError:(void (^)(NSError *))handler {
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"Error" object:self queue:nil usingBlock:^(NSNotification *notificaion) {
        NSError *error = [notificaion.userInfo valueForKey:@"error"];
        handler(error);
    }];
    
    return ^{
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    };
}

-(void)onError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:self userInfo: @{@"error": error}];
}

-(NSDecimalNumber *)getExchangeRateOfValue:(NSDecimalNumber *)value from:(NSString *)fromCurrency to:(NSString *)toCurrency {
    if (!rates || !rates[fromCurrency] || !rates[toCurrency]) return nil;
    
    NSDecimalNumber *fromRate = rates[fromCurrency];
    NSDecimalNumber *toRate = rates[toCurrency];
    
    return [[value decimalNumberByMultiplyingBy:toRate] decimalNumberByDividingBy:fromRate];
}

@end
