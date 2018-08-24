//
//  XMPageBarCell.m
//  XMPageController
//
//  Created by EDZ on 2018/8/13.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMPageBarCell.h"

@implementation XMPageBarCell

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![self.subviews containsObject:self.titleLabel]) {
        [self addSubview:self.titleLabel];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    //每一次layout必须更改frame，不然排版错乱
    _titleLabel.frame = self.contentView.bounds;
    return _titleLabel;
}
@end
