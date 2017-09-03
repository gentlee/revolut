//
//  FixedTextField.m
//  revolut
//
//  Created by Alexander Danilov on 03/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "FixedTextField.h"

@implementation FixedTextField

-(CGSize)intrinsicContentSize {
    return self.isEditing && self.text.length ? [super.text sizeWithAttributes:self.typingAttributes] : [super intrinsicContentSize];
}

@end
