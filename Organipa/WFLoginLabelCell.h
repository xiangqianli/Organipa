//
//  WFLoginLabelCell.h
//  WFShipper
//
//  Created by lixiangqian on 2017/6/10.
//  Copyright © 2017年 lixiangqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFLoginLabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
