//
//  WFMessage.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFUser.h"

@interface WFMessage : RLMObject<NSCopying>

@property (nonatomic, strong) NSDate * create_time;
@property (nonatomic, assign) NSInteger create_time_interval;

//消息关联的用户
@property (nonatomic, assign) NSInteger from_id;
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, copy) NSString * fromStr;//用户名称

@property (nonatomic, copy) NSString * gid;
@property (nonatomic, assign) NSInteger messageType;

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * pictureUrl;
@property (nonatomic, copy) NSString * voiceUrl;

@end
