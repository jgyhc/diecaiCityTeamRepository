//
//  ALAssetsLibrary+NTAdd.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/3/16.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "ALAssetsLibrary+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

@implementation ALAssetsLibrary (NTAdd)

+ (void)nt_latestImage:(void (^)(UIImage * _Nullable, NSError * _Nullable))block{
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [self nt_setAssociateValue:library withKey:"tempHolder"];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    ALAssetRepresentation * representation = [result defaultRepresentation];
                    UIImage * image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.0 orientation:UIImageOrientationUp];
                    NT_BLOCK(block, image, nil);
                    *stop = YES;
                    [self nt_removeAssociateWithKey:"tempHolder"];
                }
            }];
            *stop = YES;
            [self nt_removeAssociateWithKey:"tempHolder"];
        }
    } failureBlock:^(NSError *error) {
        NT_BLOCK(block, nil, error);
        [self nt_removeAssociateWithKey:"tempHolder"];
    }];
}

@end
