//
//  UIViewController+HKScrollingNavAndTabBar.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/15.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "UIViewController+HKScrollingNavAndTabBar.h"
#import "UIView+HKScrollingNavAndBar.h"
#import <objc/runtime.h>

@interface UIViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *hk_scrollableView;
@property (nonatomic, weak) UIView *hk_topBar;
@property (nonatomic, weak) UIView *hk_bottomBar;

@property (nonatomic, strong) UIPanGestureRecognizer *hk_panGesture;

@property (nonatomic, assign) CGFloat hk_previousOffsetY;
@property (nonatomic, assign) CGFloat hk_topInset;

@property (nonatomic, copy) HKScrollingBarDidChangeBlock hk_barStateBlock;

@end

@implementation UIViewController (HKScrollingNavAndTabBar)

#pragma mark - Public Method

- (void)hk_followScrollView:(UIView *)scrollableView {
    self.hk_scrollableView = scrollableView;
    self.hk_topBar = self.navigationController.navigationBar;
    self.hk_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hk_handlePanGesture:)];
    [self.hk_panGesture setMaximumNumberOfTouches:1];
    
    [self.hk_panGesture setDelegate:self];
    [self.hk_scrollableView  addGestureRecognizer:self.hk_panGesture];
    self.hk_alphaFadeEnabled = YES;
}

- (void)hk_stopFollowingScrollView {
    [self hk_expand];
    [self.hk_scrollableView removeGestureRecognizer:self.hk_panGesture];
    
    self.hk_scrollableView = nil;
    self.hk_panGesture = nil;
}

- (void)hk_managerTopBar:(UIView *)topBar {
    self.hk_topBar = topBar;
    self.hk_topBar.hk_postion = HKScrollingNavAndBarPositionTop;
    self.hk_topBar.hk_alphaFadeEnabled = self.hk_alphaFadeEnabled;
}

- (void)hk_managerbotomBar:(UIView *)bottomBar {
    self.hk_bottomBar = bottomBar;
    self.hk_bottomBar.hk_postion = HKScrollingNavAndBarPositionBottom;
    self.hk_bottomBar.hk_alphaFadeEnabled = self.hk_alphaFadeEnabled;
    self.hk_bottomBar.hk_extraDistance = [self hk_exceededDistanceOfBottomBar];
}

- (void)hk_expand {
    [self.hk_topBar hk_expand];
    [self.hk_bottomBar hk_expand];
}

- (void)hk_contract {
    [self.hk_topBar hk_contract];
    [self.hk_bottomBar hk_contract];
}

- (void)hk_setBarDidChangeStateBlock:(HKScrollingBarDidChangeBlock)block {
    self.hk_barStateBlock = block;
}

#pragma mark - Private Mehod

- (CGFloat)hk_exceededDistanceOfBottomBar {
    CGFloat exceededDistance = 0.f;
    CGFloat minSubViewOffsetY = 0.f;
    
    for (UIView *subView in self.hk_bottomBar.subviews) {
        BOOL isViewHidden = (subView.isHidden || subView.alpha < FLT_EPSILON);
        if (!isViewHidden) {
            CGFloat subViewOffsetY = CGRectGetMinY(subView.frame);
            minSubViewOffsetY = MIN(minSubViewOffsetY, subViewOffsetY);
        }
    }
    
    exceededDistance = -minSubViewOffsetY;
    return exceededDistance;
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

- (BOOL)hk_isViewControllerVisible {
    return self.isViewLoaded && self.view.window != nil;
}

#pragma mark - Gesture

- (void)hk_handlePanGesture:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.hk_topInset = self.navigationController.navigationBar.frame.size.height + [self hk_statusBarHeight];
            [self hk_handleScrolling];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self hk_handleScrolling];
            break;
        }
        default: {
            CGFloat velocity = [gesture velocityInView:self.hk_scrollableView].y;
            [self hk_handleScrollingEnded:velocity];
            break;
        }
    }
}

- (void)hk_handleScrolling {
    //在push到其他页面时候，还是会走该方法，这个时候不应该继续执行
    if (!(self.isViewLoaded && self.view.window != nil)) {
        return;
    }
    
    // 1 - 计算偏移量
    CGFloat contentOffsetY = self.hk_scrollView.contentOffset.y;
    CGFloat deltaY = contentOffsetY - self.hk_previousOffsetY;
    
    // 2 - 忽略超出滑动范围的Offset
    // 1) - 忽略向上滑动的Offset
    CGFloat start = -self.hk_topInset;
    if (self.hk_previousOffsetY <= start) {
        deltaY = MAX(0, deltaY + (self.hk_previousOffsetY - start));
    }
    
    // 2) - 忽略向下滑动的Offset
    CGFloat maxContentOffset = self.hk_scrollView.contentSize.height - self.hk_scrollView.frame.size.height + self.hk_scrollView.contentInset.bottom;
    CGFloat end = maxContentOffset;
    if (self.hk_previousOffsetY >= end) {
        deltaY = MIN(0, deltaY + (self.hk_previousOffsetY - maxContentOffset));
    }
    
    // 3 - 更新navBar和TabBar的frame
    [self.hk_topBar hk_updateOffsetY:deltaY];
    [self.hk_bottomBar hk_updateOffsetY:deltaY];
    
    // 4 - 更新TableView的contentInset
    [self hk_updateScrollViewInset];
    
    // 5 - 保存当前的contentOffsetY
    self.hk_previousOffsetY = contentOffsetY;
    
    // 6 - 更新Bar状态，并进行回调
    HKScrollingNavAndTabBarState barState = [self hk_getBarStateWithDelta:deltaY];
    if (self.hk_barStateBlock) {
        self.hk_barStateBlock(barState);
    }
}

- (void)hk_handleScrollingEnded:(CGFloat)velocity {
    CGFloat minVelocity = 500.f;
    if (![self hk_isViewControllerVisible] || ([self.hk_topBar hk_isContracted] && velocity < minVelocity)) {
        return;
    }
    
    if (!self.hk_topBar && !self.hk_bottomBar) {
        return;
    }
    
    //NavBar和TabBar是展开还是收起
    BOOL shouldExpanded = YES;
    if (self.hk_topBar) {
        shouldExpanded = [self.hk_topBar hk_shouldExpand];
    } else if (self.hk_bottomBar) {
        shouldExpanded = [self.hk_bottomBar hk_shouldExpand];
    } else {
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat navBarOffsetY = 0;
        if (shouldExpanded) {
            //navBarOffsetY为NavBar从当前位置到展开滑动的距离
            navBarOffsetY = [self.hk_topBar hk_expand];
            [self.hk_bottomBar hk_expand];
        } else {
            //navBarOffsetY为NavBar从当前位置到收起滑动的距离
            navBarOffsetY = [self.hk_topBar hk_contract];
            [self.hk_bottomBar hk_contract];
        }
        //更新ScrollView的contentInset
        [self hk_updateScrollViewInset];
        //根据NavBar的偏移量来滑动TableView
        if (shouldExpanded) {
            CGPoint contentOffset = self.hk_scrollView.contentOffset;
            contentOffset.y += navBarOffsetY;
            self.hk_scrollView.contentOffset = contentOffset;
        }
    }];
}

- (void)hk_updateScrollViewInset {
    UIEdgeInsets scrollViewInset = self.hk_scrollView.contentInset;
    if (self.hk_topBar) {
        CGFloat navBarMaxY = CGRectGetMaxY(self.hk_topBar.frame);
        scrollViewInset.top = navBarMaxY;
    }
    
    if (self.hk_bottomBar) {
        CGFloat tabBarMinY = CGRectGetMinY(self.hk_bottomBar.frame);
        scrollViewInset.bottom = MAX(0, [self hk_screenHeight] - tabBarMinY);
    }
    
    self.hk_scrollView.contentInset = scrollViewInset;
    self.hk_scrollView.scrollIndicatorInsets = scrollViewInset;
}

- (HKScrollingNavAndTabBarState)hk_getBarStateWithDelta:(CGFloat)delta {
    HKScrollingNavAndTabBarState barState;
    if (delta < 0) {
        barState = HKScrollingNavAndTabBarStateExpanding;
    } else {
        barState = HKScrollingNavAndTabBarStateContracting;
    }
    
    do {
        
        if (!self.hk_topBar && !self.hk_bottomBar) break;
        
        if ([self hk_isExpanded]) {
            barState = HKScrollingNavAndTabBarStateExpanded;
            break;
        }
        
        if ([self hk_isContracted]) {
            barState = HKScrollingNavAndTabBarStateContracted;
        }
        
    } while (0);
    
    return barState;
}

- (BOOL)hk_isExpanded {
    BOOL isExpanded = NO;
    BOOL isTopBarExpanded = YES;
    BOOL isBottomBarExpanded = YES;
    
    if (self.hk_topBar) {
        isTopBarExpanded = [self.hk_topBar hk_isExpanded];
    }
    
    if (self.hk_bottomBar) {
        isBottomBarExpanded = [self.hk_bottomBar hk_isExpanded];
    }
    
    isExpanded = (isTopBarExpanded && isBottomBarExpanded);
    return isExpanded;
}

- (BOOL)hk_isContracted {
    BOOL isContracted = NO;
    BOOL isTopBarContracted = YES;
    BOOL isBottomBarContracted = YES;
    
    if (self.hk_topBar) {
        isTopBarContracted = [self.hk_topBar hk_isContracted];
    }
    
    if (self.hk_bottomBar) {
        isBottomBarContracted = [self.hk_bottomBar hk_isContracted];
    }
    
    isContracted = (isTopBarContracted && isBottomBarContracted);
    return isContracted;
}

#pragma mark - Setters

- (void)setHk_scrollableView:(UIView *)hk_scrollableView {
    objc_setAssociatedObject(self, @selector(hk_scrollableView), hk_scrollableView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHk_topBar:(UIView *)hk_topBar {
    objc_setAssociatedObject(self, @selector(hk_topBar), hk_topBar, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHk_bottomBar:(UIView *)hk_bottomBar {
    objc_setAssociatedObject(self, @selector(hk_bottomBar), hk_bottomBar, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHk_panGesture:(UIPanGestureRecognizer *)hk_panGesture {
    objc_setAssociatedObject(self, @selector(hk_panGesture), hk_panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_previousOffsetY:(CGFloat)hk_previousOffsetY {
    objc_setAssociatedObject(self, @selector(hk_previousOffsetY), @(hk_previousOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_topInset:(CGFloat)hk_topInset {
    objc_setAssociatedObject(self, @selector(hk_topInset), @(hk_topInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_topBarContracedPostion:(HKScrollingTopBarContractedPosition)hk_topBarContracedPostion {
    if (HKScrollingTopBarContractedPositionStatusBar == hk_topBarContracedPostion) {
        self.hk_topBar.hk_extraDistance = [self hk_statusBarHeight];
    } else {
        self.hk_topBar.hk_extraDistance = 0;
    }
    
    objc_setAssociatedObject(self, @selector(hk_topBarContracedPostion), @(hk_topBarContracedPostion), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_alphaFadeEnabled:(BOOL)hk_alphaFadeEnabled {
    self.hk_topBar.hk_alphaFadeEnabled = hk_alphaFadeEnabled;
    self.hk_bottomBar.hk_alphaFadeEnabled = hk_alphaFadeEnabled;
    
    objc_setAssociatedObject(self, @selector(hk_alphaFadeEnabled), @(hk_alphaFadeEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHk_barStateBlock:(HKScrollingBarDidChangeBlock)hk_barStateBlock {
    objc_setAssociatedObject(self, @selector(hk_barStateBlock), hk_barStateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getters

- (UIView *)hk_scrollableView {
    return objc_getAssociatedObject(self, @selector(hk_scrollableView));
}

- (UIView *)hk_topBar {
    return objc_getAssociatedObject(self, @selector(hk_topBar));
}

- (UIView *)hk_bottomBar {
    return objc_getAssociatedObject(self, @selector(hk_bottomBar));
}

- (UIPanGestureRecognizer *)hk_panGesture {
    return objc_getAssociatedObject(self, @selector(hk_panGesture));
}

- (CGFloat)hk_previousOffsetY {
    return [objc_getAssociatedObject(self, @selector(hk_previousOffsetY)) floatValue];
}

- (CGFloat)hk_topInset {
    return [objc_getAssociatedObject(self, @selector(hk_topInset)) floatValue];
}

- (HKScrollingTopBarContractedPosition)hk_topBarContracedPostion {
    return [objc_getAssociatedObject(self, @selector(hk_topBarContracedPostion)) unsignedIntegerValue];
}

- (HKScrollingBarDidChangeBlock)hk_barStateBlock {
    return objc_getAssociatedObject(self, @selector(hk_barStateBlock));
}

- (BOOL)hk_alphaFadeEnabled {
    return [objc_getAssociatedObject(self, @selector(hk_alphaFadeEnabled)) boolValue];
}

- (UIScrollView *)hk_scrollView {
    UIScrollView *scroll = nil;
    if ([self.hk_scrollableView respondsToSelector:@selector(scrollView)]) {
        scroll = [self.hk_scrollableView performSelector:@selector(scrollView)];
    } else if ([self.hk_scrollableView isKindOfClass:[UIScrollView class]]) {
        scroll = (UIScrollView *)self.hk_scrollableView;
    }
    return scroll;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

@end
