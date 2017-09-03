//
//  MainViewController.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ExchangeAccountPickerView.h"
#import "AppDelegate.h"

@interface MainViewController ()
    
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exchangeButton;
    
@end

@implementation MainViewController {
    UserManager *_userManager;
    CurrencyManager *_currencyManager;
    
    ExchangeAccountPickerView *_fromAccountPicker;
    ExchangeAccountPickerView *_toAccountPicker;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    _userManager = [AppDelegate sharedInstance].userManager;
    _currencyManager = [AppDelegate sharedInstance].currencyManager;
    
    currencyFrom = _userManager.user.accounts.allKeys[0];
    currencyTo = _userManager.user.accounts.allKeys[1];
    valueFrom = NSDecimalNumber.zero;
}

#pragma mark - ExchangeViewModel

@synthesize valueFrom;
@synthesize currencyTo;
@synthesize currencyFrom;
@synthesize canExchange;

- (void)setValueTo:(NSDecimalNumber *)value {
    valueFrom = [_currencyManager getExchangeRateOfValue:value from:currencyTo to:currencyFrom];
}

- (NSDecimalNumber *)valueTo {
    return [_currencyManager getExchangeRateOfValue:valueFrom from:currencyFrom to:currencyTo];;
}

- (void)exchange {
    [_userManager exchangeAmount:valueFrom from:currencyFrom to:currencyTo];
    valueFrom = NSDecimalNumber.zero;
}

#pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [_exchangeButton setTarget:self];
    [_exchangeButton setAction:@selector(exchange)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"valueFrom" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"currencyFrom" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"canExchange" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeObserver:self forKeyPath:@"valueFrom"];
    [self removeObserver:self forKeyPath:@"currencyFrom"];
    [self removeObserver:self forKeyPath:@"canExchange"];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyTableCell" forIndexPath:indexPath];
    
    UIPageControl *pageControl = [[cell.contentView subviews] objectAtIndex:1];
    
    ExchangeAccountPickerView *accountPicker = [[cell.contentView subviews] objectAtIndex:0];
    accountPicker.backgroundColor = [accountPicker.backgroundColor colorWithAlphaComponent:indexPath.row == 0 ? 0.7 : 1];
    accountPicker.pageControl = pageControl;
    [accountPicker setViewModel:self andType: indexPath.row == 0 ? kAccountPickerFrom : kAccountPickerTo];
    
    return cell;
}

#pragma mark - NSObject

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"canExchange"]) {
        NSLog(@"update exchangeButton");
        _exchangeButton.enabled = canExchange;
    } else if ([keyPath isEqualToString:@"valueFrom"] || [keyPath isEqualToString:@"currencyFrom"]) {
        BOOL canExchangeAmount =
            [valueFrom compare:NSDecimalNumber.zero] != NSOrderedSame &&
            [_userManager canExchangeAmount:valueFrom from:currencyFrom];
        
        [self setValue:[NSNumber numberWithBool:canExchangeAmount] forKey:@"canExchange"];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
