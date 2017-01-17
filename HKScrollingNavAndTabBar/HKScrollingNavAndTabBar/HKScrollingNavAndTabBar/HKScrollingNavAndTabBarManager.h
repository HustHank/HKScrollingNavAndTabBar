//
//  HKScrollingNavAndTabBarManager.h
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/16.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HKScrollingNavAndTabBarManager : NSObject

@property (nonatomic, assign) BOOL shouldScrollNavigationBar;
@property (nonatomic, assign) BOOL shouldScrollTabBar;

- (instancetype)initWithController:(UIViewController *)viewController scrollableView:(UIView *)scrollableView;

@end
