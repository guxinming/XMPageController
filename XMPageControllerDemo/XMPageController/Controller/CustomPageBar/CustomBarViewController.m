//
//  CustomBarViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/20.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "CustomBarViewController.h"
#import "XMPageViewController.h"
#import "XMPageBar.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "CustomCollectionViewCell.h"

@interface CustomBarViewController () <XMPageDataSource, XMPageDelegate, XMPageBarDelegate, XMPageBarDataSource>

@property (strong, nonatomic) XMPageViewController *pageController;
@property (strong, nonatomic) XMPageBar *pageBar;

@end

@implementation CustomBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XMPageBar *pageBar = [[XMPageBar alloc] init];
    pageBar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
    pageBar.bounces = NO;
    pageBar.delegate = self;
    pageBar.dataSource = self;
    pageBar.layout.normalFont = [UIFont systemFontOfSize:16];
    pageBar.layout.selecFont = [UIFont systemFontOfSize:18];
    pageBar.layout.normalColor = [UIColor grayColor];
    pageBar.layout.selectColor = [UIColor blueColor];
    pageBar.layout.barStyle = XMPageBarTriangleProgress;
    pageBar.layout.progressColor = [UIColor blueColor];
    pageBar.layout.progressW = 100;
    pageBar.layout.progressH = 5;
    pageBar.layout.progressSpeed = 10;
    [pageBar registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"pageBarCell"];
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
    if (index % 3 == 0) {
        return [[Test1ViewController alloc] init];
    } else if (index % 3 == 1) {
        return [[Test2ViewController alloc] init];
    } else {
        return [[Test3ViewController alloc] init];
    }
}

- (UICollectionViewCell *)pageBar:(XMPageBar *)pageBar cellForItemAtIndex:(NSInteger)index {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[pageBar dequeueReusableCellWithReuseIdentifier:@"pageBarCell" index:index];
    cell.titleLabel.text = @"啦啦";
    cell.desLabel.text = @"99";
    if (index == self.pageBar.curIndex) {
        cell.titleLabel.textColor = [UIColor blueColor];
        cell.desLabel.textColor = [UIColor blueColor];
        
    } else {
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.desLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
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

- (void)pageBar:(XMPageBar *)pageBar transitFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress {
    CustomCollectionViewCell *fromcell = (CustomCollectionViewCell *)[pageBar cellForIndex:fromIndex];
    CustomCollectionViewCell *tocell = (CustomCollectionViewCell *)[pageBar cellForIndex:toIndex];
    CGFloat narR = 0, narG = 0, narB = 0, narA = 1;
    [[UIColor grayColor] getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR = 0,selG = 0,selB = 0, selA = 1;
    [[UIColor blueColor] getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    fromcell.desLabel.textColor = fromcell.titleLabel.textColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    tocell.desLabel.textColor = tocell.titleLabel.textColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

- (void)pageController:(XMPageViewController *)pageController transitProgress:(float)progress isDragging:(BOOL)isDragging {
    [self.pageBar refreshProgress:progress isDragging:isDragging animated:YES];
}

@end
