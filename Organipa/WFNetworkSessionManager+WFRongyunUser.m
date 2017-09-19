//
//  WFNetworkSessionManager+WFRongyunUser.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFNetworkSessionManager+WFRongyunUser.h"
#import "WFUser.h"
@implementation WFNetworkSessionManager (WFRongyunUser)

- (void)getRongYunUserInfoWithParameters:(WFUser *)user CompletionBlock:(WFCompletionCallback)completionBlock{
    NSString * url = [NSString stringWithFormat:@"%@%@", self.WFNetworkBaseUrl, @"user/register"];
    WFNetworkMethodType type = WFNetworkMethodTypePost;
    NSDictionary * newparameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",user.uid],@"user_id",user.uname,@"name",user.portrait,@"portraitUri",nil];
    [self sendRequestWithUrl:url method:type parameters:newparameters success:^(NSInteger statusCode, id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, YES);
        }
    } failure:^(NSInteger statusCode, id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, NO);
        }
    }];
}

- (NSString *)WFNetworkBaseUrl{
    return @"http://organipa.andysheng.cn/";
}
@end
