//
//  ViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/10.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "ViewController.h"
#import "HKTabBar.h"

static NSString * const kCellIdentifier = @"HKTableViewCellIdentifier";
static NSString * const kTitle = @"title";
static NSString * const kClassName = @"className";
static NSString * const kSwitchType = @"switchType";
static NSString * const kTabBarType = @"tabBarType";

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
    
    NSDictionary *firstVcDict = @{
                                  kTitle:@"Scroling Nav",
                                  kClassName:@"HKScrollingNavBarViewController",
                                  kSwitchType:@"push",
                                  };
    NSDictionary *secondVcDict = @{
                                  kTitle:@"Scroling Nav and Tab",
                                  kClassName:@"HKScrollingNavAndTabBarViewController",
                                  kSwitchType:@"present",
                                  kTabBarType:@"default",
                                  };
    NSDictionary *thirdVcDict = @{
                                  kTitle:@"Scroling Nav and Toolbar",
                                  kClassName:@"HKScrollingNavAndToolbarViewController",
                                  kSwitchType:@"push",
                                  };
    NSDictionary *forthVcDict = @{
                                  kTitle:@"Scroling Nav and exceed Tab",
                                  kClassName:@"HKScrollingNavAndExceedTabBarViewController",
                                  kSwitchType:@"present",
                                  kTabBarType:@"custom",
                                  };
    
    self.dataSource = @[firstVcDict,secondVcDict,thirdVcDict,forthVcDict];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.row][kTitle];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *vcDict = self.dataSource[indexPath.row];
    Class ControllerClass = NSClassFromString(vcDict[kClassName]);
    if ([vcDict[kSwitchType] isEqualToString:@"present"]) {
        
        UIViewController *leftViewController = [[ControllerClass alloc] init];
        leftViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
        UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
        
        UIViewController *rightViewController = [[ViewController alloc] init];
        rightViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        UINavigationController *rightNavigationController = [[UINavigationController alloc] initWithRootViewController:rightViewController];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[leftNavigationController,rightNavigationController];
        
        //TabBar包含突出按钮
        if ([vcDict[kTabBarType] isEqualToString:@"custom"]) {
            HKTabBar *tabBar = [[HKTabBar alloc] init];
            [tabBarController setValue:tabBar forKeyPath:@"tabBar"];
        }

        [self presentViewController:tabBarController animated:YES completion:nil];
        
    } else {
        UIViewController *classcontroller = [[ControllerClass alloc] init];
        [self.navigationController pushViewController:classcontroller animated:YES];
    }
}

@end
