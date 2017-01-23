//
//  HKTabBar.h
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HKTabBarClickBlock)();

@interface HKTabBar : UITabBar

- (void)setBtnClickBlock:(HKTabBarClickBlock)block;

@end
