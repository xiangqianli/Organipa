//
//  WFChatModel.m
//  Organipa
//
//  Created by 李向前 on 2017/9/11.
//  Copyright © 2017年 李向前. All rights reserved.
//
#import "WFChatModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "WFMessage.h"
#import "NSDate+Utils.h"
#import "WFUnitQURES.h"
#import "WFUnitManager.h"

@implementation WFChatModel

- (void)addOthersItem:(WFMessage *)message{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    
    //这里用到UUMessage只是用于计算是否要隐藏时间条 处理message有Unit格式的情况
    
    UUMessage *umessage = [[UUMessage alloc] init];
    [umessage minuteOffSetStart:previousTime end:[message.create_time string]];
    messageFrame.showTime = umessage.showDateLabel;
    [messageFrame setWFMessage:message];
    messageFrame.umessage = umessage;
    if (message.messageType == UUMessageTypeUnitText) {
        umessage.attributedString = [[NSMutableAttributedString alloc]initWithString:message.cleanContent];
        [[WFUnitManager sharedManager] wf_deserializeJsonString:message.content completion:^(WFUnitQURES *quers) {
            NSArray<WFUnitIntentCandidate *>* candidates = quers.candidates;
            [candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WFUnitSlots * slot = candidates[idx];
                NSRange range = NSMakeRange(slot.offset/2, slot.length/2);
                if (slot.recordType == WFSlotRecordTypeUnknown) {
                    [umessage.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                }else if (slot.recordType == WFSlotRecordTypeCateArea){
                    [umessage.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                }else if(slot.recordType == WFSlotRecordTypeFoodInfo){
                    [umessage.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                }else if(slot.recordType == WFSlotRecordTypeMealTime){
                    [umessage.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
                }else if (slot.recordType == WFSlotRecordTypeMealScale){
                    [umessage.attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
                }else if (slot.recordType == WFSlotRecordTypeRestaurant){
                    [umessage.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleDouble] range:range];
                }
            }];
        }];
    }
    if (umessage.showDateLabel) {
        previousTime = [message.create_time string];
    }
    [self.dataSource addObject:messageFrame];
}

// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"chatto_doctor_icon";
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"我" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    
    WFMessage * fmessage = [[WFMessage alloc]init];
    fmessage.from = UUMessageFromMe;
    fmessage.create_time = [NSDate date];
    fmessage.fromStr = @"我";
    fmessage.messageType = message.type;
    switch (fmessage.messageType) {
        case UUMessageTypeText:{
            fmessage.content = message.strContent;
            break;
        }
        case UUMessageTypeUnitText:{
            fmessage.content = dic[@"strContent"];
            fmessage.cleanContent = dic[@"originStr"];
            break;
        }
        default:
            break;
    }
    
    [message minuteOffSetStart:previousTime end:[fmessage.create_time string]];
    
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setWFMessage:fmessage];
    messageFrame.umessage = message;
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    
    [self.dataSource addObject:messageFrame];
}


static NSString *previousTime = nil;

#pragma mark --
- (void)fetchInitialDataSourceWithGroupId:(NSString *)gid{
    self.dataSource = [NSMutableArray array];
    RLMResults<WFMessage *> *messages = [[WFMessage objectsWhere:[NSString stringWithFormat:@"gid = '%@'", gid]] sortedResultsUsingKeyPath:@"create_time_interval" ascending:YES];
   
    //目前还没有messageId
    for (WFMessage * mmessage in messages) {
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithWFMessage:mmessage];
        [message minuteOffSetStart:previousTime end:[mmessage.create_time string]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setWFMessage:mmessage];
        
        if (mmessage.messageType == UUMessageTypeUnitText) {
            message.attributedString = [[NSMutableAttributedString alloc]initWithString:mmessage.cleanContent];
            [[WFUnitManager sharedManager] wf_deserializeJsonString:mmessage.content completion:^(WFUnitQURES *quers) {
                NSArray<WFUnitIntentCandidate *>* candidates = quers.candidates;
                [candidates enumerateObjectsUsingBlock:^(WFUnitIntentCandidate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WFUnitIntentCandidate * candi = candidates[idx];
                    [candi.slots enumerateObjectsUsingBlock:^(WFUnitSlots * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WFUnitSlots * slot = candi.slots[idx];
                        NSRange range = NSMakeRange(slot.offset/2, slot.length/2);
                        if (slot.recordType == WFSlotRecordTypeUnknown) {
                            [message.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeCateArea){
                            [message.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeFoodInfo){
                            [message.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                        }else if(slot.recordType == WFSlotRecordTypeMealTime){
                            [message.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeMealScale){
                            [message.attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
                        }else if (slot.recordType == WFSlotRecordTypeRestaurant){
                            [message.attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleDouble] range:range];
                        }
                    }];
                    
                }];
            }];
            [messageFrame setUmessage:message];
        }
        
        if (message.showDateLabel) {
            previousTime = [mmessage.create_time string];
        }

        [self.dataSource addObject:messageFrame];
    }
}
@end
