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
@synthesize balance = _balance;
    
-(instancetype) initWithCurrency: (NSString *)currency andBalance:(NSDecimalNumber *)balance {
    self = [super init];
    if (self) {
        _currency = currency;
        _balance = balance;
    }
    return self;
}

@end
