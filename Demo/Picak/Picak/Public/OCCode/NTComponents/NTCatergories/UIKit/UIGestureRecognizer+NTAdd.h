//
//  UIGestureRecognizer+NTAdd.h
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/12.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (NTAdd)

+ (instancetype)nt_recognizerWithBlock:(void(^)(__kindof UIGestureRecognizer *gestureRecognizer))config;

- (void)nt_setActionBlock:(void(^)(__kindof UIGestureRecognizer *gestureRecognizer))config;

@end
