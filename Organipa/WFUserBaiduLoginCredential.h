//
//  WFUserBaiduLoginCredential.h
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFUserBaiduLoginCredential : NSObject<NSSecureCoding>

@property (copy, nonatomic) NSString * baiduLoginAccessTocken;

@property (assign, nonatomic) NSTimeInterval expiredTime;

- (void)setExpiredTimeWithString:(NSString *)expiredTime;

@end
