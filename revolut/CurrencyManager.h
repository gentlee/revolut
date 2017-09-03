//
//  CurrencyManager.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiService.h"

@interface CurrencyManager : NSObject
    
@property (readonly, nonatomic) NSDictionary *rates;

-(instancetype) initWithApiService:(ApiService *)apiService;
-(void) startUpdatingRates;
-(NSDecimalNumber *)getExchangeRateOfValue:(NSDecimalNumber *)value from:(NSString *)fromCurrency to:(NSString *)toCurrency;
    
@end
