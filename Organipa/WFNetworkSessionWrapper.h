//
//  WFNetworkSessionWrapper.h
//  Organipa
//
//  Created by 李向前 on 2017/9/6.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  WFNetworkSessionWrapper;

typedef void(^WFNetworkSessionSuccessBlock)(WFNetworkSessionWrapper * wrapper, id responseObject);
typedef void(^WFNetworkSessionFailureBlock)(WFNetworkSessionWrapper * wrapper, id responseObject);
@interface WFNetworkSessionWrapper : NSObject

@property (nonatomic, copy) WFNetworkSessionSuccessBlock successBlock;
@property (nonatomic, copy) WFNetworkSessionFailureBlock failureBlock;
@property (nonatomic, copy) NSString * safebindSuccessIdentifier;

@end
