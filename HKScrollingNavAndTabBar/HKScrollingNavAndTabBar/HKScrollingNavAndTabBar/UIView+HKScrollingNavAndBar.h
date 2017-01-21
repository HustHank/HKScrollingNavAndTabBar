//
//  UIView+HKExtension.h
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKScrollingNavAndBarPosition) {
    ///NavBar
    HKScrollingNavAndBarPositionTop = 0,
    ///TabBar
    HKScrollingNavAndBarPositionBottom,
};

@interface UIView (HKScrollingNavAndBar)

//NavBar or TabBar
@property (nonatomic, assign) HKScrollingNavAndBarPosition hk_postion;
///需要额外移动的距离
@property (nonatomic, assign) CGFloat hk_extraDistance;
///是否需要在滑动过程中透明度渐变
@property (nonatomic, assign) BOOL hk_alphaFadeEnabled;

- (CGFloat)hk_updateOffsetY:(CGFloat)deltaY;

- (CGFloat)hk_expand;

- (CGFloat)hk_contract;

- (BOOL)hk_shouldExpand;

- (BOOL)hk_isExpanded;

- (BOOL)hk_isContracted;

@end
