//
//  WFChatModel.h
//  Organipa
//
//  Created by 李向前 on 2017/9/11.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFMessage.h"

@interface WFChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

@property (nonatomic, strong) NSMutableDictionary * unitStringMappingDictionary;

//- (void)populateRandomDataSource;
//
//- (void)addRandomItemsToDataSource:(NSInteger)number;

- (void)addSpecifiedItem:(NSDictionary *)dic;

- (void)fetchInitialDataSourceWithGroupId:(NSString *)gid;

- (void)addOthersItem:(WFMessage *)message;

@end
