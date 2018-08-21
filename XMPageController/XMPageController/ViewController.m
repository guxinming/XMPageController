//
//  ViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/6.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "CustomBarViewController.h"

#define IS_IPHONEX     CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)
#define TABBAR_H       (IS_IPHONEX ? 83 : 49)
/* 状态栏高度 */
#define STATUS_H    [[UIApplication sharedApplication] statusBarFrame].size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *sourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sourceArray = @[@"DefaultBarStyle", @"CustomBar", @"progressNauty"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STATUS_H - TABBAR_H - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.sourceArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        PageViewController *pageVC = [[PageViewController alloc] init];
        pageVC.progressW = 100;
        [self.navigationController pushViewController:pageVC animated:YES];
    } else if (indexPath.row == 1) {
        CustomBarViewController *customBarVC = [[CustomBarViewController alloc] init];
        [self.navigationController pushViewController:customBarVC animated:YES];
    } else if (indexPath.row == 2) {
        PageViewController *pageVC = [[PageViewController alloc] init];
        pageVC.progressW = 10;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
}



@end
