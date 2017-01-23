//
//  UIView+HKExtension.h
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKScrollingNavAndBarPosition) {
    /** 顶部Bar */
    HKScrollingNavAndBarPositionTop = 0,
    /** 底部Bar */
    HKScrollingNavAndBarPositionBottom,
};

@interface UIView (HKScrollingNavAndBar)

/** Bar类型 */
@property (nonatomic, assign) HKScrollingNavAndBarPosition hk_postion;
/** 需要额外移动的距离 */
@property (nonatomic, assign) CGFloat hk_extraDistance;
/** Bar展开时的Y坐标 */
@property (nonatomic, assign) CGFloat hk_expandedOffsetY;
/** Bar收起时的Y坐标 */
@property (nonatomic, readonly, assign) CGFloat hk_contractedOffsetY;
/** 是否需要在滑动过程中透明度渐变 */
@property (nonatomic, assign) BOOL hk_alphaFadeEnabled;

/** 根据偏移移动当前View */
- (CGFloat)hk_updateOffsetY:(CGFloat)deltaY;

/** 手动展开 */
- (CGFloat)hk_expand;

/** 手动收起 */
- (CGFloat)hk_contract;

/** 是否需要展开 */
- (BOOL)hk_shouldExpand;

/** 是否已经展开 */
- (BOOL)hk_isExpanded;

/** 是否已经收起 */
- (BOOL)hk_isContracted;

@end
