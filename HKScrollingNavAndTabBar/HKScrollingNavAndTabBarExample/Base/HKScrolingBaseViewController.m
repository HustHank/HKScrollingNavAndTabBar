//
//  HKScrolingBaseViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/23.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "HKScrolingBaseViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

static NSString * const kCellIdentifier = @"HKScrollingBaseTableViewCellIdentifier";

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

@end
