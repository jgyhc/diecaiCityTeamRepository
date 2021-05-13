//
//  VIRangeContentAssetImageDataSource.m
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIRangeContentAssetImageDataSource.h"
#import "CachedAssetImageGenerator.h"
#import "ORAddForAsset.h"

@interface VIRangeContentAssetImageDataSource()

@property (nonatomic, strong, readwrite) AVAsset *asset;
@property (nonatomic, strong) CachedAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) UIImage *or_image;

@end

@implementation VIRangeContentAssetImageDataSource

- (instancetype)initWithAsset:(AVAsset *)asset imageSize:(CGSize)imageSize widthPerSecond:(CGFloat)widthPerSecond {
    self = [super init];
    if (self) {
        _asset = asset;
        if (![self or_isImage]) {
            CachedAssetImageGenerator *imageGenerator = [CachedAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
            imageGenerator.requestedTimeToleranceBefore = CMTimeMake(600, 600);
            imageGenerator.requestedTimeToleranceAfter = CMTimeMake(600, 600);
            imageGenerator.appliesPreferredTrackTransform = YES;
            _imageGenerator = imageGenerator;
        }
        [self setImageSize:imageSize];
        _widthPerSecond = widthPerSecond;
    }
    return self;
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    
    imageSize = CGSizeMake(imageSize.width * UIScreen.mainScreen.scale, imageSize.height * UIScreen.mainScreen.scale);
    
    if ([self or_isImage]) {
        UIImage *image = (UIImage *)_asset;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, image.scale);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        _or_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return;
    }
    
    AVAssetTrack *track = [[self.imageGenerator.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    if (track) {
        CGSize size = CGSizeMake(imageSize.width, imageSize.height);
        if (track) {
            CGSize naturalSize = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
            naturalSize.width = fabs(naturalSize.width);
            naturalSize.height = fabs(naturalSize.height);
            if (naturalSize.width / imageSize.width > naturalSize.height / imageSize.height) {
                size = CGSizeMake(0, imageSize.height);
            } else {
                size = CGSizeMake(imageSize.width, 0);
            }
        }
        self.imageGenerator.maximumSize = size;
    } else {
        self.imageGenerator.maximumSize = imageSize;
    }
}

#pragma mark - VIVideoRangeContentViewDataSource

- (NSInteger)videoRangeContentViewNumberOfImages:(VIVideoRangeContentView *)view {
    NSTimeInterval sourceSeconds = CMTimeGetSeconds(self.asset.or_duration);
    return ceil(sourceSeconds / (self.imageSize.width / self.widthPerSecond));
}

- (UIImage *)videoRangeContent:(VIVideoRangeContentView *)view imageAtIndex:(NSInteger)index preferredSize:(CGSize)size {
    
    if (_or_image) {
        return _or_image;
    }
    
    CGFloat offset = view.imageSize.width * index;
    NSTimeInterval time = offset / self.widthPerSecond;
    
    UIImage *image;
    CGImageRef cgimage = [self.imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(time, 600) actualTime:nil error:nil];
    if (cgimage) {
        image = [[UIImage alloc] initWithCGImage:cgimage];
    }
    return image;
}

- (BOOL)videoRangeContent:(VIVideoRangeContentView *)view hasCacheAtIndex:(NSInteger)index {
    
    if (_or_image) {
        return YES;
    }
    
    CGFloat offset = view.imageSize.width * index;
    NSTimeInterval second = offset / self.widthPerSecond;
    CMTime time = CMTimeMakeWithSeconds(second, 600);
    return [self.imageGenerator hasCacheAtTime:time];
}

- (BOOL)or_isImage{
    return [_asset isKindOfClass:[UIImage class]];
}

@end
