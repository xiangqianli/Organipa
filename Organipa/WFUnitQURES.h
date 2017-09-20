//
//  WFUnitQURES.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFUnitIntentCandidate.h"

@interface WFUnitQURES : NSObject

@property (nonatomic, copy) NSArray<WFUnitIntentCandidate *> * candidates;

@property (nonatomic, copy) NSString * raw_query;

@end
