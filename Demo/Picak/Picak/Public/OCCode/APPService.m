//
//  APPService.m
//  Picak
//
//  Created by 欧阳荣 on 2021/5/6.
//

#import "APPService.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

@implementation APPService

+ (void)thirdSDKConfig {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"2658438507779909" appSecret:@"4cf98eddd10b0c07c239f7d578c3533f" redirectURL:@"https://www.flyingeffect.com/"];
}

@end
