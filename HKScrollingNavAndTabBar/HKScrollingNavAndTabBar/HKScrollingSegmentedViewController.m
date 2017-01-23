//
//  HKScrollingSegmentedViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/23.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingSegmentedViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

#pragma mark -

typedef NS_ENUM(NSUInteger, HKScrolingHeaderViewSegmentType) {
    HKScrolingHeaderViewSegmentTypeBarChoose = 0,
    HKScrolingHeaderViewSegmentTypeAlphaEnable,
    HKScrolingHeaderViewSegmentTypeTopBarPostion,
};

typedef NS_ENUM(NSUInteger, HKScrolingHeaderViewBarChooseType) {
    HKScrolingHeaderViewBarChooseTypeNavAndTab = 0,
    HKScrolingHeaderViewBarChooseTypeNavOnly,
    HKScrolingHeaderViewBarChooseTypeTabOnly,
};

static const CGFloat kSegmentedControlItemWidth = 100.f;
static const CGFloat kSegmentedControlHeight = 30.f;
static const CGFloat kMargin = 18.f;

@interface HKScrolingHeaderView : UIView

@property (nonatomic, strong) UISegmentedControl *scrollingBarChooseSegmentedControl;
@property (nonatomic, strong) UISegmentedControl *alphaFadeSegmentedControl;
@property (nonatomic, strong) UISegmentedControl *topBarStayPositionSegmentedControl;

@property (nonatomic , weak) UIViewController *viewController;

@end

@implementation HKScrolingHeaderView

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController {
    if (self = [super initWithFrame:frame]) {
        
        _viewController = viewController;
        
        _alphaFadeSegmentedControl =
        [[UISegmentedControl alloc] initWithItems:@[
                                                    @"Alpha Enable",
                                                    @"Alpha Disable",
                                                    ]];
        _alphaFadeSegmentedControl.selectedSegmentIndex = 0;
        _alphaFadeSegmentedControl.tag = HKScrolingHeaderViewSegmentTypeAlphaEnable;
        [_alphaFadeSegmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
        
        _topBarStayPositionSegmentedControl =
        [[UISegmentedControl alloc] initWithItems:@[
                                                    @"StatusBar",
                                                    @"Top",
                                                    ]];
        _topBarStayPositionSegmentedControl.selectedSegmentIndex = 0;
        _topBarStayPositionSegmentedControl.tag = HKScrolingHeaderViewSegmentTypeTopBarPostion;
        [_topBarStayPositionSegmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
        
        _scrollingBarChooseSegmentedControl =
        [[UISegmentedControl alloc] initWithItems:@[
                                                    @"Nav&Tab Bar",
                                                    @"NavBar Only",
                                                    @"TabBar Only",
                                                    ]];
        _scrollingBarChooseSegmentedControl.selectedSegmentIndex = 0;
        _scrollingBarChooseSegmentedControl.tag = HKScrolingHeaderViewSegmentTypeBarChoose;
        [_scrollingBarChooseSegmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_scrollingBarChooseSegmentedControl];
        [self addSubview:_alphaFadeSegmentedControl];
        [self addSubview:_topBarStayPositionSegmentedControl];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _alphaFadeSegmentedControl.frame =
    CGRectMake(
               0,
               kMargin,
               kSegmentedControlItemWidth * 2,
               kSegmentedControlHeight
               );
    _alphaFadeSegmentedControl.center =
    CGPointMake(
                self.center.x,
                _alphaFadeSegmentedControl.center.y
                );
    
    _topBarStayPositionSegmentedControl.frame =
    CGRectMake(
               0,
               CGRectGetMaxY(_alphaFadeSegmentedControl.frame) + kMargin,
               kSegmentedControlItemWidth * 2,
               kSegmentedControlHeight
               );
    _topBarStayPositionSegmentedControl.center =
    CGPointMake(
                self.center.x,
                _topBarStayPositionSegmentedControl.center.y
                );
    
    _scrollingBarChooseSegmentedControl.frame =
    CGRectMake(
               0,
               CGRectGetMaxY(_topBarStayPositionSegmentedControl.frame) + kMargin,
               kSegmentedControlItemWidth * 3,
               kSegmentedControlHeight
               );
    _scrollingBarChooseSegmentedControl.center =
    CGPointMake(
                self.center.x,
                _scrollingBarChooseSegmentedControl.center.y
                );
}

- (void)segmentedControlChange:(UISegmentedControl *)segmentedControlChange {
    switch (segmentedControlChange.tag) {
        case HKScrolingHeaderViewSegmentTypeBarChoose: {
            
            switch (segmentedControlChange.selectedSegmentIndex) {
                case HKScrolingHeaderViewBarChooseTypeNavAndTab:
                    [_viewController hk_managerTopBar:_viewController.navigationController.navigationBar];
                    [_viewController hk_managerBotomBar:_viewController.tabBarController.tabBar];
                    break;
                case HKScrolingHeaderViewBarChooseTypeNavOnly:
                    [_viewController hk_managerTopBar:_viewController.navigationController.navigationBar];
                    [_viewController hk_managerBotomBar:nil];
                    break;
                case HKScrolingHeaderViewBarChooseTypeTabOnly:
                    [_viewController hk_managerTopBar:nil];
                    [_viewController hk_managerBotomBar:_viewController.tabBarController.tabBar];
                    break;
            }
            break;
        }
        case HKScrolingHeaderViewSegmentTypeAlphaEnable: {
            
            _viewController.hk_alphaFadeEnabled = (0 == segmentedControlChange.selectedSegmentIndex);
            break;
        }
        case HKScrolingHeaderViewSegmentTypeTopBarPostion: {
            if (0 == segmentedControlChange.selectedSegmentIndex) {
                _viewController.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionStatusBar;
            } else {
                _viewController.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
            }
            break;
        }
    }
}

@end

@interface HKScrollingSegmentedViewController ()

@property (nonatomic, strong) HKScrolingHeaderView *headerView;

@end

@implementation HKScrollingSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Getters

- (HKScrolingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HKScrolingHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 150.f) viewController:self];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

@end
