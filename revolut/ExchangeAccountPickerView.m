//
//  AccountPickerView.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ExchangeAccountPickerView.h"
#import "ExchangeAccountPickerViewCell.h"
#import "AppDelegate.h"

@implementation ExchangeAccountPickerView {
    UserManager *_userManager;
    NSArray *_currencies;
}
    
-(void) awakeFromNib {
    [super awakeFromNib];
    
    _userManager = [AppDelegate sharedInstance].userManager;
    _currencies = [[NSArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
}

-(void)setViewModel:(NSObject<ExchangeViewModel> *)viewModel andType:(AccountPickerType)type {
    _viewModel = viewModel;
    _type = type;
}

#pragma mark - UICollectionView
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000; // HACK simulate infinite scroll #1
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeAccountPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExchangeAccountPickerViewCell" forIndexPath:indexPath];
    [cell setViewModel:_viewModel andType:_type andCurrency:[_currencies objectAtIndex:indexPath.row % _currencies.count]];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pageControl) {
        int contentCenterOffset = scrollView.contentOffset.x + self.frame.size.width / 2;
        int currentPage = (int)(contentCenterOffset / self.frame.size.width) % _currencies.count;
        if (_pageControl.currentPage != currentPage) {
            _pageControl.currentPage = currentPage;
            [_viewModel setValue:_currencies[currentPage] forKey:_type == kAccountPickerFrom ? @"currencyFrom" : @"currencyTo" ];
        }
    }
}

#pragma mark - UIView

-(void)layoutSubviews {
    [super layoutSubviews];
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = self.frame.size;
}
    
-(void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [_userManager addObserver:self forKeyPath:@"user.accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
    } else {
        [_userManager removeObserver:self forKeyPath:@"user.accounts"];
    }
}

#pragma mark - NSObject

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"user.accounts"]) {
        NSArray *currencies = _userManager.user.accounts.allKeys; // show currencies for each user account
        if (currencies != _currencies && ![currencies isEqualToArray:_currencies]) {
            _currencies = currencies;
            
            NSLog(@"reload currency picker");
            [self reloadData];
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:500 inSection:0] // HACK simulate infinite scroll #2
                         atScrollPosition:UICollectionViewScrollPositionNone
                                 animated:false];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
