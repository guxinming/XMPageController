//
//  Test5ViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/16.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "Test5ViewController.h"

@interface Test5ViewController ()

@end

@implementation Test5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic5"]];
    imageView.frame = CGRectMake((self.view.frame.size.width - 300) / 2, 10, 300, 450);
    [self.view addSubview:imageView];
}

@end
