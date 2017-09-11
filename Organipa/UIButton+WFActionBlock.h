//
//  UIButton+WFActionBlock.h
//  WFByr
//
//  Created by Andy on 2017/8/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ASActionBlock)();
@interface UIButton (WFActionBlock)

@property (nonatomic, strong, readonly) NSMutableArray<ASActionBlock>* actionBlks;

- (void)addActionBlock:(void (^)())blk;

@end
