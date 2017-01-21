//
//  UIViewController+HKScrollingNavAndTabBar.h
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/15.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

/** TopBar收起时停留位置 */
typedef NS_ENUM(NSUInteger, HKScrollingTopBarContractedPosition) {
    /** 停留在顶端,默认位置 */
    HKScrollingTopBarContractedPositionTop = 0,
    /** 停留在状态栏处 */
    HKScrollingTopBarContractedPositionStatusBar,
};

@interface UIViewController (HKScrollingNavAndTabBar)

@property (nonatomic, assign) HKScrollingTopBarContractedPosition hk_topBarContracedPostion;
@property (nonatomic, assign) BOOL hk_alphaFadeEnabled;

- (void)hk_followScrollView:(UIView *)scrollableView;

- (void)hk_stopFollowingScrollView;

/** 如果不设置topBar，则默认为navigationBar */
- (void)hk_managerTopBar:(UIView *)topBar;

- (void)hk_managerbotomBar:(UIView *)bottomBar;

- (void)hk_expand;

- (void)hk_contract;

@end
