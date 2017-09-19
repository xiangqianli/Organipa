//
//  WFUserRongyunLoginCredential.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFUserRongyunLoginCredential.h"
#import <Lockbox.h>

static NSString * const rongyunLoginAccessTocken = @"rongyunLoginAccessTocken";
static NSString * const rongyunLoginTockenArchive = @"rongyunLoginArchiveTocken";

@implementation WFUserRongyunLoginCredential

+(BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.rongyunLoginAccessTocken = [coder decodeObjectForKey:rongyunLoginAccessTocken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.rongyunLoginAccessTocken forKey:rongyunLoginAccessTocken];
}

- (void)save{
    [Lockbox archiveObject:self.rongyunLoginAccessTocken forKey:rongyunLoginTockenArchive accessibility:kSecAttrAccessibleWhenUnlocked];
}

- (void)updateWithAccessTocken:(NSString *)accessToken{
    self.rongyunLoginAccessTocken = accessToken;
    [self save];
}

+ (instancetype)sharedCredential{
    static WFUserRongyunLoginCredential * credential = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (credential == nil) {
            credential = [[WFUserRongyunLoginCredential alloc]init];
            credential.rongyunLoginAccessTocken = [Lockbox unarchiveObjectForKey:rongyunLoginTockenArchive];
        }
    });
    return credential;
}

@end
