//
//  WFGroupEngine.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFGroupEngine.h"
#import "WFNetworkSessionManager.h"
#import "WFGroup.h"
#import "NSDate+Utils.h"

@implementation WFGroupEngine

- (instancetype)init{
    if (self = [super init]) {
        _ioqueue = dispatch_queue_create(DISPATCH_Realm_Queue, nil);
    }
    return self;
}

- (void)createGroup:(NSInteger)uid groupName:(NSString *)groupName completionHandler:(WFGroupEngineCreateGroupCompletionHandler)comletionHandler{
    NSString * url = [NSString stringWithFormat:@"%@%@", self.WFNetworkBaseUrl, @"groupchat/create"];
    WFNetworkMethodType type = WFNetworkMethodTypePost;
    NSDictionary * newparameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",uid],@"user_id",groupName,@"group_id",nil];
    [[WFNetworkSessionManager sharedManager] sendRequestWithUrl:url method:type parameters:newparameters success:^(NSInteger statusCode, id responseObject) {
        if (comletionHandler && [responseObject[@"code"] isEqual:@1]) {
            WFGroup * group = [[WFGroup alloc]init];
            group.gid = responseObject[@"entity"][@"group_id"];
            group.ownerid = uid;
            group.gname = groupName;
            group.update_time = [NSDate dateFromString:responseObject[@"entity"][@"updated_at"]];
            [self saveNewGroupToDatabase:group];
            comletionHandler(group, nil);
        }
    } failure:^(NSInteger statusCode, id responseObject) {
        if (comletionHandler) {
            NSError  *error = [NSError errorWithDomain:NSURLErrorFailingURLStringErrorKey code:0 userInfo:responseObject];
            comletionHandler(nil, error);
        }
    }];
}

- (void)joinGroup:(NSInteger)uid groupName:(NSString *)groupName completionHandler:(WFGroupEngineCreateGroupCompletionHandler)comletionHandler{
    NSString * url = [NSString stringWithFormat:@"%@%@", self.WFNetworkBaseUrl, @"groupchat/join"];
    WFNetworkMethodType type = WFNetworkMethodTypePost;
    NSDictionary * newparameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",uid],@"user_id",groupName,@"group_id",nil];
    [[WFNetworkSessionManager sharedManager] sendRequestWithUrl:url method:type parameters:newparameters success:^(NSInteger statusCode, id responseObject) {
        if (comletionHandler && [responseObject[@"code"] isEqual:@1]) {
            WFGroup * group = [[WFGroup alloc]init];
            group.gid = groupName;
            group.ownerid = uid;
            group.gname = groupName;
            group.update_time = [NSDate dateFromString:responseObject[@"entity"][@"updated_at"]];
            [self saveNewGroupToDatabase:group];
            comletionHandler(group, nil);
        }
    } failure:^(NSInteger statusCode, id responseObject) {
        if (comletionHandler) {
            NSError  *error = [NSError errorWithDomain:NSURLErrorFailingURLStringErrorKey code:0 userInfo:responseObject];
            comletionHandler(nil, error);
        }
    }];
}

- (NSString *)WFNetworkBaseUrl{
    return @"http://organipa.andysheng.cn/";
}

+ (instancetype)sharedGroupEngine{
    static WFGroupEngine * groupEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groupEngine = [[WFGroupEngine alloc]init];
    });
    return groupEngine;
}

#pragma mark -- 数据库操作
- (void)saveNewGroupToDatabase:(WFGroup *)group{
   // dispatch_async([WFGroupEngine sharedGroupEngine].ioqueue, ^{
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:group];
        }];
    //});
}

- (void)deleteGroupFromDatabase:(WFGroup *)group{
    //dispatch_async([WFGroupEngine sharedGroupEngine].ioqueue, ^{
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteObject:group];
        }];
    //});
}

- (void)updateMessageListGroupIfNeed:(WFMessage *)message completionHandler:(void(^)(void))block{
        RLMResults<WFGroup *> * results = [WFGroup objectsWhere:@"gid = %@", message.gid];
        if ([results count] > 0) {
            WFGroup * group = results.firstObject;
                RLMRealm * realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    group.lastMessage = [message copy];
                }];
                if (block) {
                    block();
                }
        }
    
}
@end
