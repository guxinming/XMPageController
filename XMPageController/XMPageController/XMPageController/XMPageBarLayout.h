//
//  XMPagerBarLayout.h
//  XMPageController
//
//  Created by EDZ on 2018/8/7.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "XMPageCotrol.h"

typedef NS_ENUM(NSInteger, XMPagerBarStyle) {
    XMPagerBarStyleNone,
    XMPagerBarStyleProgress,
};

@protocol XMPageBarLayoutDataSource <NSObject>

/**
 cell宽度
 
 @param index 索引
 @return      cell宽度
 */
- (CGFloat)widthForItemAtIndex:(NSInteger)index;

@end

@interface XMPageBarLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id <XMPageBarLayoutDataSource>dataSource;
/**
 pagerBar的风格
 */
@property (assign, nonatomic) XMPagerBarStyle barStyle;

/**
 cell之间的间距
 */
@property (assign, nonatomic) CGFloat cellSpace;
/**
 cell与两边的距离
 */
@property (assign, nonatomic) CGFloat cellPadding;

#pragma mark - 这四个属性在自定义cell的时候无效
/**
 正常的title字体
 */
@property (strong, nonatomic) UIFont *normalFont;
/**
 选中的title字体
 */
@property (strong, nonatomic) UIFont *selecFont;
/**
 正常title颜色
 */
@property (strong, nonatomic) UIColor *normalColor;
/**
 选中title颜色
 */
@property (strong, nonatomic) UIColor *selectColor;

#pragma mark - progressView
@property (assign, nonatomic) XMProgressStyle style;
/**
 进度条的宽度，如果不设置默认为barItem的宽度，且不能大于baritem的宽度
 */
@property (assign, nonatomic) CGFloat progressW;
/**
 进度条的高度，默认为3，值应该在0.5-5之间
 */
@property (assign, nonatomic) CGFloat progressH;
/**
 进度条颜色
 */
@property (strong, nonatomic) UIColor *progressColor;

/**
 progress移动速度,pageBar - (void)refreshProgress:(float)progress isDragging:(BOOL)isDragging animated:(BOOL)animated animated为YES时有效，否则无效(越大越慢，越小越快)
 */
@property (assign, nonatomic) CGFloat progressSpeed;

@end
