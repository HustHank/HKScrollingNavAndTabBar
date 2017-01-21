//
//  HKScrollingNavAndTabBarManager.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/16.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndTabBarManager.h"
#import "UIView+HKScrollingNavAndBar.h"

@interface HKScrollingNavAndTabBarManager () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView *scrollableView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) CGFloat previousOffsetY;
@property (nonatomic, assign) CGFloat topInset;

@end

@implementation HKScrollingNavAndTabBarManager

- (instancetype)initWithController:(UIViewController *)viewController scrollableView:(UIView *)scrollableView {
    if (self = [super init]) {
        _viewController = viewController;
        _scrollableView = scrollableView;
        _topBar = viewController.navigationController.navigationBar;

        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_panGesture setMaximumNumberOfTouches:1];
        
        [_panGesture setDelegate:self];
        [_scrollableView addGestureRecognizer:self.panGesture];
    }
    return self;
}

#pragma mark - Public Method

- (void)managerTopBar:(UIView *)topBar {
    self.topBar = topBar;
    self.topBar.hk_postion = HKScrollingNavAndBarPositionTop;
}

- (void)managerbotomBar:(UIView *)bottomBar {
    self.bottomBar = bottomBar;
    self.bottomBar.hk_postion = HKScrollingNavAndBarPositionBottom;
}

- (void)expand {
    [self.topBar hk_expand];
    [self.bottomBar hk_expand];
}

- (void)contract {
    [self.topBar hk_contract];
    [self.bottomBar hk_contract];
}

#pragma mark - Private Mehod 

- (CGFloat)exceededDistanceOfBottomBar {
    CGFloat exceededDistance = 0.f;
    CGFloat minSubViewOffsetY = 0.f;
    
    for (UIView *subView in self.bottomBar.subviews) {
        BOOL isViewHidden = (subView.isHidden || subView.alpha < FLT_EPSILON);
        if (!isViewHidden) {
            CGFloat subViewOffsetY = CGRectGetMinY(subView.frame);
            minSubViewOffsetY = MIN(minSubViewOffsetY, subViewOffsetY);
        }
    }
    
    exceededDistance = -minSubViewOffsetY;
    
    return exceededDistance;
}

#pragma mark - Gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _topInset = self.viewController.navigationController.navigationBar.frame.size.height + [self statusBarHeight];
            [self handleScrolling];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self handleScrolling];
            break;
        }
        default: {
           CGFloat velocity = [gesture velocityInView:self.scrollableView].y;
            [self handleScrollingEnded:velocity];
            break;
        }
    }
}

- (void)handleScrolling {
    //在push到其他页面时候，还是会走该方法，这个时候不应该继续执行
    if (!(self.viewController.isViewLoaded && self.viewController.view.window != nil)) {
        return;
    }
    
    // 1 - 计算偏移量
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    CGFloat deltaY = contentOffsetY - _previousOffsetY;
    
    // 2 - 忽略超出滑动范围的Offset
    // 1) - 忽略向上滑动的Offset
    CGFloat start = -_topInset;
    if (_previousOffsetY <= start) {
        deltaY = MAX(0, deltaY + (_previousOffsetY - start));
    }
    
    // 2) - 忽略向下滑动的Offset
    CGFloat maxContentOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.scrollView.contentInset.bottom;
    CGFloat end = maxContentOffset;
    if (_previousOffsetY >= end) {
        deltaY = MIN(0, deltaY + (_previousOffsetY - maxContentOffset));
    }
    
    // 3 - 更新navBar和TabBar的frame
    [self.topBar hk_updateOffsetY:deltaY];
    [self.bottomBar hk_updateOffsetY:deltaY];
    
    // 4 - 更新TableView的contentInset
    [self updateScrollViewInset];
    
    // 5 - 保存当前的contentOffsetY
    self.previousOffsetY = contentOffsetY;
}

- (void)handleScrollingEnded:(CGFloat)velocity {
    
    CGFloat minVelocity = 500.f;
    if (![self isViewControllerVisible] || ([self.topBar hk_isContracted] && velocity < minVelocity)) {
        return;
    }
    
    if (!self.topBar && !self.bottomBar) {
        return;
    }
    
    //NavBar和TabBar是展开还是收起
    BOOL opening = YES;
    if (self.topBar) {
        opening = [self.topBar hk_shouldExpand];
    } else if (self.bottomBar) {
        opening = [self.bottomBar hk_shouldExpand];
    } else {
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat navBarOffsetY = 0;
        if (opening) {
            //navBarOffsetY为NavBar从当前位置到展开滑动的距离
            navBarOffsetY = [self.topBar hk_expand];
            [self.bottomBar hk_expand];
        } else {
            //navBarOffsetY为NavBar从当前位置到收起滑动的距离
            navBarOffsetY = [self.topBar hk_contract];
            [self.bottomBar hk_contract];
        }
        //更新ScrollView的contentInset
        [self updateScrollViewInset];
        //根据NavBar的偏移量来滑动TableView
        if (opening) {
            CGPoint contentOffset = self.scrollView.contentOffset;
            contentOffset.y += navBarOffsetY;
            self.scrollView.contentOffset = contentOffset;
        }
    }];
}

- (void)updateScrollViewInset {
    UIEdgeInsets scrollViewInset = self.scrollView.contentInset;
    if (self.topBar) {
        CGFloat navBarMaxY = CGRectGetMaxY(self.topBar.frame);
        scrollViewInset.top = navBarMaxY;
    }

    if (self.bottomBar) {
        CGFloat tabBarMinY = CGRectGetMinY(self.bottomBar.frame);
        scrollViewInset.bottom = MAX(0, [self screenHeight] - tabBarMinY);
    }

    self.scrollView.contentInset = scrollViewInset;
    self.scrollView.scrollIndicatorInsets = scrollViewInset;
}

#pragma mark - Setters
- (void)setTopBarContracedPostion:(HKScrollingTopBarContractedPosition)topBarContracedPostion {
    _topBarContracedPostion = topBarContracedPostion;
    if (HKScrollingTopBarContractedPositionStatusBar == topBarContracedPostion) {
        self.topBar.hk_extraDistance = [self statusBarHeight];
    } else {
        self.topBar.hk_extraDistance = 0;
    }
}

- (void)setBottomBarContracedPostion:(HKScrollingBottomBarContractedPosition)bottomBarContracedPostion {
    _bottomBarContracedPostion = bottomBarContracedPostion;
    if (HKScrollingBottomBarContractedPositionExceeded == bottomBarContracedPostion) {
        self.bottomBar.hk_extraDistance = [self exceededDistanceOfBottomBar];
    } else {
        self.bottomBar.hk_extraDistance = 0;
    }
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    UIScrollView *scroll = nil;
    if ([self.scrollableView respondsToSelector:@selector(scrollView)]) {
        scroll = [self.scrollableView performSelector:@selector(scrollView)];
    } else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        scroll = (UIScrollView *)self.scrollableView;
    }
    return scroll;
}

- (CGFloat)statusBarHeight {
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        return 0;
    }
    
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (BOOL)isViewControllerVisible {
    return self.viewController.isViewLoaded && self.viewController.view.window != nil;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}


- (void)dealloc {
    [self.scrollableView removeGestureRecognizer:self.panGesture];
    
    self.scrollableView = nil;
    self.panGesture = nil;
}

@end
