//
//  AccountManager.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "AccountManager.h"
#import "Account.h"

@implementation AccountManager {
    CurrencyManager *_currencyManager;
}

@synthesize accounts;
    
-(instancetype)initWith:(CurrencyManager *)currencyManager {
    self = [super init];
    if (self) {
        _currencyManager = currencyManager;
        
        accounts = @{
                     @"EUR": [[Account alloc] initWithCurrency:@"EUR" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"GBP": [[Account alloc] initWithCurrency:@"GBP" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"USD": [[Account alloc] initWithCurrency:@"USD" andAmount:[[NSDecimalNumber alloc] initWithInt: 100]]
                     };
    }
    return self;
}

-(BOOL)canExchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency {
    Account *fromAccount = accounts[fromCurrency];
    BOOL result = [fromAccount.amount compare:amount] != NSOrderedAscending;
    NSLog(@"canExchange: %@ from: %@ accountAmount: %@ result: %@", amount, fromCurrency, fromAccount.amount, [NSNumber numberWithBool:result]);
    return result;
}

-(BOOL)exchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency to:(NSString *)toCurrency {
    NSLog(@"exchangeAmount: %@ from: %@ to: %@", amount, fromCurrency, toCurrency);
    
    Account *fromAccount = accounts[fromCurrency];
    Account *toAccount = accounts[toCurrency];
    
    BOOL noAccounts = !fromAccount || !toAccount;
    if (noAccounts || ![self canExchangeAmount:amount from:fromCurrency]) {
        NSString *errorMessage = noAccounts ? @"Unknown error" : @"You don't have enough money";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:self userInfo:@{@"error": errorMessage}];
        return FALSE;
    }
    
    [fromAccount setValue:[fromAccount.amount decimalNumberBySubtracting:amount] forKey:@"amount"];
    
    NSDecimalNumber *amountToAdd = [_currencyManager getExchangeRateOfValue:amount from:fromCurrency to:toCurrency];
    [toAccount setValue: [toAccount.amount decimalNumberByAdding: amountToAdd] forKey:@"amount"];
    
    NSLog(@"exchangeAmount Success, newFromAmount: %@ newToAmount: %@", fromAccount.amount, toAccount.amount);
    
    return TRUE;
}

@end
