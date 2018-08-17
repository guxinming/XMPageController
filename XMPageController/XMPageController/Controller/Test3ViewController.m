//
//  Test3ViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/16.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "Test3ViewController.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic3"]];
    imageView.frame = CGRectMake((self.view.frame.size.width - 300) / 2, 10, 300, 450);
    [self.view addSubview:imageView];
}


@end
