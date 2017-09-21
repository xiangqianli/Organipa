//
//  WFSlotString.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFSlotString : NSObject

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) NSString * originStr;
@end
