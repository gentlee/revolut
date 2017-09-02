//
//  CurrencyHorizontalScrollView.m
//  revolut
//
//  Created by Alexander Danilov on 02/09/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "CurrencyHorizontalScrollView.h"
#import "CurrencyViewCell.h"
#import "AppDelegate.h"

@implementation CurrencyHorizontalScrollView { // TODO rename to CurrencyPicker
    UserManager *_userManager;
    NSArray *_currencies;
}

@synthesize pageControl;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}
    
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
    
-(void) initialize {
    _userManager = [AppDelegate sharedInstance].userManager;
    _currencies = [[NSArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - UICollectionView
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000; // HACK simulate infinite scroll #1
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CurrencyViewCell" forIndexPath:indexPath];
    [cell setCurrency:[_currencies objectAtIndex:indexPath.row % _currencies.count]];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (pageControl) {
        int contentCenterOffset = scrollView.contentOffset.x + self.frame.size.width / 2;
        pageControl.currentPage = (int)(contentCenterOffset / self.frame.size.width) % _currencies.count;
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
        [_userManager addObserver:self
                       forKeyPath:@"user.accounts"
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial
                          context:nil];
    } else {
        [_userManager removeObserver:self
                          forKeyPath:@"user.accounts"];
    }
}

#pragma mark - NSObject

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSArray *currencies = _userManager.user.accounts.allKeys; // show currencies for each user account
    if (currencies != _currencies && ![currencies isEqualToArray:_currencies]) {
        _currencies = currencies;
        
        [self reloadData];
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:500 inSection:0] // HACK simulate infinite scroll #2
                     atScrollPosition:UICollectionViewScrollPositionNone
                             animated:false];
    }
}

@end
