//
//  UIImageView+Corner.m
//  WFByr
//
//  Created by lixiangqian on 17/6/3.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "UIImageView+Corner.h"

@implementation UIImageView (Corner)

- (void)wf_addCorner:(CGFloat)cornerRadius{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[self wf_addCorner:cornerRadius borderWidth:1 backgroundColor:[UIColor whiteColor] borderColor:[UIColor whiteColor]]];
    [self insertSubview:imageView atIndex:0];
}

- (UIImage *)wf_addCorner:(CGFloat)cornerRadius borderWidth:(CGFloat)boarderWidth backgroundColor:(UIColor*)backgroundColor borderColor:(UIColor*)borderColor{
    
    CGSize sizeToFit = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    CGFloat halfBoarderWidth = boarderWidth/2.0;
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, 0.0);
    
    CGContextRef context= UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, boarderWidth);
    CGContextSetStrokeColorWithColor(context,[borderColor CGColor]);
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    
    CGFloat width = sizeToFit.width;
    CGFloat height = sizeToFit.height;
    //绘制圆形路径
    CGContextMoveToPoint(context, width - halfBoarderWidth, cornerRadius + halfBoarderWidth);
    CGContextAddArcToPoint(context, width - halfBoarderWidth, height-halfBoarderWidth, width - halfBoarderWidth - cornerRadius, height - halfBoarderWidth, cornerRadius);
    
    CGContextAddArcToPoint(context, halfBoarderWidth, height - halfBoarderWidth, halfBoarderWidth, height - cornerRadius - halfBoarderWidth, cornerRadius);
    
    CGContextAddArcToPoint(context, halfBoarderWidth, halfBoarderWidth, cornerRadius + halfBoarderWidth, halfBoarderWidth, cornerRadius);
    
    CGContextAddArcToPoint(context, width - halfBoarderWidth, halfBoarderWidth, width - halfBoarderWidth, cornerRadius + halfBoarderWidth, cornerRadius);
    
    //创建矩形路径
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, width)];
    
    CGContextAddPath(context, path.CGPath);
    //CGContextClip(UIGraphicsGetCurrentContext());
    
    //[self drawInRect:rect];
    
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//图标覆盖颜色
- (void)wf_addColorCover:(UIColor *)coverColor{
    UIImage * currentImage = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
    [coverColor set];
    [currentImage drawInRect:self.bounds];
    currentImage = UIGraphicsGetImageFromCurrentImageContext();
    self.image = currentImage;
}

@end
