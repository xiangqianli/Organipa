
//
//  WFUnitQURES.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUnitQURES.h"

@implementation WFUnitQURES

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"candidates" : @"intent_candidates"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"candidates" : [WFUnitIntentCandidate class]};
}
@end
