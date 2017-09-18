//
//  WFUserBaiduLoginCredential.m
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUserBaiduLoginCredential.h"
#import <Lockbox.h>

static NSString * const baiduloginExpiredTime = @"baiduloginExpiredTime";
static NSString * const baiduLoginAccessTocken = @"baiduLoginAccessTocken";
static NSString * const baiduLoginArchive = @"baiduLoginArchive";
@implementation WFUserBaiduLoginCredential


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
        self.expiredTime = [coder decodeObjectForKey:baiduloginExpiredTime];
        self.baiduLoginAccessTocken = [coder decodeObjectForKey:baiduLoginAccessTocken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.expiredTime forKey:baiduloginExpiredTime];
    [aCoder encodeObject:self.baiduLoginAccessTocken forKey:baiduLoginAccessTocken];
}

- (void)save{
    [Lockbox archiveObject:self forKey:baiduLoginArchive accessibility:kSecAttrAccessibleWhenUnlocked];
}

- (void)updateWithExpiredTime:(NSString *)expiredTime accessTocken:(NSString *)accessToken{
    self.expiredTime = expiredTime;
    self.baiduLoginAccessTocken = accessToken;
    [self save];
}
@end
