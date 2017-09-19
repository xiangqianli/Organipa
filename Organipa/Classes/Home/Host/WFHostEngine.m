//
//  WFHostEngine.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFHostEngine.h"
#import "WFNetworkSessionManager+WFBaiduUser.h"
#import "WFUser.h"
#import <YYModel.h>

@implementation WFHostEngine

- (instancetype)init{
    if (self = [super init]) {
        _ioqueue = [[NSOperationQueue alloc]init];
        _ioqueue.maxConcurrentOperationCount = 2;
    }
    return self;
}
- (void)getCurrentUserInfoWithAccessTocken:(NSString *)accessTocken CompletionHandler:(WFHostEngineCompletionUserHandler)completionHandler{
    [[WFNetworkSessionManager sharedManager]getUserInfoWithAccessTocken:accessTocken CompletionBlock:^(id response, BOOL isSuccess) {
        if (isSuccess) {
            WFUser * baiduUser = [WFUser yy_modelWithDictionary:response];
            if (completionHandler) {
                completionHandler(baiduUser, nil);
            }
        }
    }];
}
@end
