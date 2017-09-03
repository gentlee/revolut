//
//  UserManager.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyManager.h"
#import "User.h"

@interface UserManager : NSObject

@property (nonatomic, readonly) User *user;

-(instancetype)initWith:(CurrencyManager *)currencyManager;

-(BOOL)canExchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency;
-(BOOL)exchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency to:(NSString *)toCurrency;

@end
