//
//  HKScrollingNavAndTabBarManager.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/16.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndTabBarManager.h"
#import "UIView+HKScrollingNavAndBar.h"

//中间按钮超出TabBar的距离，根据实际情况来定
static CGFloat kTabBarCenterButtonDelta = 44.f;

@interface HKScrollingNavAndTabBarManager () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView *scrollableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) CGFloat previousOffsetY;
@property (nonatomic, assign) CGFloat topInset;

@end

@implementation HKScrollingNavAndTabBarManager

- (instancetype)initWithController:(UIViewController *)viewController scrollableView:(UIView *)scrollableView {
    if (self = [super init]) {
        _viewController = viewController;
        _scrollableView = scrollableView;
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_panGesture setMaximumNumberOfTouches:1];
        
        [_panGesture setDelegate:self];
        [_scrollableView addGestureRecognizer:self.panGesture];
    }
    return self;
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
    [[self navigationBar] hk_updateOffsetY:deltaY];
    [[self tabBar] hk_updateOffsetY:deltaY];
    
    // 4 - 更新TableView的contentInset
    [self updateScrollViewInset];
    
    // 5 - 保存当前的contentOffsetY
    self.previousOffsetY = contentOffsetY;
}

- (void)handleScrollingEnded:(CGFloat)velocity {
    
    CGFloat minVelocity = 500.f;
    if (![self isViewControllerVisible] || ([[self navigationBar] hk_isContracted] && velocity < minVelocity)) {
        return;
    }
    
    //NavBar和TabBar是展开还是收起
    BOOL opening = [[self navigationBar] hk_shouldExpand];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat navBarOffsetY = 0;
        if (opening) {
            //navBarOffsetY为NavBar从当前位置到展开滑动的距离
            navBarOffsetY = [[self navigationBar] hk_expand];
            [[self tabBar] hk_expand];
        } else {
            //navBarOffsetY为NavBar从当前位置到收起滑动的距离
            navBarOffsetY = [[self navigationBar] hk_contract];
            [[self tabBar] hk_contract];
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
    if ([self navigationBar]) {
        CGFloat navBarMaxY = CGRectGetMaxY([self navigationBar].frame);
        scrollViewInset.top = navBarMaxY;
    }

    if ([self tabBar]) {
        CGFloat tabBarMinY = CGRectGetMinY([self tabBar].frame);
        scrollViewInset.bottom = MAX(0, [self screenHeight] - tabBarMinY);
    }

    self.scrollView.contentInset = scrollViewInset;
    self.scrollView.scrollIndicatorInsets = scrollViewInset;
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

- (UIView *)navigationBar {
    return self.viewController.navigationController.navigationBar;
}

- (UIView *)tabBar {
    return self.viewController.tabBarController.tabBar;
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

- (void)stopFollowingScrollView {
//    [self showNavBarAnimated:NO];
    [self.scrollableView removeGestureRecognizer:self.panGesture];

    self.scrollableView = nil;
    self.panGesture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [self stopFollowingScrollView];
}

@end
