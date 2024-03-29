//
//  UUMessage.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessage.h"
#import "NSDate+Utils.h"
#import "WFMessage.h"
#import "WFUserBaiduLoginCredential.h"
#import "WFUnitManager.h"
#import "WFUnitQURES.h"
#import "WFUnitSlots.h"
#import "WFUnitModelResponse.h"
#import "WFUnitIntentCandidate.h"

@implementation UUMessage
- (void)setWithDict:(NSDictionary *)dict{
    
    self.strIcon = dict[@"strIcon"];
    self.strName = dict[@"strName"];
    self.strId = dict[@"strId"];
    self.strTime = [self changeTheDateString:dict[@"strTime"]];
    self.from = [dict[@"from"] intValue];
    
    switch ([dict[@"type"] integerValue]) {
        
        case 0:
            self.type = UUMessageTypeText;
            self.strContent = dict[@"strContent"];
            break;
        
        case 1:
            self.type = UUMessageTypePicture;
            self.picture = dict[@"picture"];
            break;
        
        case 2:
            self.type = UUMessageTypeVoice;
            self.voice = dict[@"voice"];
            self.strVoiceTime = dict[@"strVoiceTime"];
            break;
        case 3:{
            self.type = UUMessageTypeUnitText;
            self.strContent = dict[@"originStr"];
            self.attributedString = [[NSMutableAttributedString alloc]initWithString:dict[@"originStr"]];
            [[WFUnitManager sharedManager] wf_deserializeJsonString:dict[@"strContent"] completion:^(WFUnitQURES *quers) {
                NSArray<WFUnitIntentCandidate *>* candidates = quers.candidates;
                [candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray<WFUnitSlots *> * slots = candidates[idx].slots;
                    [slots enumerateObjectsUsingBlock:^(WFUnitSlots * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WFUnitSlots * slot = slots[idx];
                        NSRange range = NSMakeRange(slot.offset/2, slot.length/2);
                        if (slot.recordType == WFSlotRecordTypeUnknown) {
                            [self.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeCateArea){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeFoodInfo){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeMealTime){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeMealScale){
                            [self.attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeRestaurant){
                            [self.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleDouble] range:range];
                        }
                    }];
                }];
            }];
        }
        default:
            break;
    }
}

- (void)setWithWFMessage:(WFMessage *)message{
    NSInteger userId;
    if ([message isKindOfClass:[WFMessage class]]) {
        userId = message.from_id;
    RLMResults<WFUser *>* results = [WFUser objectsWhere:@"uid == %d", userId];
    WFUser * sendUser = [results firstObject];
    if (sendUser == nil && message.from == UUMessageFromOther) {
        sendUser = [[WFUser alloc]init];
        sendUser.uname = @"朋友";
        sendUser.portrait = @"chatfrom_doctor_icon";
        self.from = UUMessageFromOther;
    }else if(message.from == UUMessageFromMe){
        sendUser = [[WFUser alloc]init];
        sendUser.uname = @"我";
        sendUser.portrait = @"chatto_doctor_icon";
        self.from = UUMessageFromMe;
    }
    self.strName = sendUser.uname;
    self.strIcon = sendUser.portrait;
    
    self.strTime = [message.create_time dateStringWithShowRuleInHomePage];
    NSInteger type = message.messageType;
    switch (type) {
        case 0:
            self.type = UUMessageTypeText;
            self.strContent = message.content;
            break;
        case 1:
            self.type = UUMessageTypePicture;
            break;
        case 2:
            self.type = UUMessageTypeVoice;
            break;
        case 3:{
            self.type = UUMessageTypeUnitText;
            self.strContent = message.content;
            self.attributedString = [[NSMutableAttributedString alloc]initWithString:message.cleanContent];
            [[WFUnitManager sharedManager] wf_deserializeJsonString:message.content completion:^(WFUnitQURES *quers) {
                NSArray<WFUnitIntentCandidate *>* candidates = quers.candidates;
                [candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray<WFUnitSlots *> * slots = candidates[idx].slots;
                    [slots enumerateObjectsUsingBlock:^(WFUnitSlots * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WFUnitSlots * slot = slots[idx];
                        NSRange range = NSMakeRange(slot.offset/2, slot.length/2);
                        if (slot.recordType == WFSlotRecordTypeUnknown) {
                            [self.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeCateArea){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeFoodInfo){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeMealTime){
                            [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeMealScale){
                            [self.attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeRestaurant){
                            [self.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleDouble] range:range];
                        }
                    }];
                }];
            }];

        }
        default:
            break;
    }
    }
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	NSInteger interval = [zone secondsFromGMTForDate:lastDate];
	lastDate = [lastDate dateByAddingTimeInterval:interval];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"AM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"PM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"Night";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = @"Dawn";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}
@end
