//
//  MainViewController.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "CurrencyHorizontalScrollView.h"
#import "AppDelegate.h"

@interface MainViewController ()
    
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exchangeButton;
    
@end

@implementation MainViewController {
    UserManager *_userManager;
    CurrencyManager *_currencyManager;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _userManager = [AppDelegate sharedInstance].userManager;
        _currencyManager = [AppDelegate sharedInstance].currencyManager;
    }
    return self;
}

#pragma mark - ExchangeViewModel

@synthesize exchangeValue;
@synthesize currencyFrom;
@synthesize currencyTo;
@synthesize canExchange;

- (void)exchange {
    exchangeValue = 0;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyTableCell" forIndexPath:indexPath];
    
    UIPageControl *pageControl = [[cell.contentView subviews] objectAtIndex:1];
    
    CurrencyHorizontalScrollView *currenciesScrollView = [[cell.contentView subviews] objectAtIndex:0];
    currenciesScrollView.backgroundColor = [currenciesScrollView.backgroundColor colorWithAlphaComponent:indexPath.row == 0 ? 0.7 : 1];
    currenciesScrollView.pageControl = pageControl;
    currenciesScrollView.viewModel = self;
    
    return cell;
}

@end
