//
//  WFUserCredential.h
//  WFShipper
//
//  Created by 李向前 on 2017/7/25.
//  Copyright © 2017年 lixiangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFUserBaiduLoginCredential;
@interface WFUserCredential : NSObject

@property(strong, nonatomic) WFUserBaiduLoginCredential * baiduLoginAccount;

+ (instancetype)sharedCredential;

- (void)saveAccessToken:(NSString *)accessToken expiredTime:(NSString *)timeStr;

@end
