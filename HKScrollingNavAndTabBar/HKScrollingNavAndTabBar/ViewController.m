//
//  ViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/10.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "ViewController.h"

static NSString * const kCellIdentifier = @"HKTableViewCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self commonInit];
}

#pragma mark - Init
- (void)commonInit {
    [self initTableView];
    [self initDataSource];
}

- (void)initTableView {
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    self.dataSource = @[
                        @"HKScrollingNavBarViewController",
                        @"HKScrollingNavAndTabBarViewController",
                        @"HKScrollingNavAndToolbarViewController",
                        ];
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = self.dataSource[indexPath.row];
    Class ControllerClass = NSClassFromString(className);
    UIViewController *classcontroller = [[ControllerClass alloc] init];
    if ([className containsString:@"NavAndTab"]) {
        classcontroller.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:classcontroller];
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[nav];
        [self presentViewController:tabBarController animated:YES completion:^{
            
        }];
    } else {
        [self.navigationController pushViewController:classcontroller animated:YES];
    }
}


@end
