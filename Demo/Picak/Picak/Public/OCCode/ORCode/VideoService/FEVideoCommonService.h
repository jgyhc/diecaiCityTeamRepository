//
//  FEVideoCommonService.h
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/11.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEVideoCommonService : NSObject

+ (void)fe_generateImagesWithVideoAsset:(AVAsset *)asset
                               maxCount:(NSInteger)maxCount
                               minCount:(NSInteger)minCount
                            maximumSize:(CGSize)maximumSize
                                process:(void(^)(NSData *image, NSInteger index))process
                            completion:(void(^)(NSArray *_Nullable images))completion;

+ (CGSize)fe_sizeWithAsset:(AVAsset *)videoAsset;
+ (AVAssetTrack *)fe_firstTrackWithAsset:(AVAsset *)asset mediaType:(AVMediaType)type;

+ (UIImageOrientation)fe_orientationFromAVAssetTrack:(AVAssetTrack *)videoTrack;
+ (CGSize)fe_renderSizeWithOrientation:(UIImageOrientation)orientation size:(CGSize)size;
+ (CGAffineTransform)fe_transformWithOrientation:(UIImageOrientation)orientation size:(CGSize)size;

+ (UIImage *)fe_imageWithBuffer:(CMSampleBufferRef)sampleBuffer;

+ (void)fe_writeVideoWithBgImage:(UIImage *)bgImage
                        duration:(NSTimeInterval)duration
                        videoSize:(CGSize)videoSize
                        outPutPath:(NSString *)outPutPath
                        completion:(void(^)(NSError * _Nullable error))completion;

+ (UIImage *)fe_thumbnailImageForVideoAsset:(AVAsset *)asset atTime:(CMTime)time;
+ (CVPixelBufferRef)fe_cvPixelBufferRefWithCGImage:(CGImageRef)image;

+ (void)fe_saveAssetToPhotoWithPath:(NSString *)path completion:(void (^)(NSError * _Nullable error, NSString *identifier))completion;
+ (void)fe_saveAssetToPhotoWithImage:(UIImage *)image completion:(void (^)(NSError * _Nullable error, NSString *identifier))completion;
+ (void)fe_saveAssetToPhotoWithImagePath:(NSString *)path completion:(void (^)(NSError * _Nullable error, NSString *identifier))completion;

- (void)fe_saveAssetToPhotoWithPath:(NSString *)path completion:(void(^)(NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
