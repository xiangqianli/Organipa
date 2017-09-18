//
//  WFLoginLabelCell.m
//  WFShipper
//
//  Created by lixiangqian on 2017/6/10.
//  Copyright © 2017年 lixiangqian. All rights reserved.
//

#import "WFLoginLabelCell.h"

@implementation WFLoginLabelCell

+ (instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString * identifier = @"WFLoginLabelCell";
    WFLoginLabelCell * cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WFLoginLabelCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inputField.borderStyle = UITextBorderStyleNone;
    self.inputField.backgroundColor = [UIColor clearColor];
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputField.returnKeyType = UIReturnKeyNext;

    self.titleLabel.backgroundColor = [UIColor clearColor];
    
}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    
//    CGContextFillRect(context, CGRectMake(25, CGRectGetHeight(rect) - 1, CGRectGetWidth(rect)-25, 1));
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
