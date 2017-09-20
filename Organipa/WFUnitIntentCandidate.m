//
//  WFUnitIntentCandidate.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUnitIntentCandidate.h"

@implementation WFUnitIntentCandidate

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"intentStr" : @"intent"};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"slots" : [WFUnitSlots class]};
}
@end
