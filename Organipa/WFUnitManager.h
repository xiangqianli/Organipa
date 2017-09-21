//
//  WFUnitManager.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFUnitModelResponse, WFUnitQURES;

@interface WFUnitManager : NSObject

+ (instancetype)sharedManager;

- (void)askUnit:(NSString *)word completion:(void(^)(NSString * result))completionHandler;

- (void)wf_deserializeJsonString:(NSString *)word completion:(void(^)(WFUnitQURES * quers))completionHandler;
@end
