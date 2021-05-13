//
//  UIViewController+ORAdd.h
//  NTHandleBarrage
//
//  Created by 欧阳荣 on 2018/4/2.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ORAdd)

- (UIViewController *)currentViewController;
+ (UIViewController *)currentViewController;

- (void)or_showAlert:(NSString *)title message:(NSString *)msg;
- (void)or_showOnlySureAlert:(NSString *)title message:(NSString *)msg okAction:(dispatch_block_t)block;

- (void)or_showAlert:(NSString *)title message:(NSString *)msg okAction:(dispatch_block_t)block;

- (void)or_showAlert:(NSString *)title message:(NSString *)msg hasCancel:(BOOL)hasCancel okAction:(dispatch_block_t)okBlock cancelAction:(dispatch_block_t)cancelBlock;

- (void)or_showAlert:(NSString *)title message:(NSString *)msg destructiveActionTitle:(NSString *)actiontitle style:(UIAlertControllerStyle)style completion:(dispatch_block_t)block;

- (void)or_showAlert:(NSString *)title message:(NSString *)msg actionTitles:(NSArray<NSString *> *)actionTitles style:(UIAlertControllerStyle)style completion:(void(^)(NSInteger index))block;

@end
