//
//  UIControl+NTAdd.h
//  TryCenter
//
//  Created by wazrx on 16/6/5.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (NTAdd)

- (void)nt_removeAllTargets;

- (void)nt_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

- (void)nt_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)nt_addConfig:(void(^)(__kindof UIControl *control))config forControlEvents:(UIControlEvents)controlEvents;
- (void)nt_addSimpleConfig:(dispatch_block_t)config forControlEvents:(UIControlEvents)controlEvents;

- (void)nt_setConfig:(void(^)(__kindof UIControl *control))config forControlEvents:(UIControlEvents)controlEvents;
- (void)nt_setSimpleConfig:(dispatch_block_t)config forControlEvents:(UIControlEvents)controlEvents;

- (void)nt_NT_BLOCKActionForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
