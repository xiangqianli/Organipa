//
//  WFUser.m
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUser.h"

@implementation WFUser

- (id)copyWithZone:(NSZone *)zone{
    WFUser * user = [[WFUser alloc]init];
    user.uid = self.uid;
    user.uname = [self.uname copy];
    user.portrait = [self.portrait copy];
    return user;
}
@end
