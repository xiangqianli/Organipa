//
//  WFNetworkSessionManager+WFBaiduUser.h
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFNetworkSessionManager.h"


@interface WFNetworkSessionManager (WFBaiduUser)

- (void)getUserInfoWithAccessTocken:(NSString *)accessTocken CompletionBlock:(WFCompletionCallback)completionBlock;

@end
