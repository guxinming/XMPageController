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

/**
 pageBar的滑动回调

 @param pageBar   当前pageBar
 @param fromIndex 当前的index
 @param toIndex   目标Index
 @param progress  从当前index到目标index的进度（0-1）
 */
- (void)pageBar:(XMPageBar *)pageBar transitFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress;

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

#pragma mark - 这里是collectionView的方法包装
/**
 向pagebar注册cell

 @param cellClass  cell类
 @param identifier 标识
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier index:(NSInteger)index;
/**
 通过inde获取cell

 @param index 索引
 @return      返回索引值的cell，如果cell不存在为nil
 */
- (UICollectionViewCell *)cellForIndex:(NSInteger)index;

- (void)reloadData;

/**
 选中index，配合pageController滚动使用

 @param index 需要选中的index
 */
- (void)selectItemAtIndex:(NSInteger)index;

/**
 刷新pageBar显示

 @param progress   进度（0-maxIndex）
 @param isDragging 是否是拖动
 @param animated   是否有动画（建议要有，不然会比较生硬）
 */
- (void)refreshProgress:(float)progress isDragging:(BOOL)isDragging animated:(BOOL)animated;

@end
