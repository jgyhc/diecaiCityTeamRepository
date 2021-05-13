//
//  CIFilter+NTAdd.h
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/6.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIFilter (NTAdd)

+ (UIImage *)nt_makeQRCodeImageWithString:(NSString *)string;

+ (CGRect)nt_scanOneQRCode:(UIImage *)image;

@end
