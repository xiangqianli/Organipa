//
//  WFGroup.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFGroup.h"

@implementation WFGroup

- (id)copyWithZone:(NSZone *)zone{
    WFGroup * group = [[WFGroup alloc]init];
    group.gid = [_gid copy];
    group.gname = [_gname copy];
    group.ownerid = _ownerid;
    group.imageUrl = [_imageUrl copy];
    group.lastMessage = [_lastMessage copy];
    group.update_time = _update_time;
    group.create_time = _create_time;
    group.lastMessage = [_lastMessage copy];
    return group;
}

@end
