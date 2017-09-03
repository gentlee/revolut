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
    // HACK fix intrinsic content size while editing
    if (self.isEditing) {
        CGSize size = [self.text sizeWithAttributes:self.typingAttributes];
        size.width += self.leftView.frame.size.width;
        return size;
    }
        
    return [super intrinsicContentSize];
}

@end
