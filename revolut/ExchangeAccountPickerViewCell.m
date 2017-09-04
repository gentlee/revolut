//
//  CurrencyView.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ExchangeAccountPickerViewCell.h"
#import "AppDelegate.h"
#import "Account.h"

static NSNumberFormatter *currencyFormatter;
static NSNumberFormatter *decimalFormatter;
static NSRegularExpression *removeLeadingZerosRegex;

@implementation ExchangeAccountPickerViewCell {
    AccountManager *_accountManager;
    CurrencyManager *_currencyManager;
    
    UILabel *_fieldLeftView;
    UITapGestureRecognizer *_tapGesture;

    NSString *_accountsKeyPath;
    NSString *_ratesKeyPath;
}

+(void)initialize {
    if (!currencyFormatter) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        decimalFormatter = [[NSNumberFormatter alloc] init];
        decimalFormatter.minimumFractionDigits = 0;
        decimalFormatter.currencySymbol = @"";
        
        removeLeadingZerosRegex = [NSRegularExpression
                                   regularExpressionWithPattern:@"^(0*)(\\d.*)"
                                   options:NSRegularExpressionCaseInsensitive
                                   error:nil];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    _accountManager = [AppDelegate sharedInstance].accountManager;
    _currencyManager = [AppDelegate sharedInstance].currencyManager;
    
    _fieldLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, _transferField.frame.size.height)];
    _fieldLeftView.textColor = _transferField.textColor;
    _fieldLeftView.font = _transferField.font;
    
    _transferField.leftView = _fieldLeftView;
    _transferField.leftViewMode = UITextFieldViewModeAlways;
    _transferField.delegate = self;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_transferField action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:_tapGesture];
}

-(void)setViewModel:(ExchangeViewModel *)viewModel andType:(AccountPickerType)type andCurrency:(NSString *)currency {
    if (_viewModel != viewModel) {
        if (_viewModel) {
            [_viewModel removeObserver:self forKeyPath:@"valueFrom"];
            [_viewModel removeObserver:self forKeyPath:@"currencyFrom"];
            [_viewModel removeObserver:self forKeyPath:@"currencyTo"];
        }
        
        _viewModel = viewModel;
        
        if (_viewModel) {
            [_viewModel addObserver:self forKeyPath:@"valueFrom" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
            [_viewModel addObserver:self forKeyPath:@"currencyFrom" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
            [_viewModel addObserver:self forKeyPath:@"currencyTo" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
        }
    }
    
    if (![currency isEqualToString:_currency]) {
        if (_currency) {
            [_accountManager removeObserver:self forKeyPath:_accountsKeyPath];
            [_currencyManager removeObserver:self forKeyPath:_ratesKeyPath];
        }
        
        _currency = currency;
        
        if (_currency) {
            _currencyLabel.text = _currency;
            
            _accountsKeyPath = [NSString stringWithFormat:@"%@%@", @"accounts.", _currency];
            _ratesKeyPath = [NSString stringWithFormat:@"%@%@", @"rates.", _currency];
            
            [_accountManager addObserver:self forKeyPath:_accountsKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
            [_currencyManager addObserver:self forKeyPath:_ratesKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
        }
    }
    
    _type = type;
    
    _fieldLeftView.text = _type == kAccountPickerFrom ? @"-" : @"+";
}

#pragma mark - UITextField

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789,."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL isNumber = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    if (isNumber) {
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:finalString];
        if ([number compare:NSDecimalNumber.notANumber] == NSOrderedSame) {
            number = NSDecimalNumber.zero;
            finalString = @"0";
        }
        
        finalString = [removeLeadingZerosRegex stringByReplacingMatchesInString:finalString
                                                                        options:0
                                                                          range:NSMakeRange(0, [finalString length])
                                                                   withTemplate:@"$2"];
        
        textField.text = finalString;
        
        if (_type == kAccountPickerFrom) {
            _viewModel.valueFrom = number;
        } else {
            _viewModel.valueTo = number;
        }
    }
    
    return FALSE;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [decimalFormatter stringFromNumber: _type == kAccountPickerFrom ? _viewModel.valueFrom : _viewModel.valueTo];
}

#pragma mark - UIView

-(void)didMoveToWindow {
    if (!self.window) {
        [self setViewModel:nil andType:0 andCurrency:nil];
    }
}

#pragma mark - NSObject

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:_accountsKeyPath]) {
        [currencyFormatter setCurrencyCode:_currency];
        Account *account = [_accountManager.accounts valueForKey:_currency];
        _accountValueLabel.text = [NSString localizedStringWithFormat:@"You have %@", [currencyFormatter stringFromNumber:account.amount]];
    }
    
    else if ([keyPath isEqualToString:_ratesKeyPath] || [keyPath isEqualToString:@"valueFrom"] || [keyPath isEqualToString:@"currencyFrom"] || [keyPath isEqualToString:@"currencyTo"]) {
        [currencyFormatter setCurrencyCode:_currency];
        NSDecimalNumber *fromValue = [[NSDecimalNumber alloc] initWithInt:1];
        NSString *fromText = [currencyFormatter stringFromNumber: fromValue];
        
        NSString *currencyTo = _type == kAccountPickerFrom ? _viewModel.currencyTo : _viewModel.currencyFrom;
        [currencyFormatter setCurrencyCode:currencyTo];
        NSDecimalNumber *toValue = [_currencyManager getExchangeRateOfValue:fromValue from:_currency to:currencyTo];
        NSString *toText = [currencyFormatter stringFromNumber: toValue];
        _rateLabel.text = [NSString stringWithFormat:@"%@ = %@", fromText, toText];
        
        NSDecimalNumber *currentExchangeValue = _type == kAccountPickerFrom ? _viewModel.valueFrom : _viewModel.valueTo;
        if (!_transferField.isEditing && [[NSDecimalNumber decimalNumberWithString:_transferField.text] compare:currentExchangeValue] != NSOrderedSame) {
            decimalFormatter.currencyCode = _currency;
            _transferField.text = [decimalFormatter stringFromNumber:currentExchangeValue];
        }
    }
    
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
