//
//  UIResponder+NTAdd.h
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (NTAdd)

- (void)nt_setHandleURLConfig:(BOOL(^)(NSURL *url))config;

@end
