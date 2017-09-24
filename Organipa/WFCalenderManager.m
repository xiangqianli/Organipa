//
//  WFCalenderManager.m
//  Organipa
//
//  Created by 李向前 on 2017/9/25.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFCalenderManager.h"
#import <EventKit/EventKit.h>

#define kCalenderKeywordsCount 3//标题 区域 时间 餐馆
#define indexToString(i) [NSString stringWithFormat:@"%lu",(unsigned long)i]

@interface WFCalenderManager()

@property (strong, nonatomic) NSMutableDictionary * calenderDict;

@end

@implementation WFCalenderManager

+ (instancetype)sharedCalenderManager{
    static WFCalenderManager * calenderManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (calenderManager == nil) {
            calenderManager = [[WFCalenderManager alloc]init];
        }
    });
    return calenderManager;
}

- (instancetype)init{
    if (self = [super init]) {
        _calenderDict = [[NSMutableDictionary alloc]initWithCapacity:kCalenderKeywordsCount+1];
//        for (int i = 0; i < kCalenderKeywordsCount+1; i++) {
//            NSMutableArray * priorities = [[NSMutableArray alloc]initWithCapacity:4];
//            [_calenderDict setObject:priorities forKey:[NSString stringWithFormat:@"%d",i]];
//        }
    }
    return self;
}

- (void)saveDictToCalender{
    NSString * title = [_calenderDict objectForKey:indexToString(WFCalenderRecordTypeTitle)];
    NSString * location = [_calenderDict objectForKey:indexToString(WFCalenderRecordTypeCateArea)];
    NSDate * startDate = [_calenderDict objectForKey:indexToString(WFCalenderRecordTypeMealTime)];
    NSDate * endDate = [startDate dateByAddingTimeInterval:7200];//默认两小时
    BOOL allDay = false;
    if (self.isTitleSet == YES) {
        [self createEventCalendarTitle:title location:location startDate:startDate endDate:endDate allDay:allDay alarmArray:nil];
        self.isTitleSet = NO;
    }
}

- (void)cleanDict{
    for (int i = 0 ; i < kCalenderKeywordsCount+1; i++) {
        [_calenderDict removeObjectForKey:indexToString(i)];
    }
}

- (void)addObject:(id)obj toKey:(WFCalenderRecordType)recordType{
    if ([obj isKindOfClass:[NSString class]]) {
        [self addWord:obj toKey:recordType];
    }else if ([obj isKindOfClass:[NSDate class]]){
        [self addDate:obj toKey:recordType];
    }
    if (recordType == WFCalenderRecordTypeTitle) {
        self.isTitleSet = YES;
    }
}

- (void)addWord:(NSString *)word toKey:(WFCalenderRecordType)recordType{
    [_calenderDict setObject:word forKey:indexToString(recordType)];
}

- (void)addDate:(NSDate *)date toKey:(WFCalenderRecordType)recordTyep{
    [_calenderDict setObject:date forKey:indexToString(recordTyep)];
}

#pragma mark --private method
- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    __weak typeof(self) weakSelf = self;
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    [strongSelf showAlert:@"添加失败，请稍后重试"];
                    
                }else if (!granted){
                    [strongSelf showAlert:@"不允许使用日历,请在设置中允许此App使用日历"];
                    
                }else{
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [strongSelf showAlert:@"已添加到系统日历中"];
                    
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
