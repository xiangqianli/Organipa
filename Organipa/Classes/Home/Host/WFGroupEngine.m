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

@implementation WFGroupEngine

- (instancetype)init{
    if (self = [super init]) {
        _ioqueue = [[NSOperationQueue alloc]init];
        _ioqueue.maxConcurrentOperationCount = 2;
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
            group.gid = responseObject[@"entity"][@"group_id"];
            group.ownerid = uid;
            group.gname = groupName;
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

@end