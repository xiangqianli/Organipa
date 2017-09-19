//
//  WFGroupEngine.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFGroupEngine.h"

@implementation WFGroupEngine

- (instancetype)init{
    if (self = [super init]) {
        _ioqueue = [[NSOperationQueue alloc]init];
        _ioqueue.maxConcurrentOperationCount = 2;
    }
    return self;
}

@end
