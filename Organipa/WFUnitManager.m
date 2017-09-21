//
//  WFUnitManager.m
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUnitManager.h"
#import "AIPUnitSDK.h"

#import "WFUnitModelResponse.h"
#import "WFUnitQURES.h"
#import "WFUnitIntentCandidate.h"
#import "WFUnitSlots.h"
#import <YYModel.h>

static NSString * const API_KEY = @"GaUpbfXH0nelhEAwnGFXG9Cq";
static NSString * const SECRET_KEY = @"5KuCQX4p9rYZfmR8EyFMpHRj96F7GYBt";

@implementation WFUnitManager

+ (instancetype)sharedManager{
    static WFUnitManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WFUnitManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)askUnit:(NSString *)word completion:(void(^)(NSString * result))completionHandler{
    __block NSString * result = [NSString stringWithString:word];
    [self askUnitForJsonObject:word completion:^(WFUnitQURES *quers, NSString * result) {
        if (quers != nil) {
            result =  [self wf_serializeObject:quers];
        }
        if (completionHandler) {
            completionHandler(result);
        }
    }];
}

- (void)askUnitForJsonObject:(NSString *)word completion:(void(^)(WFUnitQURES * quers, NSString * result))completionHandler{
   
    __block WFUnitModelResponse * response = [[WFUnitModelResponse alloc]init];
    [[AIPUnitSDK sharedInstance] askWord:word completion:^(NSError *error, NSDictionary* resultDict) {
        if ([resultDict objectForKey:@"qu_res"] != nil) {
            response.success = YES;
            response.qures = [WFUnitQURES yy_modelWithDictionary:resultDict[@"qu_res"]];
            [response.qures.candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WFUnitIntentCandidate * candi = response.qures.candidates[idx];
                NSString * intentStr = candi.intentStr;
                if ([intentStr isEqualToString:@"USER_CATE"]) {
                    response.qures.candidates[idx].intent = WFIntentUserCate;
                }else if ([intentStr isEqualToString:@"USER_CATE_RESERVE"]){
                    response.qures.candidates[idx].intent = WFIntentUserReservation;
                }else{
                    response.qures.candidates[idx].intent = WFIntentUserNavigation;
                }
                NSUInteger ydx = idx;
                [candi.slots enumerateObjectsUsingBlock:^(WFUnitSlots * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.typestr isEqualToString:@"user_meal_time"]) {
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeMealTime;
                        response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeMealTime;
                        response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
                    }else if([obj.typestr isEqualToString:@"user_cate_area"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeCateArea;
                        response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeCateArea;
                        response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
                    }else if([obj.typestr isEqualToString:@"user_food_info"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeFoodInfo;
                        response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeFoodInfo;
                        response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
                    }else if([obj.typestr isEqualToString:@"user_meal_scale"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeMealScale;
                        response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeMealScale;
                        response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
                    }else if([obj.typestr isEqualToString:@"user_restaurant"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeRestaurant;
                        response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeRestaurant;
                        response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
                    }else if([obj.typestr isEqualToString:@"user_taste"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeTaste;
                    }else if([obj.typestr isEqualToString:@"user_price"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypePrice;
                    }else if([obj.typestr isEqualToString:@"user_parking"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeParking;
                    }else if([obj.typestr isEqualToString:@"user_open_hours"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeOpenHours;
                    }else if([obj.typestr isEqualToString:@"user_environment"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeEnviroment;
                    }else if([obj.typestr isEqualToString:@"user_group_buy"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeGroupBuy;
                    }else if([obj.typestr isEqualToString:@"user_wifi"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeWIFI;
                    }else if([obj.typestr isEqualToString:@"user_sortby_cate"]){
                        response.qures.candidates[ydx].slots[idx].type = WFSlotTypeSortBy;
                    }
                }];
                
            }];
            if (response.qures.candidates == nil || response.qures.candidates.count == 0) {
                completionHandler(nil, word);
            }
            if (response.qures != nil) {
                completionHandler(response.qures, nil);
            }
        }
    }];
    
}

- (NSString *)wf_serializeObject:(id)Object{
    return [Object yy_modelToJSONString];
}

- (void)wf_deserializeJsonString:(NSString *)word completion:(void (^)(WFUnitQURES *))completionHandler{
    WFUnitModelResponse * response = [[WFUnitModelResponse alloc]init];
    response.success = YES;
    response.qures = [WFUnitQURES yy_modelWithJSON:word];
    [response.qures.candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WFUnitIntentCandidate * candi = response.qures.candidates[idx];
        NSString * intentStr = candi.intentStr;
        if ([intentStr isEqualToString:@"USER_CATE"]) {
            response.qures.candidates[idx].intent = WFIntentUserCate;
        }else if ([intentStr isEqualToString:@"USER_CATE_RESERVE"]){
            response.qures.candidates[idx].intent = WFIntentUserReservation;
        }else{
            response.qures.candidates[idx].intent = WFIntentUserNavigation;
        }
        NSUInteger ydx = idx;
        [candi.slots enumerateObjectsUsingBlock:^(WFUnitSlots * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.typestr isEqualToString:@"user_meal_time"]) {
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeMealTime;
                response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeMealTime;
                response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
            }else if([obj.typestr isEqualToString:@"user_cate_area"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeCateArea;
                response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeCateArea;
                response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
            }else if([obj.typestr isEqualToString:@"user_food_info"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeFoodInfo;
                response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeFoodInfo;
                response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
            }else if([obj.typestr isEqualToString:@"user_meal_scale"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeMealScale;
                response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeMealScale;
                response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
            }else if([obj.typestr isEqualToString:@"user_restaurant"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeRestaurant;
                response.qures.candidates[ydx].slots[idx].recordType = WFSlotRecordTypeRestaurant;
                response.qures.candidates[ydx].slots[idx].recordtypestr = obj.typestr;
            }else if([obj.typestr isEqualToString:@"user_taste"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeTaste;
            }else if([obj.typestr isEqualToString:@"user_price"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypePrice;
            }else if([obj.typestr isEqualToString:@"user_parking"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeParking;
            }else if([obj.typestr isEqualToString:@"user_open_hours"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeOpenHours;
            }else if([obj.typestr isEqualToString:@"user_environment"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeEnviroment;
            }else if([obj.typestr isEqualToString:@"user_group_buy"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeGroupBuy;
            }else if([obj.typestr isEqualToString:@"user_wifi"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeWIFI;
            }else if([obj.typestr isEqualToString:@"user_sortby_cate"]){
                response.qures.candidates[ydx].slots[idx].type = WFSlotTypeSortBy;
            }
        }];
    }];
    if (completionHandler) {
        completionHandler(response.qures);
    }
}
@end
