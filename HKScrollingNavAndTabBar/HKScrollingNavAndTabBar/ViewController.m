//
//  ViewController.m
//  HKScrollingNavAndTabBar
//
//  Created by HK on 17/1/10.
//  Copyright © 2017年 hkhust. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+HKScrollingNavAndTabBar.h"

static NSString * const kCellIdentifier = @"HKLiveTableViewCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hk_expand];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hk_expand];
}

#pragma mark - Init
- (void)commonInit {
    
    [self initTableView];
    [self initDataSource];
    [self hk_followScrollView:self.tableView];
    self.hk_topBarContracedPostion = HKScrollingTopBarContractedPositionTop;
    self.hk_alphaFadeEnabled = NO;
    [self hk_managerbotomBar:self.tabBarController.tabBar];
    [self hk_setBarDidChangeStateBlock:^(HKScrollingNavAndTabBarState state) {
        NSLog(@"state:%ld",(long)state);
    }];
}

- (void)initTableView {
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    self.dataSource = @[].mutableCopy;
    for (NSInteger index = 0; index < 50; index++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"UITableViewCell---section_0---row_%ld",(long)index]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor blueColor];
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
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"contentOffset:%f",scrollView.contentOffset.y);
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *controller = [[ViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
