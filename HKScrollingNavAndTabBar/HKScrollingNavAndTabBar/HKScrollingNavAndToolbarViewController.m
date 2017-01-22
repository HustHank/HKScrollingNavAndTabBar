//
//  HKScrollingNavAndToolbarViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/21.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrollingNavAndToolbarViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

static NSString * const kCellIdentifier = @"HKScrollingNavAndToolbarTableViewCellIdentifier";

@interface HKScrollingNavAndToolbarViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation HKScrollingNavAndToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolbar];
    self.dataSource = @[].mutableCopy;
    for (NSInteger index = 0; index < 50; index++) {
        [self.dataSource addObject:@"text"];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self hk_followScrollView:self.tableView];
    [self hk_managerBotomBar:self.toolbar];
    self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        NSLog(@"state:%ld",(long)state);
    }];
    
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

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50);
        _toolbar.backgroundColor = [UIColor lightGrayColor];
    }
    return _toolbar;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

@end
