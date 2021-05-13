//
//  CATransaction+NTAdd.h
//  NewCenterWeather
//
//  Created by 肖文 on 2017/3/2.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (NTAdd)

+ (void)nt_setWithoutAnimation:(dispatch_block_t)block;


@end
