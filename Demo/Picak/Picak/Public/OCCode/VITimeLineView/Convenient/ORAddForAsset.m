//
//  UIImage+ORAddForAsset.m
//  VITimelineViewDemo
//
//  Created by 欧阳荣 on 2021/4/23.
//  Copyright © 2021 vito. All rights reserved.
//

#import "ORAddForAsset.h"

@implementation UIImage (ORAddForAsset)

- (CMTime)or_duration {
    return CMTimeMake(6000, 600);
}

@end

@implementation AVAsset (ORAddForAsset)

- (CMTime)or_duration {
    return self.duration;
}

@end
