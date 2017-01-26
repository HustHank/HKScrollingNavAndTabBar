HKScrollingNavAndTabBar
==============

An easy to use library that manages hiding and showing of navigation bar, tab bar or toolbar when user scrolls.
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Note](#note)


#Features 

Supports following view elements:
- UINavigationBar
- UINavigationBar and a UIToolbar
- UINavigationBar and a UITabBar 
- UINavigationBar and a Custom UITabBar (such as exceed center button) 

Support function:
- Hiding/showing  when scrolling
- Control hiding/showing separately
- Alpha fade when scrolling
- Set UINavigationBar position when UINavigationBar hidden
- Scrolling state change block
- Works with ARC and iOS >= 8

###Support functions
![Alt text]
(https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ScrollingNavAndTabScreenshot.png)

###UINavigationBar
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ScrollingNavBar.gif)

###UINavigationBar and a UIToolbar
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ScrollingTabAndToobar.gif)

###UINavigationBar and a UITabBar
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ScrollingNavAndTab.gif)

###UINavigationBar and an exceed UITabBar
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ScrollingNavAndExceedTab.gif)

###Control hiding/showing separately
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/ChooseScrolling.gif)

###Set UINavigationBar position
![Alt text](https://github.com/HustHank/HKScrollingNavAndTabBar/blob/master/Screenshot/TopBarPosition1.gif)

#Installation

- Add `HKScrollingNavAndTabBar` folder to your project.
- `#import "UIViewController+HKScrollingNavAndTabBar.h"` where you want to scrolling navigationBar or tabBar.

#Usage
**In UIViewController:**
Start scrolling navigation bar while a scrollView scroll:
```objective-c
[self hk_followScrollView:self.scrollView];
```

Stop scrolling navigation bar:
```objective-c
[self hk_stopFollowingScrollView];
```

Scrolling with tab bar:
```objective-c
[self hk_managerBotomBar:self.toolBar]
```

Or scrolling with tool bar:
```objective-c
[self hk_managerBotomBar:self.tabBarController.tabBar]
```

Scrolling without navigation bar:
```objective-c
[self hk_managerTopBar:nil];
```

Scrolling without tab bar:
```objective-c
[self hk_managerBotomBar:nil];
```

Set nav bar contracted at top:
```objective-c
self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
```

Or set nav bar contracted at top:
```objective-c
self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionStatusBar;
```

Monitor nav or tab bar state:
```objective-c
[self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        switch (state) {
            case HKScrollingNavAndTabBarStateExpanded:
                NSLog(@"navbar expended");
                break;
            case HKScrollingNavAndTabBarStateExpanding:
                NSLog(@"navbar is expending");
                break;
            case HKScrollingNavAndTabBarStateContracting:
                NSLog(@"navbar is contracting");
                break;
            case HKScrollingNavAndTabBarStateContracted:
                NSLog(@"navbar contracted");
                break;
        }
       
    }];
```

Below code is an example of how your UIViewController subclass should look:
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    [self hk_followScrollView:self.tableView];
    [self hk_managerTopBar:self.navigationController.navigationBar];
    [self hk_managerBotomBar:self.tabBarController.tabBar];
        [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        switch (state) {
            case HKScrollingNavAndTabBarStateExpanded:
                NSLog(@"navbar expended");
                break;
            case HKScrollingNavAndTabBarStateExpanding:
                NSLog(@"navbar is expending");
                break;
            case HKScrollingNavAndTabBarStateContracting:
                NSLog(@"navbar is contracting");
                break;
            case HKScrollingNavAndTabBarStateContracted:
                NSLog(@"navbar contracted");
                break;
        }
       
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hk_expand];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hk_expand];
}

- (void)dealloc {
    [self hk_stopFollowingScrollView];
}
```

#Note
HKScrollingNavAndTabBar only works with UINavigationBars that have translucent set to YES.
