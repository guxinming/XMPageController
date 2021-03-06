//
//  XMPagerBarLayout.h
//  XMPageController
//
//  Created by EDZ on 2018/8/7.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMPagerBarStyle) {
    XMPageBarStyleNone,                  //默认样式
    XMPageBarLineProgress,               //底部为一个view，根据progressWidth字段决定是否有流动效果
    XMPageBarTriangleProgress,           //底部为三角符号
    XMPageBarStrokeFlowProgress,         //边框流动样式(需要给出progressH，不设置默认是cell的高度)
    XMPageBarFillFlowProgress,           //填充流动样式(自定义cell不支持这种样式)
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
 正常的title字体 默认16
 */
@property (strong, nonatomic) UIFont *normalFont;
/**
 选中的title字体 默认16
 */
@property (strong, nonatomic) UIFont *selecFont;
/**
 正常title颜色 默认 [UIColor blackColor]
 */
@property (strong, nonatomic) UIColor *normalColor;
/**
 选中title颜色 默认 [UIColor blackColor]
 */
@property (strong, nonatomic) UIColor *selectColor;

#pragma mark - progressView
/**
 进度条的宽度，如果不设置默认为barItem的宽度，且不能大于baritem的宽度
 */
@property (assign, nonatomic) CGFloat progressW;
/**
 进度条的高度，默认为3，值应该大于0.5
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
