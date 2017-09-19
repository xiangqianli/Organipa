//
//  WFGroup.h
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RCMessage.h>

@interface WFGroup : NSObject

@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, assign) NSInteger ownerid;
@property (nonatomic, copy) NSString * gname;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, strong) RCMessage * lastMessage;

@end
