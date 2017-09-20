//
//  WFUnitManager.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUnitManager.h"
#import "AIPUnitSDK.h"
#import "SVProgressHUD.h"

static NSString * const API_KEY = @"GaUpbfXH0nelhEAwnGFXG9Cq";
static NSString * const SECRET_KEY = @"5KuCQX4p9rYZfmR8EyFMpHRj96F7GYBt";

@implementation WFUnitManager

+ (instancetype)sharedManager{
    static WFUnitManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WFUnitManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        [[AIPUnitSDK sharedInstance] getAccessTokenWithAK:API_KEY SK:SECRET_KEY completion:^{
            [SVProgressHUD dismiss];
        }];
    }
    return self;
}
@end
