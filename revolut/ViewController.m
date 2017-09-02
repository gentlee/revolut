//
//  ViewController.m
//  revolut
//
//  Created by Alexander Danilov on 31/08/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CurrencyHorizontalScrollView.h"

@interface ViewController ()
    
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exchangeButton;
@property (strong, nonatomic) IBOutlet CurrencyHorizontalScrollView *topCollectionView;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topCollectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    _topCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_topCollectionView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
