//
//  WFGroupEngine.h
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFNetworkSessionManager.h"

@class WFGroup, WFMessage;
typedef void(^WFGroupEngineCreateGroupCompletionHandler)(WFGroup * group, NSError * error);

@interface WFGroupEngine : NSObject

@property (strong, nonatomic) dispatch_queue_t ioqueue;

+ (instancetype)sharedGroupEngine;

- (void)createGroup:(NSInteger)uid groupName:(NSString *)groupName completionHandler:(WFGroupEngineCreateGroupCompletionHandler)comletionHandler;

- (void)joinGroup:(NSInteger)uid groupName:(NSString *)groupName completionHandler:(WFGroupEngineCreateGroupCompletionHandler)comletionHandler;

//数据库操作
- (void)deleteGroupFromDatabase:(WFGroup *)group;

- (void)updateMessageListGroupIfNeed:(WFMessage *)message completionHandler:(void(^)(void))block;

@end
