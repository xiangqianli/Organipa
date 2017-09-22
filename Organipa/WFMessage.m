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
    message.cleanContent = [_cleanContent copy];
    message.create_time = _create_time;
    message.create_time_interval = _create_time_interval;
//    if (_messageType == 3) {
//        message.messageType = 0;
//        message.content = [_cleanContent copy];
//    }else{
        message.messageType = _messageType;
        message.cleanContent = [_cleanContent copy];
//    }
    message.fromStr = [_fromStr copy];
    
    message.pictureUrl = [_pictureUrl copy];
    message.voiceUrl = [_voiceUrl copy];
    message.tag = 1;
    return message;
}

@end
