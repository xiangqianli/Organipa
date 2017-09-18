//
//  WFUserCredential.m
//  WFShipper
//
//  Created by 李向前 on 2017/7/25.
//  Copyright © 2017年 lixiangqian. All rights reserved.
//

#import "WFUserCredential.h"
#import <Lockbox.h>

static NSString * const baiduLoginKey = @"baiduLoginKey";

@implementation WFUserCredential

+ (instancetype)sharedCredential{
    static WFUserCredential * credential = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (credential == nil) {
            credential = [[WFUserCredential alloc]init];
        }
    });
    return credential;
}

- (void)saveAccessToken:(NSString *)accessToken expiredTime:(NSString *)timeStr{
    self.baiduLoginAccessTocken = accessToken;
    self.expiredTime = timeStr;
    [Lockbox archiveObject:self forKey:<#(NSString *)#> accessibility:<#(CFTypeRef)#>:accessToken forKey:baiduLoginAccessTokenKey];
    
    NSTimeInterval rightTime = [self dateConverter:timeStr];
    [Lockbox set];
}


@end
