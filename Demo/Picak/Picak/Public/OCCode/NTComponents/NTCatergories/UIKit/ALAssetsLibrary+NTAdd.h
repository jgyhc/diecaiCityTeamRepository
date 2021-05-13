//
//  ALAssetsLibrary+NTAdd.h
//  NewCenterWeather
//
//  Created by 肖文 on 2017/3/16.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface ALAssetsLibrary (NTAdd)

+ (void)nt_latestImage:(void(^_Nullable)(UIImage * _Nullable image,NSError *_Nullable error)) block;

@end
