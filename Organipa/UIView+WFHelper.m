//
//  UIView+WFHelper.m
//  WFByr
//
//  Created by 李向前 on 2017/8/17.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "UIView+WFHelper.h"

@implementation UIView (WFHelper)

- (CGFloat)wf_Width{
    return self.frame.size.width;
}

- (CGFloat)wf_Height{
    return self.frame.size.height;
}

- (CGFloat)wf_topY{
    return self.frame.origin.y;
}

- (CGFloat)wf_bottomY{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)wf_leftX{
    return self.frame.origin.x;
}

- (CGFloat)wf_rightX{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)wf_centerY{
    return self.center.y;
}

- (CGFloat)wf_centerX{
    return self.center.x;
}

@end
