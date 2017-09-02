//
//  CurrencyHorizontalScrollView.h
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"

@interface CurrencyHorizontalScrollView : UICollectionView<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) NSObject<ExchangeViewModel> *viewModel;

@end
