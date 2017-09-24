//
//  WFCalenderManager.h
//  Organipa
//
//  Created by 李向前 on 2017/9/25.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFUnitSlots.h"

typedef NS_ENUM(NSInteger, WFCalenderRecordType){
    
    WFCalenderRecordTypeTitle,//标题
    
    WFCalenderRecordTypeCateArea,//区域
    
    WFCalenderRecordTypeMealTime,//用餐时间
    
    WFCalenderRecordTypeRestaurant,//餐馆
    
};

@interface WFCalenderManager : NSObject

@property (assign, nonatomic) BOOL isTitleSet;

+ (instancetype)sharedCalenderManager;

- (void)saveDictToCalender;

- (void)cleanDict;

- (void)addObject:(id)obj toKey:(WFCalenderRecordType)recordType;

@end
