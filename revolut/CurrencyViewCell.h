//
//  CurrencyView.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UITextField *transferField;

@property (nonatomic) NSString *currency;

@end
