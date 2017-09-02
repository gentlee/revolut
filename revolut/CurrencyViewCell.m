//
//  CurrencyView.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "CurrencyViewCell.h"
#import "AppDelegate.h"
#import "Account.h"

@implementation CurrencyViewCell {
    UserManager *_userManager;
    CurrencyManager *_currencyManager;

    NSString *_accountsKeyPath;
    NSString *_ratesKeyPath;
}

@synthesize currency = _currency;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _userManager = [AppDelegate sharedInstance].userManager;
        _currencyManager = [AppDelegate sharedInstance].currencyManager;
    }
    return self;
}

-(void)setCurrency:(NSString *)currency {
    if ([currency isEqualToString:_currency]) return;
    
    if (_currency) {
        [_userManager removeObserver:self forKeyPath:_accountsKeyPath];
        [_currencyManager removeObserver:self forKeyPath:_ratesKeyPath];
    }
    
    _currency = currency;
    
    if (_currency) {
        _currencyLabel.text = _currency;
        
        _accountsKeyPath = [NSString stringWithFormat:@"%@%@", @"user.accounts.", _currency];
        _ratesKeyPath = [NSString stringWithFormat:@"%@%@", @"rates.", _currency];
        
        [_userManager addObserver:self
                       forKeyPath:_accountsKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial
                          context:nil];
        
        [_userManager addObserver:self
                       forKeyPath:_ratesKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial
                          context:nil];
    }
}

-(void)didMoveToWindow {
    if (!self.window) {
        [self setCurrency:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:_accountsKeyPath]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:_currency];
        
        Account *account = [_userManager.user.accounts valueForKey:_currency];
        _accountValueLabel.text = [NSString localizedStringWithFormat:@"You have %@", [formatter stringFromNumber:account.amount]];
    } else if ([keyPath isEqualToString:_ratesKeyPath]) {
        
    }
}

@end
