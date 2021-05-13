//
//  CADisplayLink+NTAdd.m
//  haveFun
//
//  Created by 肖文 on 2017/1/3.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "CADisplayLink+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

@implementation CADisplayLink (NTAdd)

+ (CADisplayLink *)nt_displayLinkWithBlock:(dispatch_block_t)block{
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(_nt_handleTimer:)];
    [timer nt_setAssociateValue:block withKey:"nt_timerBlock"];
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)_nt_handleTimer:(CADisplayLink *)timer{
    dispatch_block_t timerBlock = [timer nt_getAssociatedValueForKey:"nt_timerBlock"];
    NT_BLOCK(timerBlock);
}

@end
