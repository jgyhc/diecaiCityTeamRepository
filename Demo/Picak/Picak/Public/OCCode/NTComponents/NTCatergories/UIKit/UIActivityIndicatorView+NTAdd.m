//
//  UIActivityIndicatorView+NTAdd.m
//  WxSelected
//
//  Created by YouLoft_MacMini on 15/12/23.
//  Copyright © 2015年 wazrx. All rights reserved.
//

#import "UIActivityIndicatorView+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "UIView+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIActivityIndicatorView_NTAdd)

@implementation UIActivityIndicatorView (NTAdd)

+ (void)nt_showAnimationInView:(UIView *)view indicatorColor:(UIColor *)color{
    UIActivityIndicatorView *indicator = [view nt_getAssociatedValueForKey:"currentIndicator"];
    if (!indicator) {
        indicator = [UIActivityIndicatorView new];
        indicator.color = color;
        indicator.center = CGPointMake(view.nt_width / 2.0f, view.nt_height / 2.0f);
        [view addSubview:indicator];
        [view nt_setAssociateValue:indicator withKey:"currentIndicator"];
    }
    if (!indicator.isAnimating) {
        [indicator startAnimating];
    }
}

+ (void)nt_stopAnimationInView:(UIView *)view{
    UIActivityIndicatorView *indicator = [view nt_getAssociatedValueForKey:"currentIndicator"];
    if (indicator) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [view nt_removeAssociateWithKey:"currentIndicator"];
    }
}

@end
