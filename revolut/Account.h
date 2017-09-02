//
//  Account.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
    
@property (nonatomic) NSString *currency;
@property (nonatomic) NSDecimalNumber *amount;
    
-(instancetype) initWithCurrency: (NSString *)currency andAmount:(NSDecimalNumber *)amount;

@end
