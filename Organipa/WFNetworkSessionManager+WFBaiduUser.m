//
//  WFNetworkSessionManager+WFBaiduUser.m
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFNetworkSessionManager+WFBaiduUser.h"
#import "WFUserBaiduLoginCredential.h"

@implementation WFNetworkSessionManager( WFBaiduUser )

- (void)getUserInfoWithAccessTocken:(NSString *)accessTocken CompletionBlock:(WFCompletionCallback)completionBlock{
    NSString * url = [NSString stringWithFormat:@"%@%@", self.WFBaiduNetworkBaseUrl, @"passport/users/getLoggedInUser"];
    WFNetworkMethodType type = WFNetworkMethodTypePost;
    NSDictionary * parameters = @{@"access_token":accessTocken};
    [self sendRequestWithUrl:url method:type parameters:parameters success:^(NSInteger statusCode, id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, YES);
        }
    } failure:^(NSInteger statusCode, id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, NO);
        }
    }];
}

- (NSString *)WFBaiduNetworkBaseUrl{
    return @"https://openapi.baidu.com/rest/2.0/";
}

@end
