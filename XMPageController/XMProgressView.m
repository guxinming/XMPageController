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

- (void)moveToPostion:(NSInteger)pos animated:(BOOL)animated {
    
    if (animated) {
        _gap = fabs(self.progress - pos);
        _sign = self.progress > pos ? -1 : 1;
        _step = _gap / self.speedFactor;
        if (_link) {
            [_link invalidate];
        }
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _link = link;
    } else {
        self.progress = pos;
    }
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
    CGFloat height = currentFrame.size.height;
    
    if (self.style == XMTriangleStyle) {
        [self drawTriangle:ctx startX:startX width:width height:currentFrame.size.height];
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
    
    if (self.style == XMLineStyle) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, self.frame.size.height - height, width, height) cornerRadius:height / 2];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, self.color.CGColor);
        CGContextFillPath(ctx);
        return;
    }
    
    if (self.style == XMFillFlowStyle) {
        [self drawFillFlow:ctx startX:startX width:width];
        return;

    }
    
    if (self.style == XMStrokeFlowStyle) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, (self.frame.size.height - height) / 2, width, height) cornerRadius:height / 2];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, self.color.CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        CGContextStrokePath(ctx);
    }
}

- (void)drawTriangle:(CGContextRef)ctx startX:(CGFloat)startX width:(CGFloat)width height:(CGFloat)height {
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGPathMoveToPoint(linePath, NULL, 0, self.frame.size.height);
    CGPathAddLineToPoint(linePath, NULL, self.frame.size.width, self.frame.size.height);
    
    CGContextAddPath(ctx, linePath);
    [self.color set];
    CGContextStrokePath(ctx);
    CGPathRelease(linePath);
    
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, NULL, startX + width / 2.0 - height, self.frame.size.height);
    CGPathAddLineToPoint(trianglePath, NULL, startX + width / 2.0, self.frame.size.height - height);
    CGPathAddLineToPoint(trianglePath, NULL, startX + width / 2.0 + height, self.frame.size.height);
    CGContextAddPath(ctx, trianglePath);
    [self.color set];
    CGContextFillPath(ctx);
    CGPathRelease(trianglePath);
}

- (void)drawFillFlow:(CGContextRef)ctx startX:(CGFloat)startX width:(CGFloat)width {
    for (int i = 0; i < self.textArray.count; i++) {
        
        NSString *text = self.textArray[i];
        CGRect rect = [self.progressFrames[i] CGRectValue];
        CGSize size = [text boundingRectWithSize:CGSizeMake(rect.size.width, 14) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.normalFont} context:nil].size;
        [self.textArray[i] drawInRect:CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2, (rect.size.height - size.height) / 2, size.width, size.height) withAttributes:@{NSFontAttributeName:self.normalFont, NSForegroundColorAttributeName:self.normalColor}];
    }
    
    NSInteger nextIndex = 0;
    if ((int)self.progress > self.curIndex || (int)self.progress < self.curIndex) {
        nextIndex = (int)self.progress;
    } else if (self.progress < self.curIndex && (int)self.progress == self.curIndex) {
        nextIndex = self.curIndex - 1 < 0 ? 0 : self.curIndex - 1;
    } else if (self.progress > self.curIndex && (int)self.progress == self.curIndex) {
        nextIndex = self.curIndex + 1 > self.progressFrames.count - 1 ? self.progressFrames.count - 1 : self.curIndex + 1;
    }
    
    NSString *currentText = self.textArray[self.curIndex];
    NSString *nextText = self.textArray[nextIndex];
    CGRect currentRect = [self.progressFrames[self.curIndex] CGRectValue];
    CGRect nextRect = [self.progressFrames[nextIndex] CGRectValue];
    CGSize curSize = [currentText boundingRectWithSize:CGSizeMake(currentRect.size.width, 14) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.normalFont} context:nil].size;
    CGSize nextSize = [nextText boundingRectWithSize:CGSizeMake(nextRect.size.width, 14) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.normalFont} context:nil].size;
    CGFloat height = curSize.height >= nextSize.height ? curSize.height : nextSize.height;
    height = height > self.frame.size.height ? self.frame.size.height : height;
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGRect rect = CGRectMake(startX, (self.frame.size.height - height - 10) / 2, width, curSize.height + 10);
    CGPathAddRoundedRect(circlePath, nil, rect, (height + 10) / 2, (height + 10) / 2);
    CGContextAddPath(ctx, circlePath);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextFillPath(ctx);
    CGPathRelease(circlePath);
    
    CGMutablePathRef clipPath = CGPathCreateMutable();
    CGPathAddRoundedRect(clipPath, nil, rect, (height + 10) / 2, (height + 10) / 2);
    CGContextAddPath(ctx, clipPath);
    CGPathRelease(clipPath);
    CGContextClip(ctx);
    
    [self.textArray[self.curIndex] drawInRect:CGRectMake(currentRect.origin.x + (currentRect.size.width - curSize.width) / 2, (currentRect.size.height - curSize.height) / 2, nextSize.width, nextSize.height + 10) withAttributes:@{NSFontAttributeName:self.normalFont, NSForegroundColorAttributeName:self.selectColor}];
    [self.textArray[nextIndex] drawInRect:CGRectMake(nextRect.origin.x + (nextRect.size.width - nextSize.width) / 2, (nextRect.size.height - nextSize.height) / 2, nextSize.width, nextSize.height + 10) withAttributes:@{NSFontAttributeName:self.normalFont, NSForegroundColorAttributeName:self.selectColor}];
}
@end
