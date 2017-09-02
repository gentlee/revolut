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

@interface MainViewController ()
    
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exchangeButton;
    
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyTableCell" forIndexPath:indexPath];
    
    CurrencyHorizontalScrollView *currenciesScrollView = [[cell.contentView subviews] objectAtIndex:0];
    currenciesScrollView.backgroundColor = [currenciesScrollView.backgroundColor colorWithAlphaComponent:indexPath.row == 0 ? 0.7 : 1];
//    [currenciesScrollView setViewController: self];
    return cell;
}

@end
