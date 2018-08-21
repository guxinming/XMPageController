//
//  XMProgressView.h
//  XMPageController
//
//  Created by EDZ on 2018/8/15.
//  Copyright © 2018年 EDZ. All rights reserved.
//
/**
 这个类是引用的github框架 WMPageController的WMProgressView，WMPageController是一个极为优秀的库，看到这个view的实现，当场就给跪了，有兴趣的朋友可以去看看这个框架https://github.com/wangmchn/WMPageController，功能要强大很多
 */

#import <UIKit/UIKit.h>
#import "XMPageCotrol.h"

@interface XMProgressView : UIView

@property (assign, nonatomic) XMProgressStyle style;

@property (copy, nonatomic)   NSArray *progressFrames;

/** 进度条的速度因数，默认为 15，越小越快， 大于 0 */
@property (nonatomic, assign) CGFloat speedFactor;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat progress;

- (void)moveToPostion:(NSInteger)pos animated:(BOOL)animated;

@end
