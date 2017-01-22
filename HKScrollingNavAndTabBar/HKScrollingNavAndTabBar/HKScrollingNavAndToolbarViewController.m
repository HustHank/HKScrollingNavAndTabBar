//
//  HKScrollingNavAndToolbarViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/21.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndToolbarViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

static const CGFloat kToolbarHeight = 50.f;

@interface HKScrollingNavAndToolbarViewController ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation HKScrollingNavAndToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.toolbar];
    
    [self hk_followScrollView:self.tableView];
    [self hk_managerBotomBar:self.toolbar];
    self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        NSLog(@"state:%ld",(long)state);
    }];
}

#pragma mark - Getters

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kToolbarHeight, CGRectGetWidth(self.view.frame), kToolbarHeight);
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *bookmarkItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
        _toolbar.items = @[addItem,flexibleSpaceItem,bookmarkItem];
        _toolbar.backgroundColor = [UIColor orangeColor];
    }
    return _toolbar;
}

@end
