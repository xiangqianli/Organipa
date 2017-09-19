//
//  WFHostEngine.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFHostEngine.h"
#import "WFNetworkSessionManager+WFRongyunUser.h"
#import "WFNetworkSessionManager+WFBaiduUser.h"
#import "WFUser.h"
#import <YYModel.h>

@implementation WFHostEngine{
    NSDictionary * baiduUserDict;
}

- (instancetype)init{
    if (self = [super init]) {
      
    }
    return self;
}

- (void)getCurrentUserInfoWithAccessTocken:(NSString *)accessTocken CompletionHandler:(WFHostEngineCompletionUserHandler)completionHandler{
    [[WFNetworkSessionManager sharedManager]getUserInfoWithAccessTocken:accessTocken CompletionBlock:^(id response, BOOL isSuccess) {
        if (isSuccess) {
            baiduUserDict = response;
            WFUser * baiduUser = [WFUser yy_modelWithDictionary:response];
            if (completionHandler) {
                completionHandler(baiduUser, nil);
            }
        }
    }];
}

- (void)getRongyunUserWithBaiduUser:(WFUser *)user completionHandler:(WFHostEngineCompletionRongyunUserHandler)completionHandler{
    [[WFNetworkSessionManager sharedManager]getRongYunUserInfoWithParameters:user CompletionBlock:^(id response, BOOL isSuccess) {
        if (isSuccess) {
            if (completionHandler) {
                NSDictionary * value = [response valueForKey:@"entity"];
                completionHandler(response[@"token"], nil);
            }
        }
    }];
}
@end
