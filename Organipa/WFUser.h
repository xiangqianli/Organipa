//
//  WFUser.h
//  Organipa
//
//  Created by 李向前 on 2017/9/18.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFUser : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * uname;
@property (nonatomic, copy) NSString * portrait;

@end
