//
//  UIView+HKExtension.m
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "UIView+HKScrollingNavAndBar.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) NSMutableArray *hk_visibleSubViews;

@end

@implementation UIView (HKScrollingNavAndBar)

#pragma mark - Setter
- (void)setHk_postion:(HKScrollingNavAndBarPosition)hk_postion {
    objc_setAssociatedObject(self, @selector(hk_postion), @(hk_postion), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_extraDistance:(CGFloat)hk_extraDistance {
    objc_setAssociatedObject(self, @selector(hk_extraDistance), @(hk_extraDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_expandedOffsetY:(CGFloat)hk_expandedOffsetY {
    objc_setAssociatedObject(self, @selector(hk_expandedOffsetY), @(hk_expandedOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_alphaFadeEnabled:(BOOL)hk_alphaFadeEnabled {
    objc_setAssociatedObject(self, @selector(hk_alphaFadeEnabled), @(hk_alphaFadeEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_visibleSubViews:(NSMutableArray *)hk_visibleSubViews {
    objc_setAssociatedObject(self, @selector(hk_visibleSubViews), hk_visibleSubViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (HKScrollingNavAndBarPosition)hk_postion {
    return [objc_getAssociatedObject(self, @selector(hk_postion)) unsignedIntegerValue];
}

- (CGFloat)hk_extraDistance {
    return [objc_getAssociatedObject(self, @selector(hk_extraDistance)) floatValue];
}

- (CGFloat)hk_expandedOffsetY {
    return [objc_getAssociatedObject(self, @selector(hk_expandedOffsetY)) floatValue];
}

- (CGFloat)hk_contractedOffsetY {
    CGFloat contractedOffsetY = 0;
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            contractedOffsetY = self.hk_expandedOffsetY - CGRectGetHeight(self.frame) - self.hk_extraDistance;
            break;
        case HKScrollingNavAndBarPositionBottom:
            contractedOffsetY = self.hk_expandedOffsetY + CGRectGetHeight(self.frame) + self.hk_extraDistance;
            break;
        default:
            break;
    }
    
    return contractedOffsetY;
}

- (BOOL)hk_alphaFadeEnabled {
    return [objc_getAssociatedObject(self, @selector(hk_alphaFadeEnabled)) boolValue];
}

- (NSMutableArray *)hk_visibleSubViews {
    return objc_getAssociatedObject(self, @selector(hk_visibleSubViews));
}

#pragma makr - Public Method
- (CGFloat)hk_updateOffsetY:(CGFloat)deltaY {
    
    CGFloat viewOffsetY = 0;
    CGFloat currentViewY = CGRectGetMinY(self.frame);
    CGFloat newOffsetY = [self hk_offsetYWithDelta:deltaY];
    viewOffsetY = currentViewY - newOffsetY;
    
    if (0 == viewOffsetY) {
        return viewOffsetY;
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = newOffsetY;
    self.frame = viewFrame;
    
    if (self.hk_alphaFadeEnabled) {
        CGFloat alpha = (currentViewY - [self hk_viewMinY]) * 1.0f / ([self hk_ViewMaxY] - [self hk_viewMinY]);
        [self hk_updateSubviewsToAlpha:alpha];
        
    } else {
        if ([self hk_isContracted]) {
            [self hk_updateSubviewsToAlpha:0.f];
        } else {
            [self hk_updateSubviewsToAlpha:1.f];
        }
    }
    
    return viewOffsetY;
}

- (CGFloat)hk_expand {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - self.hk_expandedOffsetY;
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = self.hk_expandedOffsetY;
    self.frame = viewFrame;
    
    if (self.hk_alphaFadeEnabled) {
        [self hk_updateSubviewsToAlpha:1.f];
        self.hk_visibleSubViews = nil;
    }

    return viewOffsetY;
}

- (CGFloat)hk_contract {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - self.hk_contractedOffsetY;
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = self.hk_contractedOffsetY;
    self.frame = viewFrame;
    
    if (self.hk_alphaFadeEnabled) {
        [self hk_updateSubviewsToAlpha:0.f];
    }

    return viewOffsetY;
}

- (BOOL)hk_shouldExpand {
    CGFloat viewY = CGRectGetMinY(self.frame);
    CGFloat viewMinY = 0;
    BOOL shouldExpand = YES;
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            viewMinY = self.hk_contractedOffsetY + (self.hk_expandedOffsetY - self.hk_contractedOffsetY) * 0.5;
            shouldExpand = viewY >= viewMinY;
            break;
        case HKScrollingNavAndBarPositionBottom:
            viewMinY = self.hk_expandedOffsetY + (self.hk_contractedOffsetY - self.hk_expandedOffsetY) * 0.5;
            shouldExpand = viewY <= viewMinY;
            break;
        default:
            break;
    }
    
    return shouldExpand;
}

- (CGFloat)hk_viewMinY {
    return MIN(self.hk_expandedOffsetY, self.hk_contractedOffsetY);
}

- (CGFloat)hk_ViewMaxY {
    return MAX(self.hk_expandedOffsetY, self.hk_contractedOffsetY);
}

- (BOOL)hk_isExpanded {
    return CGRectGetMinY(self.frame) == self.hk_expandedOffsetY;
}

- (BOOL)hk_isContracted {
    return CGRectGetMinY(self.frame) == self.hk_contractedOffsetY;
}

#pragma mark - Private Method 

- (CGFloat)hk_offsetYWithDelta:(CGFloat)deltaY {
    CGFloat newOffsetY = 0;
    CGFloat expandedOffsetY = self.hk_expandedOffsetY;
    CGFloat contractedOffsetY = self.hk_contractedOffsetY;
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop: {
            newOffsetY = CGRectGetMinY(self.frame) - deltaY;
            newOffsetY = MAX(contractedOffsetY, MIN(expandedOffsetY, newOffsetY));
            break;
        }
        case HKScrollingNavAndBarPositionBottom: {
            newOffsetY = CGRectGetMinY(self.frame) + deltaY;
            newOffsetY = MIN(contractedOffsetY, MAX(expandedOffsetY, newOffsetY));
            break;
        }
        default:
            break;
    }
    
    return newOffsetY;
}

- (void)hk_updateSubviewsToAlpha:(CGFloat)alpha {
    if (!self.hk_visibleSubViews) {
        self.hk_visibleSubViews = @[].mutableCopy;
        // 遍历子视图，存储背景视图的可见视图
        for (UIView *subView in self.subviews) {
            BOOL isBackgroundView = (subView == self.subviews[0]);
            BOOL isViewHidden = (subView.isHidden || subView.alpha < FLT_EPSILON);
            
            if (!isBackgroundView && !isViewHidden) {
                [self.hk_visibleSubViews addObject:subView];
            }
        }
    }
    
    for (UIView *subView in self.hk_visibleSubViews) {
        subView.alpha = alpha;
    }
}

@end
