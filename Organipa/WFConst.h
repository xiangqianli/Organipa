//
//  WFConst.h
//  WFByr
//
//  Created by Andy on 2017/5/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#ifndef WFConst_h
#define WFConst_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

static NSString * const WFFontName = @"AvenirNext-Regular";

static NSString * const WFMeFontBoldName = @"PingFangSC-Bold";
static NSString * const WFMeFontRegularName = @"PingFangSC-Regular";

#define MAIN_BLUE [UIColor colorWithRed:0.00 green:0.63 blue:0.95 alpha:1.00]
#define MAIN_GRAY [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]
#define FACE_BORDER_COLOR [UIColor colorWithRed:0.827 green:0.827 blue:0.827 alpha:1.00]
#define WFMAIN_BACKGROUND_COLOR [UIColor colorWithHexString:@"0xf2f2f2"]
#define WFMAIN_GRAY_33 [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.00]
#define WFMAIN_CELL_BORDER_GRAY [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]
#define WFSCREEN_W [UIScreen mainScreen].bounds.size.width
#define WFSCREEN_H [UIScreen mainScreen].bounds.size.height

#define WFHeightScale [[UIDevice currentDevice] WFScaleHeight]
#define WFOnePixelHeight 1/[[UIScreen mainScreen] scale]

#define WFAvatarMeFirstLevelSize 29

#endif /* WFConst_h */
