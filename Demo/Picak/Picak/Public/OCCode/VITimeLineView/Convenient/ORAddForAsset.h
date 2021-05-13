//
//  UIImage+ORAddForAsset.h
//  VITimelineViewDemo
//
//  Created by 欧阳荣 on 2021/4/23.
//  Copyright © 2021 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ORAddForAsset)

//不能直接使用duration，应该是私有方法
- (CMTime)or_duration;


@end

@interface AVAsset (ORAddForAsset)

- (CMTime)or_duration;

@end


NS_ASSUME_NONNULL_END
