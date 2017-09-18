//
//  UIButton+Common.m
//  WFShipper
//
//  Created by lixiangqian on 2017/6/11.
//  Copyright © 2017年 lixiangqian. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (UIButton *)buttonWithTitle:(NSString *)title offsetY:(CGFloat)offsetY{
    UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setTitle:title forState:UIControlStateNormal];
    actionButton.frame = CGRectMake(25, offsetY, WFSCREEN_W - 50, 47);
    [actionButton setBackgroundColor:MAIN_BLUE];
    [actionButton setTintColor:[UIColor blackColor]];
    actionButton.layer.masksToBounds = YES;
    actionButton.layer.cornerRadius = 5;
    return actionButton;
}
@end
