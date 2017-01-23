//
//  AppDelegate.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/10.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

//导航栏颜色
#define NavBarColor [UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1.0]

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupNavigationBar];
    
    self.window = [[UIWindow alloc] init];
    ViewController *viewController = [[ViewController alloc] init];
    viewController.title = @"Home";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupNavigationBar {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18.f];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:NavBarColor];
}

@end
