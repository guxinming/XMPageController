//
//  XMPageViewController.m
//  XMPageController
//
//  Created by EDZ on 2018/8/6.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMPageViewController.h"

@interface XMPageViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL dragging;

@end

@implementation XMPageViewController

@synthesize curIndex = _curIndex, maxIndex = _maxIndex, controllers = _controllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
  
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    _curIndex = 0;
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollView.scrollEnabled = scrollEnable;
    _scrollEnable = scrollEnable;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerViewDidScroll:)]) {
        [self.delegate pageControllerViewDidScroll:self];
    }
    
    float pageOffset = scrollView.contentOffset.x / scrollView.frame.size.width;
    //左滑
    if (pageOffset > _curIndex) {
        [self refreshCurIndex:floor(pageOffset) progress:pageOffset];
    }
    //右滑
    else {
        [self refreshCurIndex:ceil(pageOffset) progress:pageOffset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerDidEndDragging:willDecelerate:)]) {
        [self.delegate pageControllerDidEndDragging:self willDecelerate:decelerate];
    }
    if (decelerate) return;
    _curIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerDidEndDecelerating:)]) {
        [self.delegate pageControllerDidEndDecelerating:self];
    }
    _curIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - private methods
- (void)refreshCurIndex:(NSInteger)index progress:(float)progress {
    if (index > self.maxIndex || index < 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:transitProgress:isDragging:)]) {
        [self.delegate pageController:self transitProgress:progress isDragging:self.dragging];
    }
    
    if (index == _curIndex) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:transitionFrom:toIndex:animated:)]) {
        [self.delegate pageController:self transitionFrom:self.curIndex toIndex:index animated:YES];
    }
    _curIndex = index;
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    
    self.dragging = NO;
    
    if (index > self.maxIndex) {
        NSLog(@"out the max index");
        return;
    }
    //如果已经滑动到这，就不再调代理了
    if (_curIndex == index) {
        return;
    }
    
    _curIndex = index;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(index * self.scrollView.frame.size.width, 0);
        }];
    } else {
        self.scrollView.contentOffset = CGPointMake(index * _scrollView.frame.size.width, 0);
    }
}

- (void)reloadPageData {
    //移除所有的子vc
    for (UIViewController *viewController in self.childViewControllers) {
        [viewController removeFromParentViewController];
    }
    //将子vc的View也移除
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInPageControler)] && [self.dataSource respondsToSelector:@selector(pageController:itemAtIndex:)]) {
        _maxIndex = [self.dataSource numberOfItemsInPageControler] - 1;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * (_maxIndex + 1), self.view.frame.size.height);
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < _maxIndex + 1; i++) {
            UIViewController *vc = [self.dataSource pageController:self itemAtIndex:i];
            if (![self.childViewControllers containsObject:vc]) {
                [self addChildViewController:vc];
            }
            vc.view.frame = CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            if (![self.scrollView.subviews containsObject:vc.view]) {
                [self.scrollView addSubview:vc.view];
            }
            [array addObject:vc];
        }
        _controllers = array;
    }
}

@end
