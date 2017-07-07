//
//  ViewController.m
//  ALTemplateLibary
//
//  Created by allen on 7/6/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ViewController.h"
#import "LongPressChangeVC.h"
#import "DragVC.h"
#import "DragUITableViewVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    LongPressChangeVC *longPressChangVC = [[LongPressChangeVC alloc] init];
    [longPressChangVC generateData:nil];
    longPressChangVC.title = @"长按删除及移动";
    
    DragVC *dragVC = [[DragVC alloc] init];
    [dragVC generateData:nil];
    dragVC.title = @"长按拖拽";
    
    DragUITableViewVC *dragUITableViewVC = [[DragUITableViewVC alloc] init];
    [dragUITableViewVC generateData:nil];
    dragUITableViewVC.title = @"tableview横向布局";
    
    self.controllers = @[
                         longPressChangVC,
                         dragVC,
                         dragUITableViewVC,
                         ];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"CellIdentifier";
    UIViewController *viewController = self.controllers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = viewController.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controllers.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.controllers[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
