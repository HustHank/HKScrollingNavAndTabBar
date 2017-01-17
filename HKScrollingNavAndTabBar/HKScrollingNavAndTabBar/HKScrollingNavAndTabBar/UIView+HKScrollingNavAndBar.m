//
//  UIView+HKExtension.m
//  YingKe
//
//  Created by HK on 17/1/7.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "UIView+HKScrollingNavAndBar.h"
#import <objc/runtime.h>

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

- (CGFloat)hk_expand {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - [self hk_openOffsetY];
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = [self hk_openOffsetY];
    self.frame = viewFrame;
    
    return viewOffsetY;
}

- (CGFloat)hk_contract {
    CGFloat viewOffsetY = 0;
    viewOffsetY = CGRectGetMinY(self.frame) - [self hk_closeOffsetY];
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = [self hk_closeOffsetY];
    self.frame = viewFrame;
    
    return viewOffsetY;
}

- (BOOL)hk_shouldExpand {
    CGFloat viewY = CGRectGetMinY(self.frame);
    CGFloat viewMinY = 0;
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            viewMinY = [self hk_closeOffsetY] + ([self hk_openOffsetY] - [self hk_closeOffsetY]) * 0.5;
            break;
        case HKScrollingNavAndBarPositionBottom:
            viewMinY = [self hk_openOffsetY] + ([self hk_closeOffsetY] - [self hk_openOffsetY]) * 0.5;
            break;
        default:
            break;
    }
    
    if (viewY <= viewMinY) {
        return NO;
    }
    return YES;
}

- (BOOL)hk_isExpanded {
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            return ([self hk_statusBarHeight] + CGRectGetHeight(self.frame)) == CGRectGetMaxY(self.frame);
        case HKScrollingNavAndBarPositionBottom:
            return ([self hk_screenHeight] - CGRectGetHeight(self.frame)) == CGRectGetMinY(self.frame);
        default:
            break;
    }

    return YES;
}

- (BOOL)hk_isContracted {
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            return 0 == CGRectGetMaxY(self.frame);
        case HKScrollingNavAndBarPositionBottom:
            return [self hk_screenHeight] == CGRectGetMinY(self.frame);
        default:
            break;
    }
    
    return NO;
}

#pragma mark - Private Method 

- (CGFloat)hk_offsetYWithDelta:(CGFloat)deltaY {
    CGFloat newOffsetY = 0;
    CGFloat openOffsetY = [self hk_openOffsetY];
    CGFloat closeOffsetY = [self hk_closeOffsetY];
    
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop: {
            newOffsetY = CGRectGetMinY(self.frame) - deltaY;
            newOffsetY = MAX(closeOffsetY, MIN(openOffsetY, newOffsetY));
            break;
        }
        case HKScrollingNavAndBarPositionBottom: {
            newOffsetY = CGRectGetMinY(self.frame) + deltaY;
            newOffsetY = MIN(closeOffsetY, MAX(openOffsetY, newOffsetY));
            break;
        }
        default:
            break;
    }
    
    return newOffsetY;
}

- (CGFloat)hk_openOffsetY {
    CGFloat openOffsetY = 0;
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            openOffsetY = [self hk_statusBarHeight];
            break;
        case HKScrollingNavAndBarPositionBottom:
            openOffsetY = [self hk_screenHeight] - CGRectGetHeight(self.frame);
            break;
        default:
            break;
    }
    
    return openOffsetY;

}

- (CGFloat)hk_statusBarHeight {
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        return 0;
    }
    
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (CGFloat)hk_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)hk_closeOffsetY {
    CGFloat closeOffsetY = 0;
    switch (self.hk_postion) {
        case HKScrollingNavAndBarPositionTop:
            closeOffsetY = -(CGRectGetHeight(self.frame) + self.hk_extraDistance);
            break;
        case HKScrollingNavAndBarPositionBottom:
            closeOffsetY = [self hk_screenHeight] + CGRectGetHeight(self.frame) + self.hk_extraDistance;
            break;
        default:
            break;
    }

    return closeOffsetY;
}

@end
