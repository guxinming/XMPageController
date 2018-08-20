//
//  XMProgressView.m
//  XMPageController
//
//  Created by EDZ on 2018/8/15.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMProgressView.h"

@implementation XMProgressView {
    int     _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak  CADisplayLink *_link;
}

- (void)setProgress:(CGFloat)progress {
    if (self.progress == progress) return;
    
    _progress = progress;
    [self setNeedsDisplay];
}

- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

- (void)moveToPostion:(NSInteger)pos {
    _gap = fabs(self.progress - pos);
    _sign = self.progress > pos ? -1 : 1;
    _step = _gap / self.speedFactor;
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)progressChanged {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.progress = (int)(self.progress + _sign * _step + 0.5);
            return;
        }
        self.progress += _sign * _step;
    } else {
        self.progress = (int)(self.progress + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    if (self.progress < 0) {
        self.progress = 0;
    }
    if (self.progress > self.progressFrames.count - 1) {
        self.progress = self.progressFrames.count - 1;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = self.frame.size.height;
    int index = (int)self.progress;

    CGFloat rate = self.progress - index;
    CGRect currentFrame = [self.progressFrames[index] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    int nextIndex = index + 1 < self.progressFrames.count ? index + 1 : index;
    CGFloat nextWidth = [self.progressFrames[nextIndex] CGRectValue].size.width;
    
    CGFloat currentX = currentFrame.origin.x;
    CGFloat nextX = [self.progressFrames[nextIndex] CGRectValue].origin.x;
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat width = currentWidth + (nextWidth - currentWidth)*rate;
    CGFloat endX = startX + width;

    CGFloat currentMidX = currentX + currentWidth / 2.0;
    CGFloat nextMidX   = nextX + nextWidth / 2.0;
    
    if (self.style == XMProgressTriangleStyle) {
        
        CGMutablePathRef linePath = CGPathCreateMutable();
        CGPathMoveToPoint(linePath, NULL, 0, height);
        CGPathAddLineToPoint(linePath, NULL, self.frame.size.width, height);
        
        CGContextAddPath(ctx, linePath);
        [self.color set];
        CGContextStrokePath(ctx);
        CGPathRelease(linePath);
        
        CGMutablePathRef trianglePath = CGPathCreateMutable();
        CGPathMoveToPoint(trianglePath, NULL, startX + width / 2.0 - height, height);
        CGPathAddLineToPoint(trianglePath, NULL, startX + width / 2.0, 0);
        CGPathAddLineToPoint(trianglePath, NULL, startX + width / 2.0 + height, height);
        CGContextAddPath(ctx, trianglePath);
        [self.color set];
        CGContextFillPath(ctx);
        CGPathRelease(trianglePath);
        return;
    }

    if (rate <= 0.5) {
        startX = currentX + (currentMidX - currentX) * rate * 2.0;
        CGFloat currentMaxX = currentX + currentWidth;
        endX = currentMaxX + (nextMidX - currentMaxX) * rate * 2.0;
    } else {
        startX = currentMidX + (nextX - currentMidX) * (rate - 0.5) * 2.0;
        CGFloat nextMaxX = nextX + nextWidth;
        endX = nextMidX + (nextMaxX - nextMidX) * (rate - 0.5) * 2.0;
    }
    width = endX - startX;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, 0, width, height) cornerRadius:self.frame.size.height / 2];
    CGContextAddPath(ctx, path.CGPath);

    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextFillPath(ctx);
}

@end
