//
//  WFUserRongyunLoginCredential.h
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFUserRongyunLoginCredential : NSObject<NSSecureCoding>

@property (copy, nonatomic) NSString * rongyunLoginAccessTocken;

- (void)save;

- (void)updateWithAccessTocken:(NSString *)accessToken;

+ (instancetype)sharedCredential;

@end
