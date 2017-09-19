//
//  WFGroup.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFGroup.h"

@implementation WFGroup

+ (Class)managedObjectClass {
    return NSClassFromString(@"CoreSnack");
}

//主键 (key是Model属性名, value是CoreData字段名, 一般情况下是一样的, 声明成字典只是以防万一)
+ (NSDictionary *)primaryKeys {
    return @{@"gid" : @"gid"};
}

@end
