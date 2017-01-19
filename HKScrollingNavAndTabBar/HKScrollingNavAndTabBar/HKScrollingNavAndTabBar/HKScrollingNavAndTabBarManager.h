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

- (instancetype)initWithController:(UIViewController *)viewController scrollableView:(UIView *)scrollableView;

///如果不设置topBar，则默认为navigationBar
- (void)managerTopBar:(UIView *)topBar;

- (void)managerbotomBar:(UIView *)bottomBar;

@end
