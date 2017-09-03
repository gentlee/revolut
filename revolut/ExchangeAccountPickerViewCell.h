//
//  CurrencyView.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"
#import "ExchangeAccountPickerView.h"

@interface ExchangeAccountPickerViewCell : UICollectionViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UITextField *transferField;

@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSObject<ExchangeViewModel> *viewModel;
@property (nonatomic, readonly) AccountPickerType type;

-(void)setViewModel:(NSObject<ExchangeViewModel> *)viewModel andType:(AccountPickerType)type andCurrency:(NSString *)currency;

@end
