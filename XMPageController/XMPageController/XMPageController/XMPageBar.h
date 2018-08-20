//
//  XMPageBar.h
//  XMPageController
//
//  Created by EDZ on 2018/8/7.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPageBarLayout.h"

@class XMPageBar;

@protocol XMPageBarDataSource <NSObject>

/**
 item个数

 @return 个数
 */
- (NSInteger)numberOfItemInPageBar;

/**
 cell宽度
 
 @param index 索引
 @return      cell宽度
 */
- (CGFloat)widthForPageBarCellAtIndex:(NSInteger)index;

@optional
/**
 获取默认cellTitle，如果自行注册cell，这个方法无效
 
 @param index     索引值
 @return          标题
 */
- (NSString *)titleForCellAtIndex:(NSInteger)index;

/**
 自定义cell
 
 @param pageBar   当前bar
 @param index     索引值
 @return          当前的cell
 */
- (__kindof UICollectionViewCell *)pageBar:(XMPageBar *)pageBar cellForItemAtIndex:(NSInteger)index;



@end

@protocol XMPageBarDelegate <NSObject>

@optional
/**
 选择某一个cell

 @param pageBar 当前pageBar
 @param index   索引
 */
- (void)pageBar:(XMPageBar *)pageBar didSelectItemAtIndex:(NSInteger)index;

/**
 取消选择某一个cell
 
 @param pageBar 当前pageBar
 @param index   索引
 */
- (void)pageBar:(XMPageBar *)pageBar didDeselectItemAtIndex:(NSInteger)index;

@end

@interface XMPageBar : UIView

@property (weak, nonatomic) id <XMPageBarDataSource>dataSource;
@property (weak, nonatomic) id <XMPageBarDelegate>delegate;

@property (strong, nonatomic) XMPageBarLayout *layout;
/**
 自动tabbar偏移到中间
 */
@property (assign, nonatomic) BOOL scrollContentToCenter;
/**
 当前选中的索引值
 */
@property (assign, nonatomic) NSInteger curIndex;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier index:(NSInteger)index;
- (UICollectionViewCell *)cellForIndex:(NSInteger)index;

- (void)reloadData;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)refreshProgress:(float)progress isDragging:(BOOL)isDragging animated:(BOOL)animated;

@end
