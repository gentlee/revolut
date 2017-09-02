//
//  UserManager.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "UserManager.h"
#import "User.h"

@implementation UserManager
    
@synthesize user = _user;
    
-(instancetype)init {
    self = [super init];
    if (self) {
        _user = [User new];
    }
    return self;
}

@end
