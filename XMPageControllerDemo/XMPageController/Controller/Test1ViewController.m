//
//  Test1ViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/13.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1"]];
    imageView.frame = CGRectMake((self.view.frame.size.width - 300) / 2, 10, 300, 450);
    [self.view addSubview:imageView];
}


@end
