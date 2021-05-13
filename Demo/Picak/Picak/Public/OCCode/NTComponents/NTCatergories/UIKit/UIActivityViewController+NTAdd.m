//
//  UIActivityViewController+NTAdd.m
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/9.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIActivityViewController+NTAdd.h"
#import "NTCategoriesMacro.h"
#import "UIImage+NTAdd.h"

NT_SYNTH_DUMMY_CLASS(UIActivityViewController_NTAdd)

@implementation UIActivityViewController (NTAdd)

+ (void)nt_showWithShareArray:(NSArray *)shareArray{
    if (!shareArray.count) return;
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeMessage,UIActivityTypeCopyToPasteboard,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeMail];
    [NT_ROOT_WINDOW.rootViewController presentViewController:vc animated:YES completion:nil];
}

+ (void)gx_showWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url completeHandler:(void(^)(BOOL success, NSError *error, NTPlatformType type, NSString *activityType))completeHandler{

    NSMutableArray *items = [NSMutableArray array];
    if (title) {
        [items addObject:title];
    }
    if (image && [image isKindOfClass:[UIImage class]]) {
        [items addObject:image];

//        NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
//        [items addObject:[UIImage imageWithData:imageData]];
    }
    if (url && [url isKindOfClass:[NSString class]]) {
        [items addObject:[NSURL URLWithString:url]];
    }
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeMessage,UIActivityTypeCopyToPasteboard,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeMail];
    
    vc.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        NTPlatformType type = NTPlatformTypeOther;
        if ([activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {
            type = NTPlatformTypeTencent;
        }else if([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]){
            type = NTPlatformTypeWechat;
        }

        if (completeHandler) {
            completeHandler(completed && !activityError, activityError, type, activityType);
        }
        
    };
    
    [NT_ROOT_WINDOW.rootViewController presentViewController:vc animated:YES completion:nil];
    
    
    
    
}

@end
