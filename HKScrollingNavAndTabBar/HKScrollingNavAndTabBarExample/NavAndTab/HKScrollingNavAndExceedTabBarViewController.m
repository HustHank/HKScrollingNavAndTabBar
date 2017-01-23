//
//  HKScrollingNavAndExceedTabBarViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/23.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndExceedTabBarViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

@interface HKScrollingNavAndExceedTabBarViewController ()

@end

@implementation HKScrollingNavAndExceedTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    [self hk_followScrollView:self.tableView];
    [self hk_managerTopBar:self.navigationController.navigationBar];
    [self hk_managerBotomBar:self.tabBarController.tabBar];
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        NSLog(@"HKScrollingNavAndTabBarViewController state:%ld",(long)state);
    }];
}

#pragma mark - Actions

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
