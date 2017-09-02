//
//  User.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "User.h"
#import "Account.h"

@implementation User
    
@synthesize accounts;
    
-(instancetype)init {
    self = [super init];
    if (self) {
        accounts = @{
                     @"EUR": [[Account alloc] initWithCurrency:@"EUR" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"GBP": [[Account alloc] initWithCurrency:@"GBP" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"USD": [[Account alloc] initWithCurrency:@"USD" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]]
                    };
    }
    return self;
}
    
@end
