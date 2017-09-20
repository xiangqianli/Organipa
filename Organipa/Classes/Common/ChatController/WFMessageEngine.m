//
//  WFMessageEngine.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFMessageEngine.h"
#import "WFMessage.h"

static NSString * const WFReceiveNewMessageNotification = @"WFReceiveNewMessageNotification";

@interface WFMessageEngine()

@end

@implementation WFMessageEngine

+ (instancetype)sharedMessageEngine{
   static WFMessageEngine * messageEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (messageEngine == nil) {
            messageEngine = [[WFMessageEngine alloc]init];
            //设置接收消息的类
            [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];

        }
    });
    return messageEngine;
}

#pragma mark -- 接收消息delegate
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object{
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage * textMessage = (RCTextMessage *)message.content;
        WFMessage * fmessage = [[WFMessage alloc]init];
        fmessage.create_time = [NSDate dateWithTimeIntervalSince1970:message.sentTime];
        fmessage.create_time_interval = message.sentTime;
        fmessage.content = [textMessage.content copy];
        fmessage.from_id = [message.senderUserId integerValue];
        fmessage.fromStr = message.senderUserId;
        fmessage.gid = message.targetId;
        [[NSNotificationCenter defaultCenter] postNotificationName:WFReceiveNewMessageNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:fmessage,@"message",nil]];
    }
}

@end
