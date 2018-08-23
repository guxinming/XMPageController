//
//  PageViewController.h
//  XMPageController
//
//  Created by EDZ on 2018/8/6.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPageBar.h"

@interface PageViewController : UIViewController

@property (assign, nonatomic) CGFloat progressW;
@property (assign, nonatomic) XMPagerBarStyle style;
@property (assign, nonatomic) CGFloat progressH;

@end
