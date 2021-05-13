//
//  FEVideoCommonService.m
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/11.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEVideoCommonService.h"
#import "UIImage+ORAdd.h"
#import <Photos/PHAsset.h>
#import <Photos/PHAssetChangeRequest.h>

@interface FEVideoCommonService ()

@property (nonatomic, copy) void(^saveCompletionBlcok)(NSError * _Nullable error);

@end

@implementation FEVideoCommonService


+ (void)fe_generateImagesWithVideoAsset:(AVAsset *)asset
                               maxCount:(NSInteger)maxCount
                               minCount:(NSInteger)minCount
                            maximumSize:(CGSize)maximumSize
                                process:(void (^)(NSData * _Nonnull, NSInteger))process
                             completion:(void (^)(NSArray * _Nullable))completion {
    
    NSArray *assetArray = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (!assetArray.count || !asset){
        completion(nil);
        return;
    }
    AVAssetTrack *videoTrack = assetArray.firstObject;
    int fps = [videoTrack nominalFrameRate];
    fps = MAX(5, fps);
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    if (CGSizeEqualToSize(maximumSize, CGSizeZero)) {
        imageGenerator.maximumSize =  CGSizeMake(200, 200);
    }else {
        imageGenerator.maximumSize =  maximumSize;
    }
    

    CMTime timeFrame;
    NSMutableArray *times = [NSMutableArray array];
    // 获取特定的图片

    NSTimeInterval totalTime = CMTimeGetSeconds(asset.duration);
    if (totalTime <= 0) {
        completion(nil);
        return;
    }
    
    CGFloat totalFps = fps * totalTime;
    
    NSInteger totalTimeCount = ceil(totalTime / 5.0);
    
    totalTimeCount = MAX(totalTimeCount, minCount);
    totalTimeCount = MIN(totalTimeCount, maxCount);

    CGFloat margin = totalFps / totalTimeCount;
    for (int i = 0; i < totalTimeCount; i++) {
        timeFrame = CMTimeMake(i * margin, fps);
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    __block BOOL isCompletion = NO;
    
    // 开始获取图片
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        CMTimeValue value = requestedTime.value;
        NSInteger index = value / margin;
        if (error) {
//            NSLog(@"orcede ====%@",error);
            if (isCompletion) {
                return;
            }
            isCompletion = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array.copy);
            });
            return;
        }
        
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                
                break;
            case AVAssetImageGeneratorFailed:
                
                break;
            case AVAssetImageGeneratorSucceeded: {
                // 获取图片成功这个异步
                @autoreleasepool {
                    UIImage *frameImg = [UIImage imageWithCGImage:image];
                    NSData *data = UIImageJPEGRepresentation(frameImg, 0.1);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index < totalTimeCount) {
                            process(data, index);
                            [array addObject:data];
                        }
                        if (array.count == totalTimeCount) {
                            completion(array.copy);
                        }
                    });
                }
            }
                break;
        }
    }];
}


+ (CGSize)fe_sizeWithAsset:(AVAsset *)videoAsset {
    
    AVAssetTrack *videoTrack = [self fe_firstTrackWithAsset:videoAsset mediaType:AVMediaTypeVideo];
    if (videoTrack == nil){
        return CGSizeZero;
    }
    CGSize naturalSize = videoTrack.naturalSize;;
    
    UIImageOrientation orientation = [self fe_orientationFromAVAssetTrack:videoTrack];
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        naturalSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
    }
    return naturalSize;
}

+ (AVAssetTrack *)fe_firstTrackWithAsset:(AVAsset *)asset mediaType:(AVMediaType)type {
    
    AVAssetTrack *track = nil;
    if ([[asset tracksWithMediaType:type] count] != 0) {
        track = [asset tracksWithMediaType:type].firstObject;
    }
    return track;
}

+ (UIImageOrientation)fe_orientationFromAVAssetTrack:(AVAssetTrack *)videoTrack
{
    UIImageOrientation orientation = UIImageOrientationUp;
    CGAffineTransform t = videoTrack.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        orientation = UIImageOrientationRight;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        orientation = UIImageOrientationLeft;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        orientation = UIImageOrientationUp;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        orientation = UIImageOrientationDown;
    }else if(t.a == 0 && t.b == 1.0 && t.c == 1.0 && t.d == 0){
        orientation = UIImageOrientationLeftMirrored;
    }
    return orientation;
}

+ (CGSize)fe_renderSizeWithOrientation:(UIImageOrientation)orientation size:(CGSize)size {
    
    CGSize renderSize = size;
    if (orientation != UIImageOrientationUp && orientation != UIImageOrientationDown) {
        renderSize = CGSizeMake(renderSize.height, renderSize.width);
    }
    return renderSize;
}

+ (CGAffineTransform)fe_transformWithOrientation:(UIImageOrientation)orientation size:(CGSize)size {
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationLeft:
            transform = CGAffineTransformTranslate(transform, 0.0, size.width);
            transform = CGAffineTransformRotate(transform,M_PI_2*3.0);
            break;
        case UIImageOrientationRight: //实测是left
            transform = CGAffineTransformTranslate(transform, size.height, 0.0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformTranslate(transform, size.width, size.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            break;
        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformMakeScale(1, -1);
//            transform = CGAffineTransformTranslate(transform, size.height, 0.0);
//            transform = CGAffineTransformRotate(transform,M_PI_2);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            transform = CGAffineTransformScale(transform, 1, -1);
        break;
        default:
            break;
    }
    return transform;
}

+ (UIImage *)fe_imageWithBuffer:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    return image;
}

+ (CVPixelBufferRef)fe_cvPixelBufferRefWithCGImage:(CGImageRef)image {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth,
                                          frameHeight, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameWidth,
                                                 frameHeight, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0, frameWidth,
                                           frameHeight), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    CGImageRelease(image);
    return pxbuffer;
}

+ (void)fe_writeVideoWithBgImage:(UIImage *)bgImage
                        duration:(NSTimeInterval)duration
                       videoSize:(CGSize)videoSize outPutPath:(NSString *)outPutPath
                      completion:(void (^)(NSError * _Nullable))completion {
    
    unlink(outPutPath.UTF8String);
    NSError *error;
    
    NSURL *fileUrl = [NSURL fileURLWithPath:outPutPath];
    AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeMPEG4 error:&error];
    
    if (error) {
        completion(error);
        return;
    }
    
    NSDictionary *videoCompressionProps = @{
        AVVideoAverageBitRateKey:[NSNumber numberWithDouble:videoSize.width * videoSize.height],
        AVVideoExpectedSourceFrameRateKey:@(30),
        AVVideoMaxKeyFrameIntervalKey:@(1)
    };
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecTypeH264,
                                    AVVideoWidthKey: @(videoSize.width),
                                    AVVideoHeightKey: @(videoSize.height),
                                    AVVideoCompressionPropertiesKey: videoCompressionProps};
    
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    writerInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:bufferAttributes];
    
    
    //write
    [writer addInput:writerInput];
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    int __block frame = 0;
    CVPixelBufferRef buffer = bgImage.or_pixelBuffer;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue
                                       usingBlock:^
     {
         while ([writerInput isReadyForMoreMediaData])
         {

             if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, (int32_t)30)])
             {
                 NSError *error = writer.error;
                 if(error)
                 {
                     NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                     CVPixelBufferRelease(buffer);
                     if (completion) {
                         completion(error);
                     }
                     break;
                 }
             }

             if(++frame >= (int)ceilf(duration * 30))
             {
                 CVPixelBufferRelease(buffer);
                 [writerInput markAsFinished];
                 [writer finishWritingWithCompletionHandler:^{
                     if (completion) {
                         completion(nil);
                     }
                 }];
                 break;
             }
         }
     }];
}

+ (UIImage *)fe_thumbnailImageForVideoAsset:(AVAsset *)asset atTime:(CMTime)time {
    if (!asset) {
        return nil;
    }
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:time actualTime:NULL error:&thumbnailImageGenerationError];
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}

+ (void)fe_saveAssetToPhotoWithPath:(NSString *)path completion:(nonnull void (^)(NSError * _Nullable, NSString * _Nonnull))completion {
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    
    __block NSString *identifer = @"";
    [photoLibrary performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL
    fileURLWithPath:path]];
        identifer = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error,identifer);
        });
    }];
}

+ (void)fe_saveAssetToPhotoWithImage:(UIImage *)image completion:(void (^)(NSError * _Nullable, NSString * _Nonnull))completion {
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    __block NSString *identifer = @"";
    [photoLibrary performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        identifer = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error,identifer);
        });
    }];
}

+ (void)fe_saveAssetToPhotoWithImagePath:(NSString *)path completion:(void (^)(NSError * _Nullable, NSString * _Nonnull))completion {
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    __block NSString *identifer = @"";
    [photoLibrary performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL
                                                                                                         fileURLWithPath:path]];
        identifer = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error,identifer);
        });
    }];
}

- (void)fe_saveAssetToPhotoWithPath:(NSString *)path completion:(void (^)(NSError * _Nullable))completion {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        _saveCompletionBlcok = completion;
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(_fe_saveAssetToPhotoWithPath:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    completion([NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"未开启相册保存权限"}]);
}

- (void)_fe_saveAssetToPhotoWithPath:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error.code == -1) {
        _saveCompletionBlcok(nil);
        return;
    }
    _saveCompletionBlcok(error);
}


@end
