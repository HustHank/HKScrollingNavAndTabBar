//
//  HKScrolingBaseViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/23.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrolingBaseViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

static NSString * const kCellIdentifier = @"HKScrollingNavAndTabBarViewControllerTableViewCellIdentifier";
static NSString * const kTopBarPostionControlCellIdentifier = @"HKScrollingNavAndTabBarViewControllerTableViewCellTopBarPostionControlCellIdentifier";
static NSString * const kAlphaControlCellIdentifier = @"HKScrollingNavAndTabBarViewControllerTableViewCellAlphaControlCellIdentifier";

typedef void(^HKScrolingSwitchTableViewCellBlock)(UISwitch *switchControl);

#pragma mark -

@interface HKScrolingSwitchTableViewCell : UITableViewCell

@property (nonatomic, strong) UISwitch *topBarPositionSwitch;
@property (nonatomic, copy) HKScrolingSwitchTableViewCellBlock switchBlock;

@end

@implementation HKScrolingSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _topBarPositionSwitch = [[UISwitch alloc] init];
        _topBarPositionSwitch.on = YES;
        [_topBarPositionSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_topBarPositionSwitch];
        [self bringSubviewToFront:_topBarPositionSwitch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topBarPositionSwitch.frame = CGRectMake(CGRectGetWidth(self.frame) - 100,  0, 80, 30);
    _topBarPositionSwitch.center = CGPointMake(_topBarPositionSwitch.center.x, self.center.y);
}

- (void)switchChange:(UISwitch *)switchControl {
    if (self.switchBlock) {
        self.switchBlock(switchControl);
    }
}

@end

#pragma mark -

@interface HKScrolingBaseViewController ()

@end

@implementation HKScrolingBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.dataSource = @[].mutableCopy;
    for (NSInteger index = 0; index < 50; index++) {
        [self.dataSource addObject:@"text"];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[HKScrolingSwitchTableViewCell class] forCellReuseIdentifier:kTopBarPostionControlCellIdentifier];
    [self.tableView registerClass:[HKScrolingSwitchTableViewCell class] forCellReuseIdentifier:kAlphaControlCellIdentifier];
    [self.tableView reloadData];
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

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = kCellIdentifier;
    
    if (0 == indexPath.row) {
        cellIdentifier = kTopBarPostionControlCellIdentifier;
        HKScrolingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"alpha enable";
        cell.switchBlock = ^(UISwitch *switchControl) {
            if (switchControl.on) {
                self.hk_alphaFadeEnabled = YES;
            } else {
                self.hk_alphaFadeEnabled = NO;
            }
        };
        return cell;
        
    } else if (1 == indexPath.row) {
        cellIdentifier = kAlphaControlCellIdentifier;
        HKScrolingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.dataSource[indexPath.row];
        cell.switchBlock = ^(UISwitch *switchControl) {
            if (switchControl.on) {
                self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionStatusBar;
            } else {
                self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
            }
        };
        return cell;
        
    } else {
        cellIdentifier = kCellIdentifier;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.dataSource[indexPath.row];
        return cell;
    }
    
//    return [UITableViewCell new];
}

@end
