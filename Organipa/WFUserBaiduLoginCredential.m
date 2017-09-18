//
//  WFUserBaiduLoginCredential.m
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUserBaiduLoginCredential.h"

static NSString * const baiduloginExpiredTime = @"baiduloginExpiredTime";
static NSString * const baiduLoginAccessTocken = @"baiduLoginAccessTocken";
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

+(BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSString * expiredTime = [coder decodeObjectForKey:baiduloginExpiredTime];
        self.expiredTime = [self dateConverter:expiredTime];
        self.baiduLoginAccessTocken = [coder decodeObjectForKey:baiduLoginAccessTocken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSString * expiredTime;
    [aCoder encodeObject:expiredTime forKey:baiduloginExpiredTime];
    self.expiredTime = [self dateConverter:expiredTime];
    [aCoder encodeObject:self.baiduLoginAccessTocken forKey:baiduLoginAccessTocken];
}

@end
