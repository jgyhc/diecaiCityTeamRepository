//
//  UIImageView+NTAdd.m
//  weather+
//
//  Created by wazrx on 16/4/14.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIImageView+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIImageView_NTAdd)

@implementation UIImageView (NTAdd)

+ (void)load{
    [self nt_swizzleInstanceMethod:@selector(setImage:) with:@selector(_nt_setImage:)];
}

- (BOOL)imageChangeWithAnimaiton{
    return [[self nt_getAssociatedValueForKey:"nt_imageAnimation"] boolValue];
}

- (void)setImageChangeWithAnimaiton:(BOOL)imageChangeWithAnimaiton{
    [self nt_setAssociateValue: @(imageChangeWithAnimaiton) withKey:"nt_imageAnimation"];
}

- (void)_nt_setImage:(NSString *)image{
    if (self.imageChangeWithAnimaiton) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self _nt_setImage:image];
        } completion:nil];
    }else{
        [self _nt_setImage:image];
    }
}

@end
