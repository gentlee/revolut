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
    AccountManager *_accountManager;
    NSArray *_currencies;
}
    
-(void) awakeFromNib {
    [super awakeFromNib];
    
    _accountManager = [AppDelegate sharedInstance].accountManager;
    _currencies = [[NSArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
}

-(void)setViewModel:(ExchangeViewModel *)viewModel andType:(AccountPickerType)type {
    _viewModel = viewModel;
    _type = type;
    
    [self scrollToProperAccount];
}

-(int)currentPage {
    CGFloat contentCenterOffset = self.contentOffset.x + self.frame.size.width / 2;
    return (int)(contentCenterOffset / self.frame.size.width) % _currencies.count;
}

-(NSString *)currentCurrency {
    return _currencies[[self currentPage]];
}

-(void)scrollToProperAccount {
    if (!_viewModel) return;
    
    NSString *currency = _type == kAccountPickerFrom ? _viewModel.currencyFrom : _viewModel.currencyTo;
    if ([[self currentCurrency] isEqualToString:currency]) return;
        
    // HACK simulate infinite scroll #2
    
    NSInteger accountIndex = [_currencies indexOfObject:currency];
    NSInteger centerPosition = [self numberOfItemsInSection:0] / 2;
    NSInteger centerCurrencyPosition = centerPosition - centerPosition % _currencies.count + accountIndex;
    
    [self layoutIfNeeded]; // HACK layoutIfNeeded makes scrollToItemAtIndexPath always work
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:centerCurrencyPosition inSection:0]
                 atScrollPosition:UICollectionViewScrollPositionLeft
                         animated:false];
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
        int currentPage = [self currentPage];
        if (_pageControl.currentPage != currentPage) {
            _pageControl.currentPage = currentPage;
            [_viewModel setValue:_currencies[currentPage] forKey:_type == kAccountPickerFrom ? @"currencyFrom" : @"currencyTo" ];
            [self endEditing:true];
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
        [_accountManager addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
        [self scrollToProperAccount];
    } else {
        [_accountManager removeObserver:self forKeyPath:@"accounts"];
    }
}

#pragma mark - NSObject

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"accounts"]) {
        NSArray *currencies = _accountManager.accounts.allKeys; // show currencies for each account
        if (currencies != _currencies && ![currencies isEqualToArray:_currencies]) {
            _currencies = currencies;
            
            NSLog(@"reload currency picker");
            [self reloadData];
            [self scrollToProperAccount];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
