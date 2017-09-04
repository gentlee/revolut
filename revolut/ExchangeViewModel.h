//
//  ExchangeViewModel.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountManager.h"
#import "CurrencyManager.h"

@interface ExchangeViewModel: NSObject

- (instancetype)initWith:(AccountManager *)accountManager and:(CurrencyManager *)currencyManager;

@property (nonatomic) NSDecimalNumber *valueFrom;
@property (nonatomic) NSDecimalNumber *valueTo; // can't observe
@property (nonatomic) NSString *currencyFrom;
@property (nonatomic) NSString *currencyTo;
@property (nonatomic, readonly) BOOL canExchange;

-(void)exchange;

@end
