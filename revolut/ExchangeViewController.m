//
//  ExchangeViewController.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewController.h"
#import "ExchangeAccountPickerView.h"
#import "ExchangeViewModel.h"
#import "AppDelegate.h"

@interface ExchangeViewController ()
    
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exchangeButton;
    
@end

@implementation ExchangeViewController {
    ExchangeAccountPickerView *_fromAccountPicker;
    ExchangeAccountPickerView *_toAccountPicker;
    ExchangeViewModel *_viewModel;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _viewModel = [AppDelegate sharedInstance].exchangeViewModel;
}

#pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [_exchangeButton setTarget:_viewModel];
    [_exchangeButton setAction:@selector(exchange)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_viewModel addObserver:self forKeyPath:@"canExchange" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_viewModel removeObserver:self forKeyPath:@"canExchange"];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeTableCell" forIndexPath:indexPath];
    
    UIPageControl *pageControl = [[cell.contentView subviews] objectAtIndex:1];
    
    ExchangeAccountPickerView *accountPicker = [[cell.contentView subviews] objectAtIndex:0];
    accountPicker.backgroundColor = [accountPicker.backgroundColor colorWithAlphaComponent:indexPath.row == 0 ? 0.7 : 1];
    accountPicker.pageControl = pageControl;
    [accountPicker setViewModel:_viewModel andType: indexPath.row == 0 ? kAccountPickerFrom : kAccountPickerTo];
    
    return cell;
}

#pragma mark - NSObject

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"canExchange"]) {
        _exchangeButton.enabled = _viewModel.canExchange;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
