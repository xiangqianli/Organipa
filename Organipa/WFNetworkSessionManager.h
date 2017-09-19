//
//  WFNetworkSessionManager.h
//  Organipa
//
//  Created by 李向前 on 2017/9/6.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "WFNetworkSessionWrapper.h"
#import "WFSettings.h"

extern NSString * const WFNetworkBaseUrl;

typedef void(^WFNetworkSuccessBlock)(NSInteger statusCode, id responseObject);
typedef void(^WFNetworkFailureBlock)(NSInteger statusCode, id responseObject);

typedef NS_ENUM(NSInteger, WFNetworkMethodType){
    WFNetworkMethodTypeGet,
    WFNetworkMethodTypePost
};

@interface WFNetworkSessionManager : AFHTTPSessionManager

@property(nonatomic, strong) NSMutableDictionary<NSString *, WFNetworkSessionWrapper*> * wrapperDictionary;

+ (WFNetworkSessionManager *)sharedManager;

- (void)sendRequestWithUrl:(NSString *)urlStr
                    method:(WFNetworkMethodType)method
                parameters:(id) parameters
                   success:(WFNetworkSuccessBlock)successCallback
                   failure:(WFNetworkSuccessBlock)failureCallback;

@end
