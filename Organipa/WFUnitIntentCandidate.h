//
//  WFUnitIntentCandidate.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFUnitSlots.h"

typedef NS_ENUM(NSInteger, WFIntent){
    WFIntentUserCate,
    WFIntentUserNavigation,
    WFIntentUserReservation
};

@interface WFUnitIntentCandidate : NSObject

@property (nonatomic, assign) WFIntent intent;
@property (nonatomic, copy) NSString * intentStr;
@property (nonatomic, strong) NSMutableArray<WFUnitSlots *> * slots;

@end
