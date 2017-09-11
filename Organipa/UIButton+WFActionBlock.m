//
//  UIButton+WFActionBlock.m
//  WFByr
//
//  Created by Andy on 2017/8/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "UIButton+WFActionBlock.h"
#import <objc/runtime.h>

@implementation UIButton (WFActionBlock)

- (void)addActionBlock:(ASActionBlock)blk{
    [self.actionBlks addObject:blk];
    [self addTarget:self action:@selector(performBlk) forControlEvents:UIControlEventTouchUpInside];
}

- (void)performBlk {
    [self.actionBlks enumerateObjectsUsingBlock:^(ASActionBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
    }];
}

- (NSMutableArray<ASActionBlock>*)actionBlks {
    id actionBlks =objc_getAssociatedObject(self, @selector(actionBlks));
    if (!actionBlks) {
        actionBlks = [NSMutableArray arrayWithCapacity:2];
        objc_setAssociatedObject(self, @selector(actionBlks), actionBlks, OBJC_ASSOCIATION_RETAIN);
    }
    return actionBlks;
}
@end
