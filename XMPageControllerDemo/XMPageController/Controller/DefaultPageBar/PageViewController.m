//
//  PageViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/6.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "PageViewController.h"
#import "XMPageViewController.h"

#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "Test4ViewController.h"
#import "Test5ViewController.h"

@interface PageViewController () <XMPageDataSource, XMPageDelegate, XMPageBarDelegate, XMPageBarDataSource>

@property (strong, nonatomic) XMPageViewController *pageController;
@property (strong, nonatomic) XMPageBar *pageBar;

@property (copy, nonatomic) NSArray <UIViewController *>*controllers;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XMPageBar *pageBar = [[XMPageBar alloc] init];
    pageBar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
    pageBar.delegate = self;
    pageBar.dataSource = self;
    pageBar.layout.normalFont = [UIFont systemFontOfSize:16];
    
    pageBar.layout.normalColor = [UIColor grayColor];
    if (self.style == XMPageBarFillFlowProgress) {
        pageBar.layout.selectColor = [UIColor whiteColor];
        //建议这种样式的selectFont与normalFont一样
        pageBar.layout.selecFont = [UIFont systemFontOfSize:16];
    } else {
        pageBar.layout.selectColor = [UIColor purpleColor];
        pageBar.layout.selecFont = [UIFont systemFontOfSize:18];
    }
    
    pageBar.layout.barStyle = self.style;
    pageBar.layout.progressColor = [UIColor orangeColor];
    pageBar.layout.progressW = self.progressW;
    pageBar.layout.progressH = self.progressH;
    [self.view addSubview:pageBar];
    self.pageBar = pageBar;
    
    XMPageViewController *pageController = [[XMPageViewController alloc] init];
    pageController.view.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
    pageController.dataSource = self;
    pageController.delegate = self;
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    self.pageController = pageController;
    
    [pageBar reloadData];
    [pageController reloadPageData];
}

#pragma mark - XMPageDataSource
- (NSInteger)numberOfItemsInPageControler {
    return 10;
}

- (UIViewController *)pageController:(XMPageViewController *)pageController itemAtIndex:(NSInteger)index {
    if (index % 5 == 0) {
        return [[Test1ViewController alloc] init];
    } else if (index % 5 == 1) {
        return [[Test2ViewController alloc] init];
    } else if (index % 5 == 2) {
        return [[Test3ViewController alloc] init];
    } else if (index % 5 == 3) {
        return [[Test4ViewController alloc] init];
    } else {
        return [[Test5ViewController alloc] init];
    }
}

#pragma mark - XMPageBarDataSource
- (NSInteger)numberOfItemInPageBar {
    return 10;
}

- (NSString *)titleForCellAtIndex:(NSInteger)index {
    return @"啦啦";
}

- (CGFloat)widthForPageBarCellAtIndex:(NSInteger)index {
    if (index % 3 == 0) {
        return 50;
    } else if (index % 3 == 1) {
        return 80;
    } else {
        return 70;
    }
}

#pragma mark - XMPageBarDataSource
- (void)pageBar:(XMPageBar *)pageBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageController scrollToIndex:index animated:NO];
}

- (void)pageController:(XMPageViewController *)pageController transitionFrom:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.pageBar selectItemAtIndex:toIndex];
}

- (void)pageController:(XMPageViewController *)pageController transitProgress:(float)progress isDragging:(BOOL)isDragging {
    [self.pageBar refreshProgress:progress isDragging:isDragging animated:YES];
}

@end
