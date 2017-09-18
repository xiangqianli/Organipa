//
//  WFUserBaiduLoginCredential.m
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUserBaiduLoginCredential.h"

@implementation WFUserBaiduLoginCredential

- (void)setExpiredTimeWithString:(NSString *)expiredTime{
    self.expiredTime = [self dateConverter:expiredTime];
}

- (NSTimeInterval) dateConverter:(NSString *)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    NSLog(@"dateFromString = %@", date);
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

@end
