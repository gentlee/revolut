//
//  AccountPickerView.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"

typedef NS_ENUM(NSUInteger, AccountPickerType) {
    kAccountPickerFrom,
    kAccountPickerTo
};

@interface ExchangeAccountPickerView : UICollectionView<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic, readonly) NSObject<ExchangeViewModel> *viewModel;
@property (nonatomic, readonly) AccountPickerType type;

-(void)setViewModel:(NSObject<ExchangeViewModel> *)viewModel andType:(AccountPickerType)type;

@end
