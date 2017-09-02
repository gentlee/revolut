//
//  Account.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "Account.h"

@implementation Account
    
@synthesize currency = _currency;
@synthesize amount = _amount;
    
-(instancetype) initWithCurrency: (NSString *)currency andAmount:(NSDecimalNumber *)amount {
    self = [super init];
    if (self) {
        _currency = currency;
        _amount = amount;
    }
    return self;
}

@end
