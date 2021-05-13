//
//  NSTimer+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/14.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSTimer+NTAdd.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSTimer_NTAdd)

@implementation NSTimer (NTAdd)

static void *nt_timer = "nt_timer";


+ (void)nt_scheduledCommonModesTimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeat {
    NSTimer *timer = objc_getAssociatedObject(target, nt_timer);
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:interval target:target selector:selector userInfo:nil repeats:repeat];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        objc_setAssociatedObject(target, nt_timer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}

+ (void)nt_removeTimeOnTarget:(id)target {
    NSTimer *timer = objc_getAssociatedObject(target, nt_timer);
    if (timer) {
        [timer invalidate];
        objc_setAssociatedObject(target, nt_timer, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

+ (NSTimer *)nt_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(dispatch_block_t)block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(_nt_NT_BLOCK:) userInfo:[block copy] repeats:repeats];
}

+ (void)_nt_NT_BLOCK:(NSTimer *)timer{
    dispatch_block_t block = timer.userInfo;
    NT_BLOCK(block);
}


@end
