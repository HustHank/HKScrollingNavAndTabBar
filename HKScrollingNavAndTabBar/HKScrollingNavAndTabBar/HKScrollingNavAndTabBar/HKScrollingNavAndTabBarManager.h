//
//  HKScrollingNavAndTabBarManager.h
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/16.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** TopBar收起时停留位置 */
typedef NS_ENUM(NSUInteger, HKScrollingTopBarContractedPosition) {
    /** 停留在顶端,默认位置 */
    HKScrollingTopBarContractedPositionTop = 0,
    /** 停留在状态栏处 */
    HKScrollingTopBarContractedPositionStatusBar,
};

/** BottomBar收起时停留位置 */
typedef NS_ENUM(NSUInteger, HKScrollingBottomBarContractedPosition) {
    /** 停留在顶端,默认位置 */
    HKScrollingBottomBarContractedPositionBottom = 0,
    /** 停留在凸出位置 */
    HKScrollingBottomBarContractedPositionExceeded,
};

@interface HKScrollingNavAndTabBarManager : NSObject

@property (nonatomic, assign) HKScrollingTopBarContractedPosition topBarContracedPostion;
@property (nonatomic, assign) HKScrollingBottomBarContractedPosition bottomBarContracedPostion;

- (instancetype)initWithController:(UIViewController *)viewController scrollableView:(UIView *)scrollableView;

/** 如果不设置topBar，则默认为navigationBar */
- (void)managerTopBar:(UIView *)topBar;

- (void)managerbotomBar:(UIView *)bottomBar;

- (void)expand;

- (void)contract;

@end
