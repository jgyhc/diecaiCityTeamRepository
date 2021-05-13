//
//  CADisplayLink+NTAdd.h
//  haveFun
//
//  Created by 肖文 on 2017/1/3.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (NTAdd)

/**解除displayLink的循环引用问题*/
+ (CADisplayLink *)nt_displayLinkWithBlock:(dispatch_block_t)block;

@end
