//
//  WFMessage.h
//  Organipa
//
//  Created by 李向前 on 2017/9/20.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFMessage : RLMObject

@property (nonatomic, strong) NSData * create_time;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) NSInteger from_id;
@property (nonatomic, assign) NSInteger gid;

@end
