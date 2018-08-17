//
//  XMPagerBarLayout.m
//  XMPageController
//
//  Created by EDZ on 2018/8/7.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMPageBarLayout.h"

@interface XMPageBarLayout ()

@property (strong, nonatomic) NSMutableArray *attriArray;
@property (assign, nonatomic) CGFloat contentW;                        //计算高度
@property (assign, nonatomic) CGFloat oringinX;

@end

@implementation XMPageBarLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressH = 3;
        self.progressSwitchAnimation = YES;
        self.oringinX = 0;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.contentW = 0;
    self.oringinX = 0;
    if (self.attriArray) {
        [self.attriArray removeAllObjects];
    } else {
        self.attriArray = [[NSMutableArray alloc] init];
    }
    
    NSInteger item = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < item; i++) {
        self.contentW += [self.dataSource widthForItemAtIndex:i];
        UICollectionViewLayoutAttributes *layout = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attriArray addObject:layout];
    }
    
    self.contentW += (self.cellPadding * 2 + (item - 1) * self.cellSpace);
}

#pragma mark - set get
- (UIFont *)normalFont {
    if (!_normalFont) {
        return [UIFont systemFontOfSize:16];
    }
    return _normalFont;
}

- (UIFont *)selecFont {
    if (!_selecFont) {
        return [UIFont systemFontOfSize:16];
    }
    return _selecFont;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        return [UIColor blackColor];
    }
    return _normalColor;
}

- (UIColor *)selectColor {
    if (!_selectColor) {
        return [UIColor blackColor];
    }
    return _selectColor;
}

- (void)setProgressH:(CGFloat)progressH {
    if (progressH >= 0.5 && progressH <= 5) {
        _progressH = progressH;
    } else if (progressH < 0.5) {
        _progressH = 0.5;
    } else {
        _progressH = 5;
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentW, self.collectionView.frame.size.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attriArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    CGSize itemSize = CGSizeMake([self.dataSource widthForItemAtIndex:indexPath.row], self.collectionView.frame.size.height);
    
    attrs.frame = CGRectMake(self.cellPadding + self.oringinX, 0, itemSize.width, self.barStyle == XMPagerBarStyleProgress ? itemSize.height - self.progressH : itemSize.height);
    self.oringinX += itemSize.width + self.cellSpace;
    return attrs;
}

@end
