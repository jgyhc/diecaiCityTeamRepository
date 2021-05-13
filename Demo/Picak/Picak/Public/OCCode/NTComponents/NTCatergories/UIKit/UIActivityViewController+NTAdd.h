//
//  UIActivityViewController+NTAdd.h
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/9.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NTPlatformType) {
    NTPlatformTypeWechat,
    NTPlatformTypeTencent,
    NTPlatformTypeSina,
    NTPlatformTypeOther
};



@interface UIActivityViewController (NTAdd)
+ (void)nt_showWithShareArray:(NSArray *)shareArray;
+ (void)gx_showWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url completeHandler:(void(^)(BOOL success, NSError *error, NTPlatformType type, NSString *activityType))completeHandler;

@end
