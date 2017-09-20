//
//  WFMessage.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFMessage.h"

@implementation WFMessage

- (id)copyWithZone:(NSZone *)zone{
    WFMessage * message = [[WFMessage alloc]init];
    message.from_id = _from_id;
    message.gid = _gid;
    message.content = [_content copy];
    message.create_time = _create_time;
    message.create_time_interval = _create_time_interval;
    message.messageType = _messageType;
    message.fromStr = [_fromStr copy];
    return message;
}

@end
