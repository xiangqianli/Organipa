//
//  WFUnitSlots.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WFSlotType){
    
    WFSlotTypeUnknown,
    
    WFSlotTypeCateArea,//区域
    
    WFSlotTypeEnviroment,//环境
    
    WFSlotTypeFoodInfo,//食物信息
    
    WFSlotTypeGroupBuy,//是否有团购
    
    WFSlotTypeMealScale,//人数
    
    WFSlotTypeMealTime,//用餐时间
    
    WFSlotTypeOpenHours,//开放时间
    
    WFSlotTypeParking,//停车条件
    
    WFSlotTypePrice,//价格
    
    WFSlotTypeRestaurant,//餐馆
    
    WFSlotTypeSortBy,//筛选条件
    
    WFSlotTypeTaste,//味道
    
    WFSlotTypeWIFI//是否有Wifi
};

typedef NS_ENUM(NSInteger, WFSlotRecordType){
    
    WFSlotRecordTypeUnknown,
    
    WFSlotRecordTypeCateArea,//区域
    
    WFSlotRecordTypeFoodInfo,//食物信息
    
    WFSlotRecordTypeMealScale,//人数
    
    WFSlotRecordTypeMealTime,//用餐时间
    
    WFSlotRecordTypeRestaurant,//餐馆
    
};

@interface WFUnitSlots : NSObject
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, copy) NSString * normalized_word;
@property (nonatomic, copy) NSString * original_word;
@property (nonatomic, copy) NSString * typestr;
@property (nonatomic, copy) NSString * recordtypestr;
@property (nonatomic, assign) WFSlotType type;
@property (nonatomic, assign) WFSlotRecordType recordType;
@end
