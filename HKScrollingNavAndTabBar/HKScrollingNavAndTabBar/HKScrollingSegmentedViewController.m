//
//  HKScrollingSegmentedViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/23.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingSegmentedViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

@interface HKScrollingSegmentedViewController ()

@end

@implementation HKScrollingSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = self.segmentedControl;
}

#pragma mark - Actions

- (void)segmentAction:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self hk_managerTopBar:self.navigationController.navigationBar];
            [self hk_managerBotomBar:self.tabBarController.tabBar];
            break;
        case 1:
            [self hk_managerTopBar:self.navigationController.navigationBar];
            [self hk_managerBotomBar:nil];
            break;
        case 2:
            [self hk_managerTopBar:nil];
            [self hk_managerBotomBar:self.tabBarController.tabBar];
            break;
        default:
            break;
    }
}

#pragma mark - Getters

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]
                             initWithItems:@[
                                             @"Nav&Tab Bar",
                                             @"NavBar only",
                                             @"TabBar only",
                                             ]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.frame = CGRectMake(0, 0, 100, 30);
        [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
