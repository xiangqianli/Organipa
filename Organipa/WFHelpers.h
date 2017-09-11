//
//  WFHelpers.h
//  WFByr
//
//  Created by Andy on 2017/5/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#ifndef WFHelpers_h
#define WFHelpers_h

@class WFToken;

extern BOOL wf_checkToken(WFToken *aToken);

extern BOOL wf_checkByrReachable();

extern NSString *wf_formatDateWithNowAndPast(NSDate *now, NSDate *past);

extern NSURL *wf_saveImage(UIImage *image, NSString *name);

extern void wf_showHud(UIView *toView, NSString *text, CGFloat duration);

#endif /* WFHelpers_h */
