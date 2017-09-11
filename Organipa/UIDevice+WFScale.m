//
//  UIDevice+WFScale.m
//  WFByr
//
//  Created by 李向前 on 2017/8/17.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "UIDevice+WFScale.h"

typedef  NS_ENUM( NSInteger, WFDeviceType){
    WFDeviceTypeUnknown,
    WFDeviceType3GSClassic,
    WFDeviceType4Retina,
    WFDeviceType5,
    WFDeviceType6,
    WFDeviceType6Plus,
    WFDeviceTypeIPadClassic,
    WFDeviceTypeIPadRetina,
    WFDeviceTypeIPadPro
};

@implementation UIDevice (WFScale)

- (CGFloat)WFScaleHeight{
    CGFloat scaleHeight = 1.0;
    if ([self wf_isIPadScale]) {
        scaleHeight = 1.2;
    } else if([self wf_isIphone6SPlusScale]){
        scaleHeight = 1.06;
    } else if([self wf_isIphoneMiniScale]){
        scaleHeight = 0.92;
    }
    return scaleHeight;
}

- (WFDeviceType)wf_deviceType{
    static WFDeviceType deviceType = WFDeviceTypeUnknown;
    NSUInteger height = MAX(WFSCREEN_W, WFSCREEN_H);
    NSUInteger width = MIN(WFSCREEN_H, WFSCREEN_W);
    NSUInteger scale = [[UIScreen mainScreen] scale];
    if (deviceType == WFDeviceTypeUnknown) {
        if (height == 480 && width == 320) {
            deviceType = scale == 1? WFDeviceType3GSClassic : WFDeviceType4Retina;
        }else if(height == 568 && width == 320) {
            deviceType = WFDeviceType5;
        }else if(height == 667 && width == 375) {
            deviceType = WFDeviceType6;
        }else if(height == 736 && width == 414) {
            deviceType = WFDeviceType6Plus;
        }else if(height == 1024 && width == 768) {
            deviceType = scale == 1? WFDeviceTypeIPadClassic : WFDeviceTypeIPadRetina;
        }else if(height == 1112 && width == 834) {
            deviceType = WFDeviceTypeIPadPro;
        }else if(height == 1366 && width == 1024) {
            deviceType = WFDeviceTypeIPadPro;
        }
    }
    return deviceType;
}

- (BOOL)wf_isIPadScale{
    return [self wf_deviceType] == WFDeviceTypeIPadPro || [self wf_deviceType] == WFDeviceTypeIPadRetina || [self wf_deviceType] == WFDeviceTypeIPadClassic;
}

- (BOOL)wf_isIPadClassicScale{
    return [self wf_deviceType] == WFDeviceTypeIPadClassic;
}

- (BOOL)wf_isIPadRetinaScale{
    return [self wf_deviceType] == WFDeviceTypeIPadRetina;
}

- (BOOL)wf_isIPadProScale {
    return [self wf_deviceType] == WFDeviceTypeIPadPro;
}

- (BOOL)wf_isIphone6Scale{
    return [self wf_deviceType] == WFDeviceType6;
}

- (BOOL)wf_isIphone6SPlusScale{
    return [self wf_deviceType] == WFDeviceType6Plus;
}

- (BOOL)wf_isIphoneMiniScale{
    return [self wf_deviceType] == WFDeviceType5 || [self wf_deviceType] == WFDeviceType4Retina || [self wf_deviceType]== WFDeviceType5;
}

@end
