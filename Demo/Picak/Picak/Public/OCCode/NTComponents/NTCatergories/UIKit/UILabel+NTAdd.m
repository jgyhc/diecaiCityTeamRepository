//
//  UILabel+NTAdd.m
//  weather+
//
//  Created by wazrx on 16/4/14.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UILabel+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UILabel_NTAdd)

@implementation UILabel (NTAdd)

+ (void)load{
    [self nt_swizzleInstanceMethod:@selector(setText:) with:@selector(_nt_setText:)];
}

- (BOOL)textChangeWithAnimaiton{
    return [[self nt_getAssociatedValueForKey:"nt_textAnimation"] boolValue];
}

- (void)setTextChangeWithAnimaiton:(BOOL)textChangeWithAnimaiton{
    [self nt_setAssociateValue: @(textChangeWithAnimaiton) withKey:"nt_textAnimation"];
}

- (void)_nt_setText:(NSString *)text{
    if (self.textChangeWithAnimaiton) {
        [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self _nt_setText:text];
        } completion:nil];
    }else{
        [self _nt_setText:text];
    }
}

@end
