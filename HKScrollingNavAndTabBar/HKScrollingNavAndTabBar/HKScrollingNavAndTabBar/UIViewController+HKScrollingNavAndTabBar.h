//
//  UIViewController+HKScrollingNavAndTabBar.h
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/15.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKScrollingNavAndTabBarState) {
    /** 展开状态，默认状态 */
    HKScrollingNavAndTabBarStateExpanded = 0,
    /** 展开中状态 */
    HKScrollingNavAndTabBarStateExpanding,
    /** 收起中状态 */
    HKScrollingNavAndTabBarStateContracting,
    /** 收起状态 */
    HKScrollingNavAndTabBarStateContracted,
};

/** TopBar收起时停留位置 */
typedef NS_ENUM(NSUInteger, HKScrollingTopBarContractedPosition) {
    /** 停留在顶端,默认位置 */
    HKScrollingTopBarContractedPositionTop = 0,
    /** 停留在状态栏处 */
    HKScrollingTopBarContractedPositionStatusBar,
};

typedef void(^HKScrollingBarDidChangeBlock)(HKScrollingNavAndTabBarState barState);

@interface UIViewController (HKScrollingNavAndTabBar)

/** topBar收起停留位置 */
@property (nonatomic, assign) HKScrollingTopBarContractedPosition hk_topBarContracedPostion;
/** 收起或展开过程中，是否需要变化Bar的透明度 */
@property (nonatomic, assign) BOOL hk_alphaFadeEnabled;

/** 开始根据scrollableView移动Bar */
- (void)hk_followScrollView:(UIView *)scrollableView;

/** 停止移动Bar */
- (void)hk_stopFollowingScrollView;

/** 设置顶部Bar，如果不设置topBar，则默认为navigationBar */
- (void)hk_managerTopBar:(UIView *)topBar;

/** 设置底部Bar */
- (void)hk_managerbotomBar:(UIView *)bottomBar;

/** 手动展开Bar */
- (void)hk_expand;

/** 手动收起Bar */
- (void)hk_contract;

/** 设置Bar状态监听回调函数 */
- (void)hk_setBarDidChangeStateBlock:(HKScrollingBarDidChangeBlock)block;

@end
