//
//  ExchangeViewModel.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ExchangeViewModel.h"
#import "AppDelegate.h"

@implementation ExchangeViewModel {
    AccountManager *_accountManager;
    CurrencyManager *_currencyManager;
}

@synthesize valueFrom;
@synthesize currencyTo;
@synthesize currencyFrom;
@synthesize canExchange;

- (instancetype)initWith:(AccountManager *)accountManager and:(CurrencyManager *)currencyManager
{
    self = [super init];
    if (self) {
        _accountManager = accountManager;
        _currencyManager = currencyManager;
        
        currencyFrom = _accountManager.accounts.allKeys[0];
        currencyTo = _accountManager.accounts.allKeys[1];
        valueFrom = NSDecimalNumber.zero;
        
        [self addObserver:self forKeyPath:@"valueFrom" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"currencyFrom" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"currencyTo" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (BOOL)exchange:(NSError **)errorPtr {
    if ([_accountManager exchangeAmount:valueFrom from:currencyFrom to:currencyTo error:errorPtr]) {
        [self setValue:NSDecimalNumber.zero forKey:@"valueFrom"];
        return TRUE;
    }
    return FALSE;
}

- (void)setValueTo:(NSDecimalNumber *)value {
    [self setValue:[_currencyManager getExchangeRateOfValue:value from:currencyTo to:currencyFrom] forKey:@"valueFrom"];
}

- (NSDecimalNumber *)valueTo {
    return [_currencyManager getExchangeRateOfValue:valueFrom from:currencyFrom to:currencyTo];
}

#pragma mark - NSObject

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"valueFrom"] || [keyPath isEqualToString:@"currencyFrom"] || [keyPath isEqualToString:@"currencyTo"]) {
        BOOL canExchangeAmount =
            ![currencyFrom isEqualToString:currencyTo] &&
            [valueFrom compare:NSDecimalNumber.zero] != NSOrderedSame &&
            [_accountManager canExchangeAmount:valueFrom from:currencyFrom];
        
        [self setValue:[NSNumber numberWithBool:canExchangeAmount] forKey:@"canExchange"];
    }
    
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
