//
//  WFHostEngine.h
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFUser;
typedef void(^WFHostEngineCompletionUserHandler)(WFUser * user, NSError * error);
typedef void(^WFHostEngineCompletionRongyunUserHandler)(NSString * userToken, NSError * error);

@protocol WFHostEngineProtocal

- (WFUser *)user;

@end

@interface WFHostEngine : NSObject

//百度账户的获取
- (void)getCurrentUserInfoWithAccessTocken:(NSString *)accessTocken CompletionHandler:(WFHostEngineCompletionUserHandler)completionHandler;

//根据百度id获取融云token
- (void)getRongyunUserWithBaiduUser:(WFUser *)user completionHandler:(WFHostEngineCompletionRongyunUserHandler)completionHandler;

@end
