//
//  XMPageViewController.h
//  XMPageController
//
//  Created by EDZ on 2018/8/6.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPageViewController;

@protocol XMPageDataSource <NSObject>
@required

/**
 返回最大索引值

 @return 最大索引值
 */
- (NSInteger)numberOfItemsInPageControler;

/**
 通过索引获得相应的vc

 @param pageController 当前的pageController
 @param index 索引
 @return 索引vc
 */
- (UIViewController *)pageController:(XMPageViewController *)pageController itemAtIndex:(NSInteger)index;

@end

@protocol XMPageDelegate <NSObject>

@optional


- (void)pageController:(XMPageViewController *)pageController transitionFrom:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;

- (void)pageController:(XMPageViewController *)pageController transitProgress:(float)progress isDragging:(BOOL)isDragging;


//pageController scrollDelegate
- (void)pageControllerViewDidScroll:(XMPageViewController *)pageController;
- (void)pageControllerDidEndDragging:(XMPageViewController *)pageController willDecelerate:(BOOL)decelerate;
- (void)pageControllerDidEndDecelerating:(XMPageViewController *)pageController;

@end

@interface XMPageViewController : UIViewController

@property (weak, nonatomic) id <XMPageDataSource>dataSource;
@property (weak, nonatomic) id <XMPageDelegate>delegate;

/**
 当前的index
 */
@property (assign, nonatomic, readonly) NSInteger curIndex;

/**
 分页数目
 */
@property (assign, nonatomic, readonly) NSInteger maxIndex;

/**
 将当前展示的vc的View都记录下来
 */
@property (copy, nonatomic, readonly) NSArray <UIViewController *>*controllers;

/**
 整体是否可滑动
 */
@property (assign, nonatomic) BOOL scrollEnable;

/**
 滑动到指定的index

 @param index    索引值
 @param animated 是否添加动画
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 刷新数据
 */
- (void)reloadPageData;

@end
