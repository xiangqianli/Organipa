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
        sessionManager = [[WFNetworkSessionManager alloc]initWithBaseURL:[NSURL URLWithString:WFNetworkBaseUrl]];
    });
    return sessionManager;
}

@end
