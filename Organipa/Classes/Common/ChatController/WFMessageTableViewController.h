//
//  WFMessageTableViewController.h
//  Organipa
//
//  Created by 李向前 on 2017/9/11.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFGroup.h"

@interface WFMessageTableViewController : UIViewController

@property (nonatomic, strong) WFGroup * group;

- (instancetype)initWithGroupId:(NSString *)groupId groupName:(NSString *)groupName;

@end
