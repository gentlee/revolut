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
            [self setValue:newRates forKey:@"rates"];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:self userInfo: @{@"error": error}];
        }
        [self performSelector:@selector(updateRates) withObject:nil afterDelay:RATE_UPDATE_INTERVAL]; // delay can be estimated using last request time
    }];
}

@end
