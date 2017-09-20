//
//  WFUnitModelResponse.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFUnitQURES.h"

@interface WFUnitModelResponse : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) WFUnitQURES * qures;

@end
