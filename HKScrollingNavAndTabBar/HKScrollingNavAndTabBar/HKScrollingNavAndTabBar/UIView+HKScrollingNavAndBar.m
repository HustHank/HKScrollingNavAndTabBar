//
//  UIView+HKExtension.m
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "UIView+HKScrollingNavAndBar.h"
#import <objc/runtime.h>

static CGFloat kStatusBarHeight = 20.f;
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation UIView (HKScrollingNavAndBar)

#pragma mark - Setter
- (void)setHk_postion:(HKScrollingNavAndBarPosition)hk_postion {
    objc_setAssociatedObject(self, @selector(hk_postion), @(hk_postion), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHk_extraDistance:(CGFloat)hk_extraDistance {
    objc_setAssociatedObject(self, @selector(hk_extraDistance), @(hk_extraDistance), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Getter

- (HKScrollingNavAndBarPosition)hk_postion {
    NSNumber *postionNumber = objc_getAssociatedObject(self, @selector(hk_postion));
    if (!postionNumber) {
        return HKScrollingNavAndBarPositionTop;
    }
    
    return [postionNumber unsignedIntegerValue];
}

- (CGFloat)hk_extraDistance {
    NSNumber *extraDistanceNumber = objc_getAssociatedObject(self, @selector(hk_extraDistance));
    if (!extraDistanceNumber) {
        return 0;
    }
    
    return [extraDistanceNumber floatValue];
}

#pragma makr - Public Method
- (CGFloat)hk_updateOffsetY:(CGFloat)deltaY {
    
    CGFloat viewOffsetY = 0;
    CGFloat newOffsetY = [self hk_offsetYWithDelta:deltaY];
    viewOffsetY = CGRectGetMinY(self.frame) - newOffsetY;
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = newOffsetY;
    self.frame = viewFrame;
    
    return viewOffsetY;
}

- (CGFloat)hk_open {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - [self hk_openOffsetY];
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = [self hk_openOffsetY];
    self.frame = viewFrame;
    
    return viewOffsetY;
}

- (CGFloat)hk_close {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - [self hk_closeOffsetY];
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = [self hk_closeOffsetY];
    self.frame = viewFrame;
    
    return viewOffsetY;
}

- (BOOL)hk_shouldOpen {
    CGFloat viewY = CGRectGetMinY(self.frame);
    CGFloat viewMinY = [self hk_openOffsetY];
    if (HKScrollingNavAndBarPositionTop == self.hk_postion) {
        viewMinY = [self hk_closeOffsetY] + ([self hk_openOffsetY] - [self hk_closeOffsetY]) * 0.5;
    } else if (HKScrollingNavAndBarPositionBottom == self.hk_postion) {
        viewMinY = [self hk_openOffsetY] + ([self hk_closeOffsetY] - [self hk_openOffsetY]) * 0.5;
    } else {
        
    }
    
    if (viewY <= viewMinY) {
        return NO;
    }
    return YES;
}

#pragma mark - Private Method 

- (CGFloat)hk_offsetYWithDelta:(CGFloat)deltaY {
    CGFloat newOffsetY = 0;
    CGFloat openOffsetY = [self hk_openOffsetY];
    CGFloat closeOffsetY = [self hk_closeOffsetY];
    
    if (HKScrollingNavAndBarPositionTop == self.hk_postion) {
        newOffsetY = CGRectGetMinY(self.frame) - deltaY;
        newOffsetY = MAX(closeOffsetY, MIN(openOffsetY, newOffsetY));
    } else if (HKScrollingNavAndBarPositionBottom == self.hk_postion) {
        newOffsetY = CGRectGetMinY(self.frame) + deltaY;
        newOffsetY = MIN(closeOffsetY, MAX(openOffsetY, newOffsetY));
    } else {
        
    }
    return newOffsetY;
}

- (CGFloat)hk_openOffsetY {
    CGFloat openOffsetY = 0;
    if (HKScrollingNavAndBarPositionTop == self.hk_postion) {
        openOffsetY = kStatusBarHeight;
    } else if (HKScrollingNavAndBarPositionBottom == self.hk_postion) {
        openOffsetY = kScreenHeight - CGRectGetHeight(self.frame);
    }
    
    return openOffsetY;

}

- (CGFloat)hk_closeOffsetY {
    CGFloat closeOffsetY = 0;
    if (HKScrollingNavAndBarPositionTop == self.hk_postion) {
        closeOffsetY = -(CGRectGetHeight(self.frame) + self.hk_extraDistance);
    } else if (HKScrollingNavAndBarPositionBottom == self.hk_postion) {
        closeOffsetY = kScreenHeight + CGRectGetHeight(self.frame) + self.hk_extraDistance;
    }
    
    return closeOffsetY;
}

@end
