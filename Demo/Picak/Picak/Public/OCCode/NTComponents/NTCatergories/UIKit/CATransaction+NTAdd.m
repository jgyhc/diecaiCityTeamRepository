//
//  CATransaction+NTAdd.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/3/2.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "CATransaction+NTAdd.h"

@implementation CATransaction (NTAdd)

+ (void)nt_setWithoutAnimation:(dispatch_block_t)block{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (block) block();
    [CATransaction commit];
    block = nil;
}

@end
