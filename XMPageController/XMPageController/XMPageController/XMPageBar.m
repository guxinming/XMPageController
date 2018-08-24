//
//  XMPageBar.m
//  XMPageController
//
//  Created by EDZ on 2018/8/7.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMPageBar.h"
#import "XMPageBarCell.h"
#import "XMProgressView.h"

@interface XMPageBar () <UICollectionViewDataSource, UICollectionViewDelegate, XMPageBarLayoutDataSource>

@property (strong, nonatomic) UICollectionView *collectView;
/**
 进度view
 */
@property (strong, nonatomic) XMProgressView *progressView;

@property (strong, nonatomic) NSMutableArray *identifierArray;

@end

@implementation XMPageBar

- (UICollectionView *)collectView {
    if (!_collectView) {
        
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.showsHorizontalScrollIndicator = NO;
        [_collectView registerClass:[XMPageBarCell class] forCellWithReuseIdentifier:@"xmPageBarCell"];
    }
    return _collectView;
}

- (XMProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[XMProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.userInteractionEnabled = NO;
        if (self.layout.barStyle == XMPageBarLineProgress) {
            _progressView.style = XMLineStyle;
        } else if (self.layout.barStyle == XMPageBarTriangleProgress) {
            _progressView.style = XMTriangleStyle;
        } else if (self.layout.barStyle == XMPageBarFillFlowProgress) {
            _progressView.style = XMFillFlowStyle;
        } else if (self.layout.barStyle == XMPageBarStrokeFlowProgress) {
            _progressView.style = XMStrokeFlowStyle;
        }
        _progressView.color = self.layout.progressColor;
        _progressView.speedFactor = self.layout.progressSpeed;
        _progressView.selectFont = self.layout.selecFont;
        _progressView.selectColor = self.layout.selectColor;
        _progressView.normalFont = self.layout.normalFont;
        _progressView.normalColor = self.layout.normalColor;
        NSMutableArray *progressFrames = [NSMutableArray array];
        NSMutableArray *textArray = [NSMutableArray array];
        CGFloat width = 0;
        for (int i = 0; i < [self.collectView numberOfItemsInSection:0]; i++) {
        
            CGFloat progressW = (self.layout.progressW == 0 || self.layout.progressW > [self widthForItemAtIndex:i]) ? [self widthForItemAtIndex:i] : self.layout.progressW;
            if (_progressView.style == XMLineStyle || _progressView.style == XMTriangleStyle) {
                CGRect itemFrame = CGRectMake(width + self.layout.cellPadding + i * self.layout.cellSpace, 0, [self widthForItemAtIndex:i], self.frame.size.height - self.layout.progressH);
                CGFloat x = itemFrame.origin.x + (itemFrame.size.width - progressW) / 2;
                CGRect progressFrame = CGRectMake(x, self.frame.size.height - self.layout.progressH, progressW, self.layout.progressH);
                [progressFrames addObject:[NSValue valueWithCGRect:progressFrame]];
            } else if (_progressView.style == XMFillFlowStyle) {
                if (!self.dataSource && ![self.dataSource respondsToSelector:@selector(titleForCellAtIndex:)]) {
                    NSAssert(NO, @"you need implementation method -(void)titleForCellAtIndex:");
                }
                
                [textArray addObject:[self.dataSource titleForCellAtIndex:i]];
                
                CGRect itemFrame = CGRectMake(width + self.layout.cellPadding + i * self.layout.cellSpace, 0, [self widthForItemAtIndex:i], self.frame.size.height);
                [progressFrames addObject:[NSValue valueWithCGRect:itemFrame]];
            } else if (_progressView.style == XMStrokeFlowStyle) {
                CGRect itemFrame = CGRectMake(width + self.layout.cellPadding + i * self.layout.cellSpace, 0, [self widthForItemAtIndex:i], self.layout.progressH == 0 ? self.frame.size.height : self.layout.progressH);
                [progressFrames addObject:[NSValue valueWithCGRect:itemFrame]];
            }
            width += [self widthForItemAtIndex:i];
            
        }
        
        _progressView.progressFrames = progressFrames;
        _progressView.textArray = textArray;
        _progressView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }
    return _progressView;
}

- (XMPageBarLayout *)layout {
    if (!_layout) {
        _layout = [[XMPageBarLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.dataSource = self;
    }
    return _layout;
}

- (NSMutableArray *)identifierArray {
    if (!_identifierArray) {
        _identifierArray = [[NSMutableArray alloc] init];
    }
    return _identifierArray;
}

- (void)setBounces:(BOOL)bounces {
    self.collectView.bounces = bounces;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemInPageBar)]) {
        return [self.dataSource numberOfItemInPageBar];
    } else {
        NSAssert(NO, @"you need implementation method numberOfItemInPageBar");
        return 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageBar:cellForItemAtIndex:)]) {
        UICollectionViewCell *cell = [self.dataSource pageBar:self cellForItemAtIndex:indexPath.row];
        NSAssert(cell != nil, @"cell must not be nil");
        return cell;
    } else {
        XMPageBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xmPageBarCell" forIndexPath:indexPath];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForCellAtIndex:)]) {
            if (self.layout.barStyle != XMPageBarFillFlowProgress) {
               cell.titleLabel.text = [self.dataSource titleForCellAtIndex:indexPath.row];
            }
        } else {
            NSAssert(NO, @"you need implementation method -(void)titleForCellAtIndex:");
        }
        if (indexPath.row == self.curIndex) {
            cell.titleLabel.font = self.layout.selecFont;
            cell.titleLabel.textColor = self.layout.selectColor;
            
        } else {
            cell.titleLabel.font = self.layout.normalFont;
            cell.titleLabel.textColor = self.layout.normalColor;
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItemAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageBar:didSelectItemAtIndex:)]) {
        [self.delegate pageBar:self didSelectItemAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageBar:didDeselectItemAtIndex:)]) {
        [self.delegate pageBar:self didDeselectItemAtIndex:indexPath.row];
    }
}

#pragma mark - XMPageBarLayoutDataSource
- (CGFloat)widthForItemAtIndex:(NSInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(widthForPageBarCellAtIndex:)]) {
        NSAssert([self.dataSource widthForPageBarCellAtIndex:index] != 0, @"the width not be zero");
        return [self.dataSource widthForPageBarCellAtIndex:index];
    } else {
        NSAssert(NO, @"you need implementation method widthForPageBarCellAtIndex:");
        return 0;
    }
}

#pragma mark - public method
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    if (![self.identifierArray containsObject:identifier]) {
        [self.identifierArray addObject:identifier];
    }
    
    [self.collectView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    if (![self.identifierArray containsObject:identifier]) {
        [self.identifierArray addObject:identifier];
    }
    [self.collectView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier index:(NSInteger)index {
    if (![self.identifierArray containsObject:identifier]) {
        NSAssert(NO, @"you not register cell for this identifier");
    }
    return [self.collectView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (UICollectionViewCell *)cellForIndex:(NSInteger)index {
    if (index > self.collectView.numberOfSections - 1 && index < 0) {
        NSAssert(NO, @"the index beyond the bounds of cellNum");
    }
    return [self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)reloadData {
    if (![self.subviews containsObject:self.collectView]) {
        [self addSubview:self.collectView];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageBar:cellForItemAtIndex:)] && self.layout.barStyle == XMPageBarFillFlowProgress) {
            self.layout.barStyle = XMPageBarStyleNone;
        }
        
        if (![self.collectView.subviews containsObject:self.progressView] && self.layout.barStyle != XMPageBarStyleNone) {
        
            [self.collectView addSubview:self.progressView];
            self.progressView.progress = self.curIndex;
        }
    }

    self.scrollContentToCenter = YES;
    [self.collectView reloadData];
}

- (void)selectItemAtIndex:(NSInteger)index {
    
    self.curIndex = index;
    [self.collectView reloadData];
    if (self.collectView.contentSize.width <= self.frame.size.width) {
        return;
    }
    if (!self.scrollContentToCenter) return;
    
    CGFloat contentOffset = 0;
    for (int i = 0; i < self.curIndex; i++) {
        contentOffset += [self.dataSource widthForPageBarCellAtIndex:i] + self.layout.cellSpace;
    }
    contentOffset += [self.dataSource widthForPageBarCellAtIndex:index] / 2;
    
    //view的最大偏移量
    CGFloat maxOffset = self.collectView.contentSize.width - self.frame.size.width;
    
    if (contentOffset > self.frame.size.width / 2) {
        contentOffset = contentOffset - self.frame.size.width / 2 > maxOffset ? maxOffset : contentOffset - self.frame.size.width / 2;
    } else {
        contentOffset = 0;
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.collectView.contentOffset = CGPointMake(contentOffset, 0);
    }];
}

- (void)refreshProgress:(float)progress isDragging:(BOOL)isDragging animated:(BOOL)animated {

    if (!isDragging) {
        [self.progressView moveToPostion:(int)progress animated:animated];
        return;
    }
    
    if (self.dataSource) {

        self.progressView.curIndex = self.curIndex;
        NSInteger nextIndex = progress > self.curIndex ? self.curIndex + 1 : self.curIndex - 1;
        if (nextIndex > [self.collectView numberOfItemsInSection:0] - 1) {
            nextIndex = [self.collectView numberOfItemsInSection:0] - 1;
        }
        if (nextIndex < 0) {
            nextIndex = 0;
        }
        if ([self.dataSource respondsToSelector:@selector(pageBar:cellForItemAtIndex:)]) {
            if (nextIndex == self.curIndex) return;
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageBar:transitFromIndex:toIndex:progress:)]) {
                [self.delegate pageBar:self transitFromIndex:self.curIndex toIndex:nextIndex progress:fabs(progress - self.curIndex)];
            }
        } else {
            
            if (nextIndex != self.curIndex) {
                XMPageBarCell *fromCell = (XMPageBarCell *)[self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0]];
                XMPageBarCell *tocell = (XMPageBarCell *)[self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
                CGFloat rate = fabs(progress - self.curIndex);
                
                CGFloat narR = 0, narG = 0, narB = 0, narA = 1;
                [self.layout.normalColor getRed:&narR green:&narG blue:&narB alpha:&narA];
                CGFloat selR = 0,selG = 0,selB = 0, selA = 1;
                [self.layout.selectColor getRed:&selR green:&selG blue:&selB alpha:&selA];
                CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
                fromCell.titleLabel.textColor = [UIColor colorWithRed:selR+detalR*rate green:selG+detalG*rate blue:selB+detalB*rate alpha:selA+detalA*rate];
                tocell.titleLabel.textColor = [UIColor colorWithRed:narR-detalR*rate green:narG-detalG*rate blue:narB-detalB*rate alpha:narA-detalA*rate];
            }
        }
    }
    
    self.progressView.progress = progress;
}

@end
