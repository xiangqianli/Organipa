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
static NSString * const baiduUserId = @"baiduUserId";

static NSString * const baiduLoginTockenArchive = @"baiduLoginArchiveTocken";
static NSString * const baiduLoginTimeArchive = @"baiduLoginArchiveTime";
static NSString * const baiduUserIdArchive = @"baiduUserIdArchive";


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
        self.uid = [[coder decodeObjectForKey:baiduUserId] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.expiredTime forKey:baiduloginExpiredTime];
    [aCoder encodeObject:self.baiduLoginAccessTocken forKey:baiduLoginAccessTocken];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.uid] forKey:baiduUserId];
}

- (void)save{
    [Lockbox archiveObject:self.baiduLoginAccessTocken forKey:baiduLoginTockenArchive accessibility:kSecAttrAccessibleWhenUnlocked];
    [Lockbox archiveObject:self.expiredTime forKey:baiduLoginTimeArchive accessibility:kSecAttrAccessibleWhenUnlocked];
    [Lockbox archiveObject:[NSNumber numberWithInteger:self.uid] forKey:baiduUserIdArchive accessibility:kSecAttrAccessibleWhenUnlocked];
}

- (void)updateWithExpiredTime:(NSDate *)expiredTime accessTocken:(NSString *)accessToken{
    self.expiredTime = expiredTime;
    self.baiduLoginAccessTocken = accessToken;
    [self save];
}

- (void)updateWithUserId:(NSInteger)userId{
    self.uid = userId;
    [self save];
}
+ (instancetype)sharedCredential{
    static WFUserBaiduLoginCredential * credential = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (credential == nil) {
            credential = [[WFUserBaiduLoginCredential alloc]init];
            credential.baiduLoginAccessTocken = [Lockbox unarchiveObjectForKey:baiduLoginTockenArchive];
            credential.expiredTime = [Lockbox unarchiveObjectForKey:baiduLoginTimeArchive];
            credential.uid = [Lockbox unarchiveObjectForKey:baiduUserIdArchive];
        }
    });
    return credential;
}
@end
