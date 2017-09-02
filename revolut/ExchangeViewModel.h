//
//  ExchangeViewModel.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

@protocol ExchangeViewModel

@property (nonatomic) NSDecimalNumber *exchangeValue;
@property (nonatomic) NSString *currencyFrom;
@property (nonatomic) NSString *currencyTo;
@property (nonatomic, readonly) BOOL canExchange;

-(void)exchange;

@end
