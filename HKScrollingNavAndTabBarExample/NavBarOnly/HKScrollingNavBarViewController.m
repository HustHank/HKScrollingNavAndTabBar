//
//  HKScrollingNavBarViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/21.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavBarViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

@interface HKScrollingNavBarViewController () 

@end

@implementation HKScrollingNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hk_followScrollView:self.tableView];
    self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionStatusBar;
    [self hk_managerTopBar:self.navigationController.navigationBar];
    [self hk_managerBotomBar:self.tabBarController.tabBar];
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        NSLog(@"HKScrollingNavBarViewController state:%ld",(long)state);
    }];
}

@end
