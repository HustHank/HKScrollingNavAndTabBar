//
//  HKScrollingNavAndTabBarViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/21.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndTabBarViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

@interface HKScrollingNavAndTabBarViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation HKScrollingNavAndTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    [self hk_followScrollView:self.tableView];
    [self hk_managerTopBar:self.navigationController.navigationBar];
    [self hk_managerBotomBar:self.tabBarController.tabBar];
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        switch (state) {
            case HKScrollingNavAndTabBarStateExpanded:
                NSLog(@"navbar expended");
                break;
            case HKScrollingNavAndTabBarStateExpanding:
                NSLog(@"navbar is expending");
                break;
            case HKScrollingNavAndTabBarStateContracting:
                NSLog(@"navbar is contracting");
                break;
            case HKScrollingNavAndTabBarStateContracted:
                NSLog(@"navbar contracted");
                break;
        }
    }];
}

#pragma mark - Actions

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
