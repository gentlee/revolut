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
                     @"EUR": [[Account alloc] initWithCurrency:@"EUR" andBalance:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"GBP": [[Account alloc] initWithCurrency:@"GBP" andBalance:[[NSDecimalNumber alloc] initWithInt: 100]],
                     @"USD": [[Account alloc] initWithCurrency:@"USD" andBalance:[[NSDecimalNumber alloc] initWithInt: 100]]
                     };
    }
    return self;
}

-(BOOL)canExchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency {
    Account *fromAccount = accounts[fromCurrency];
    BOOL result = [fromAccount.balance compare:amount] != NSOrderedAscending;
    NSLog(@"canExchange: %@ from: %@ accountAmount: %@ result: %@", amount, fromCurrency, fromAccount.balance, [NSNumber numberWithBool:result]);
    return result;
}

-(BOOL)exchangeAmount:(NSDecimalNumber *)amount from:(NSString *)fromCurrency to:(NSString *)toCurrency error:(NSError **)errorPtr {
    NSLog(@"exchangeAmount: %@ from: %@ to: %@", amount, fromCurrency, toCurrency);
    
    Account *fromAccount = accounts[fromCurrency];
    Account *toAccount = accounts[toCurrency];
    
    BOOL noAccounts = !fromAccount || !toAccount;
    if (noAccounts || ![self canExchangeAmount:amount from:fromCurrency]) {
        NSString *errorMessage = noAccounts ? @"Unknown error" : @"You don't have enough money";
        if (errorPtr) {
            *errorPtr = [NSError errorWithDomain:@"revolut" code:0 userInfo:@{ NSLocalizedDescriptionKey: errorMessage }];
        }
        return FALSE;
    }
    
    [self setValue:[fromAccount.balance decimalNumberBySubtracting:amount]
        forKeyPath:[NSString stringWithFormat:@"accounts.%@.balance", fromCurrency]];
    
    NSDecimalNumber *amountToAdd = [_currencyManager getExchangeRateOfValue:amount from:fromCurrency to:toCurrency];
    [self setValue:[toAccount.balance decimalNumberByAdding: amountToAdd]
        forKeyPath:[NSString stringWithFormat:@"accounts.%@.balance", toCurrency]];
    
    NSLog(@"exchangeAmount Success, newFromAmount: %@ newToAmount: %@", fromAccount.balance, toAccount.balance);
    
    return TRUE;
}

@end
