//
//  WFNetworkSessionManager+WFRongyunUser.h
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFNetworkSessionManager.h"
@class WFUser;
@interface WFNetworkSessionManager (WFRongyunUser)

- (void)getRongYunUserInfoWithParameters:(WFUser *)user CompletionBlock:(WFCompletionCallback)completionBlock;
@end
