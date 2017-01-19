//
//  AppDelegate.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/10.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    [self setUpAllChildVc];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - setup
- (void)setUpAllChildVc {
    ViewController *Vc = [[ViewController alloc] init];
    [self setupOneChildVcWithVc:Vc image:@"" selectedImage:@"" title:@"首页"];
}

- (void)setupOneChildVcWithVc:(UIViewController *)Vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    
    //设置图片居中，这里的4.5，根据实际中间按钮图片大小来决定
    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    //设置不显示文字，将title的位置设置成无限远，就看不到了
    Vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    
    [self.tabBarController addChildViewController:nav];
}

@end
