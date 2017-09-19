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

@interface WFHostEngine : NSObject
@property (strong, nonatomic) NSOperationQueue * ioqueue;

- (void)getCurrentUserInfoWithAccessTocken:(NSString *)accessTocken CompletionHandler:(WFHostEngineCompletionUserHandler)completionHandler;

@end
