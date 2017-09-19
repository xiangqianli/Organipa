//
//  WFNetworkSessionManager.m
//  Organipa
//
//  Created by 李向前 on 2017/9/6.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFNetworkSessionManager.h"

@implementation WFNetworkSessionManager

+ (WFNetworkSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    static WFNetworkSessionManager * sessionManager;
    dispatch_once(&onceToken, ^{
        sessionManager = [[WFNetworkSessionManager alloc]init];
    });
    return sessionManager;
}

- (void)sendRequestWithUrl:(NSString *)urlStr method:(WFNetworkMethodType)method parameters:(id)parameters success:(WFNetworkSuccessBlock)successCallback failure:(WFNetworkSuccessBlock)failureCallback{
    NSMutableDictionary *params = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters] : [NSMutableDictionary dictionary];
    WFNetworkSessionManager * manager = [WFNetworkSessionManager sharedManager];
    switch (method) {
        case WFNetworkMethodTypeGet:{
            [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (successCallback) {
                        successCallback(response.statusCode, responseObject);
                    }
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSDictionary *json  = nil;
                if ([error.userInfo valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions  error:nil];
                }
                
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failureCallback) {
                        failureCallback(response.statusCode, json);
                    }
                });
            }];
            break;
        }
        case WFNetworkMethodTypePost:{
            [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (successCallback) {
                        successCallback(response.statusCode, responseObject);
                    }
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSDictionary *json  = nil;
                if ([error.userInfo valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions  error:nil];
                }
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failureCallback) {
                        failureCallback(response.statusCode, json);
                    }
                });
            }];
            break;
        }
        default:
            break;
    }
}


@end
