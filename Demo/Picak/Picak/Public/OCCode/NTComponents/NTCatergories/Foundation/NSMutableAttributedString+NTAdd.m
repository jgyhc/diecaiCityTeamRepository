//
//  NSMutableAttributedString+NTAdd.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/4/1.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NSMutableAttributedString+NTAdd.h"
#import "UIImage+NTAdd.h"

#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSMutableAttributedString_NTAdd)

@implementation NSMutableAttributedString (NTAdd)

- (void)nt_appendSpacing:(float)spacing{
    NSTextAttachment *atta = [NSTextAttachment new];
    atta.image = [UIImage nt_imageWithColor:[UIColor clearColor]];
    atta.bounds = CGRectMake(0, 0, spacing, 1);
    [self appendAttributedString:[NSAttributedString attributedStringWithAttachment:atta]];
}

@end
