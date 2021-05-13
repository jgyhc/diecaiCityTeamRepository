//
//  UIScreen+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_MAIN_SCREEN
#define NT_MAIN_SCREEN [UIScreen mainScreen]
#endif

@interface UIScreen (NTAdd)
+ (CGFloat)nt_WidthRatioForIphone6;
+ (CGFloat)nt_NTHeightRatioForIphone6;

/**等同于 [UIScreen mainScreen].bounds*/
+ (CGFloat)nt_screenScale;

/**获取不同方向的屏幕rect*/
- (CGRect)nt_boundsForOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
