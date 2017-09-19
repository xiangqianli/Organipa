//
//  AIPUnitSDK.h
//  AIPUnitSDK
//
//  Created by 阿凡树 on 2017/7/27.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIPUnitSDK : NSObject

@property (nonatomic, readwrite, retain) NSString *accessToken;

+ (instancetype)sharedInstance;

- (void)setSceneID:(NSInteger)sceneID;

- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk completion:(void (^)())completionBlock;

- (void)askWord:(NSString *)word completion:(void (^)(NSError *error, id resultObject))completionBlock;

@end
