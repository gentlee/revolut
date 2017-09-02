//
//  ApiService.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiService : NSObject

-(void) getCurrencyRates:(void (^)(NSDictionary *, NSError *))callback;

@end
