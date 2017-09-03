//
//  ApiService.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ApiService.h"
#import "XMLDictionary.h"
#include <stdlib.h>

@implementation ApiService
    
-(void)getCurrencyRates:(void (^)(NSDictionary *, NSError *))callback {
    NSURL  *url = [NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *xmlData = [NSDictionary dictionaryWithXMLData:data];
            NSArray *items = items = xmlData[@"Cube"][@"Cube"][@"Cube"];
            
            if (items == nil) {
                error = [NSError errorWithDomain:@"revolut" code:1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Error parsing rates"]}];
            } else {
                NSMutableDictionary *result = [NSMutableDictionary new];
                for (NSDictionary *item in items) { // TODO remove random & stdlib
                    NSDecimalNumber *rate = [[NSDecimalNumber decimalNumberWithString: item[@"_rate"]] decimalNumberByAdding: [[NSDecimalNumber alloc] initWithInt: arc4random_uniform(10)]];
                    [result setValue:rate forKey:item[@"_currency"]];
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    NSLog(@"getCurrencyRates Success: %@", result);
                    callback(result, nil);
                }];
            }
        }
        
        if (error != nil) {
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                NSLog(@"getCurrencyRates Error: %@", error);
                callback(nil, error);
            }];
        }
    }] resume];
}

@end
