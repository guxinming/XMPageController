//
//  Test2ViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/13.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2"]];
    imageView.frame = CGRectMake((self.view.frame.size.width - 300) / 2, 10, 300, 300);
    [self.view addSubview:imageView];
}


@end
