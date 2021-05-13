//
//  FEVideoExportService.m
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/3/18.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEVideoExportService.h"
#import "NTCategoriesMacro.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FEVideoExportService () {
    BOOL _private;
}
@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, copy) NSString *privatePath;
@end

@implementation FEVideoExportService

- (void)dealloc
{
    [self.exportSession cancelExport];
    self.exportSession = nil;
    NT_LOG(@"FEVideoExportService dealloc");
}

#pragma mark -- export
- (void)fe_exportWithAnimationBlock:(ORAnimationBlock)animationBlock completion:(nonnull FEExportCompletionBlock)completion {
        
    [self.exportSession cancelExport];

    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    
    UIImageOrientation orientation = [FEVideoCommonService fe_orientationFromAVAssetTrack:videoTrack];
    CGAffineTransform transform = [FEVideoCommonService fe_transformWithOrientation:orientation size:videoTrack.naturalSize];
    CGSize renderSize = [FEVideoCommonService fe_renderSizeWithOrientation:orientation size:videoTrack.naturalSize];
    
    CALayer *parentLayer = [CALayer layer];
    parentLayer.geometryFlipped = YES;
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    
    [parentLayer addSublayer:videoLayer];
    
    
    NT_WEAKIFY(self);
    dispatch_block_t animationCompletion = ^{
        NT_STRONGIFY(self);
        
        AVMutableVideoComposition *videoComposion = [AVMutableVideoComposition videoComposition];
        videoComposion.renderSize = renderSize;
        videoComposion.frameDuration = CMTimeMake(1, 30);
        videoComposion.animationTool = [AVVideoCompositionCoreAnimationTool
                                        videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                        inLayer:parentLayer];
        
        //合成指令 此处修正transform
        AVMutableVideoCompositionInstruction *compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        compositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [layerInstruction setTransform:transform atTime:kCMTimeZero];
        compositionInstruction.layerInstructions = @[layerInstruction];
        videoComposion.instructions = @[compositionInstruction];
        
                
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.videoComposition = videoComposion;
        [self _fe_exportWithExportSession:exportSession completion:completion];

    };
    
    if (animationBlock) {
        animationBlock(videoLayer, animationCompletion);
        return;
    }
    animationCompletion();
}

- (void)fe_exportForRenderSize:(CGSize)renderSize videoFrame:(CGRect)videoFrame WithAnimationBlock:(ORAnimationBlock)animationBlock completion:(FEExportCompletionBlock)completion {
    [self.exportSession cancelExport];

    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    
    UIImageOrientation orientation = [FEVideoCommonService fe_orientationFromAVAssetTrack:videoTrack];


    CGSize rawRenderSize = [FEVideoCommonService fe_renderSizeWithOrientation:orientation size:videoTrack.naturalSize];
    CGAffineTransform transform = [FEVideoCommonService fe_transformWithOrientation:orientation size:videoFrame.size];
    transform = CGAffineTransformTranslate(transform, videoFrame.origin.x, videoFrame.origin.y);
    transform = CGAffineTransformScale(transform, videoFrame.size.width / rawRenderSize.width, videoFrame.size.height / rawRenderSize.height);
    
    
    CALayer *parentLayer = [CALayer layer];
    parentLayer.geometryFlipped = YES;
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    
    CALayer *contentLayer = [CALayer layer];
    contentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithRect:videoLayer.bounds];
    
    CGFloat inset = videoFrame.size.height * 0.01;
    CGRect makeframe = videoFrame;
    makeframe.size.height -= inset * 2;
    makeframe.size.width -= inset * 2;
    makeframe.origin.x += inset;
    makeframe.origin.y += inset;

    [bezPath appendPath:[[UIBezierPath bezierPathWithRect:makeframe] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezPath.CGPath;
    
    
    [contentLayer setMask:shapeLayer];
    
    [videoLayer addSublayer:contentLayer];
    [parentLayer addSublayer:videoLayer];
    
    NT_WEAKIFY(self);
    dispatch_block_t animationCompletion = ^{
        NT_STRONGIFY(self);
        
        AVMutableVideoComposition *videoComposion = [AVMutableVideoComposition videoComposition];
        videoComposion.renderSize = renderSize;
        videoComposion.frameDuration = CMTimeMake(1, 30);
        videoComposion.animationTool = [AVVideoCompositionCoreAnimationTool
                                        videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                        inLayer:parentLayer];
        
        //合成指令 此处修正transform
        AVMutableVideoCompositionInstruction *compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        compositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [layerInstruction setTransform:transform atTime:kCMTimeZero];
        compositionInstruction.layerInstructions = @[layerInstruction];
        videoComposion.instructions = @[compositionInstruction];
        
                
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.videoComposition = videoComposion;
        [self _fe_exportWithExportSession:exportSession completion:completion];

    };
    
    if (animationBlock) {
        animationBlock(contentLayer, animationCompletion);
        return;
    }
    animationCompletion();
}

- (void)fe_exportWithAudioAsset:(AVAsset *)audioAsset timeRange:(CMTimeRange)timeRange atTime:(CMTime)time completion:(FEExportCompletionBlock)completion {
    
    AVMutableComposition *compositon = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *mutableVideoTrack = [compositon addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAsset *asset = self.videoAsset;
    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:asset mediaType:AVMediaTypeVideo];
    if (videoTrack) {
        [mutableVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    }

    if (audioAsset) {
        AVMutableCompositionTrack *mutableAudioTrack = [compositon addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *audioTrack = [FEVideoCommonService fe_firstTrackWithAsset:audioAsset mediaType:AVMediaTypeAudio];;
        if (!audioTrack) {
            completion([NSError new]);
            return;
        }
        [mutableAudioTrack insertTimeRange:timeRange ofTrack:audioTrack atTime:time error:nil];
    }
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:compositon presetName:AVAssetExportPresetHighestQuality];
    [self _fe_exportWithExportSession:exportSession completion:completion];
}

- (void)fe_exportWithAudioAsset:(AVAsset *)audioAsset completion:(FEExportCompletionBlock)completion {
    
    AVMutableComposition *compositon = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *mutableVideoTrack = [compositon addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAsset *asset = self.videoAsset;
    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:asset mediaType:AVMediaTypeVideo];
    if (videoTrack) {
        [mutableVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    }

    if (audioAsset) {
        AVMutableCompositionTrack *mutableAudioTrack = [compositon addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *audioTrack = [FEVideoCommonService fe_firstTrackWithAsset:audioAsset mediaType:AVMediaTypeAudio];;
        if (!audioTrack) {
            completion([NSError new]);
            return;
        }
        int count = ceil(CMTimeGetSeconds(asset.duration) / CMTimeGetSeconds(audioAsset.duration));
        CMTime atTime = kCMTimeZero;
        for (int i = 0; i < count; i ++) {
            CMTime duration = CMTimeSubtract(asset.duration, atTime);
            duration = CMTimeMinimum(duration, audioAsset.duration);
            [mutableAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:audioTrack atTime:atTime error:nil];
            atTime = CMTimeAdd(atTime, duration);
        }
    }
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:compositon presetName:AVAssetExportPresetHighestQuality];
    [self _fe_exportWithExportSession:exportSession completion:completion];
}

- (void)fe_exportWithFreme:(int)frame completion:(FEExportCompletionBlock)completion {
    
    if (self.videoAsset.duration.value <= 0) {
        return;
    }
    
    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    UIImageOrientation orientation = [FEVideoCommonService fe_orientationFromAVAssetTrack:videoTrack];
    
        
    CGAffineTransform transform = [FEVideoCommonService fe_transformWithOrientation:orientation size:videoTrack.naturalSize];
    CGSize renderSize = [FEVideoCommonService fe_renderSizeWithOrientation:orientation size:videoTrack.naturalSize];
    
    AVMutableVideoComposition *videoComposion = [AVMutableVideoComposition videoComposition];
    videoComposion.renderSize = renderSize;
    videoComposion.frameDuration = CMTimeMake(1, frame);
    
    //合成指令 此处修正transform
    AVMutableVideoCompositionInstruction *compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    compositionInstruction.layerInstructions = @[layerInstruction];
    videoComposion.instructions = @[compositionInstruction];
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposion;
    [self _fe_exportWithExportSession:exporter completion:completion];
}

- (void)fe_exportWithTimeRange:(CMTimeRange)timeRange presetName:(NSString *)presetName completion:(FEExportCompletionBlock)completion {
    
    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    UIImageOrientation orientation = [FEVideoCommonService fe_orientationFromAVAssetTrack:videoTrack];
    
        
    CGAffineTransform transform = [FEVideoCommonService fe_transformWithOrientation:orientation size:videoTrack.naturalSize];
    CGSize renderSize = [FEVideoCommonService fe_renderSizeWithOrientation:orientation size:videoTrack.naturalSize];
    
    AVMutableVideoComposition *videoComposion = [AVMutableVideoComposition videoComposition];
    videoComposion.renderSize = renderSize;
    videoComposion.frameDuration = CMTimeMake(1, 30);
    
    //合成指令 此处修正transform
    AVMutableVideoCompositionInstruction *compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compositionInstruction.timeRange = timeRange;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    compositionInstruction.layerInstructions = @[layerInstruction];
    videoComposion.instructions = @[compositionInstruction];
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:presetName];
    exporter.timeRange = timeRange;
    exporter.videoComposition = videoComposion;
    [self _fe_exportWithExportSession:exporter completion:completion];
}

- (void)fe_exportWithTimeRange:(CMTimeRange)timeRange completion:(FEExportCompletionBlock)completion {
    
    
    NSString *presetName;
    NSString *outputFileType;
    
    NSString *pathExtension = [(AVURLAsset *)self.videoAsset URL].path.lastPathComponent.pathExtension;
    
    if ([pathExtension isEqualToString:@"mp4"]) {
        presetName = AVAssetExportPresetHighestQuality;
        outputFileType = AVFileTypeMPEG4;
    }else if ([pathExtension isEqualToString:@"m4a"]||[pathExtension isEqualToString:@"aac"]||[pathExtension isEqualToString:@"mp3"]||[pathExtension isEqualToString:@"MP3"]){
        presetName = AVAssetExportPresetAppleM4A;
        outputFileType = AVFileTypeAppleM4A;
    }else if ([pathExtension isEqualToString:@"aif"]||[pathExtension isEqualToString:@"aiff"]){
        presetName = AVAssetExportPresetPassthrough;
        outputFileType = AVFileTypeAIFF;
    }else if ([pathExtension isEqualToString:@"wav"]||[pathExtension isEqualToString:@"wave"]||[pathExtension isEqualToString:@"bwf"]){
        presetName = AVAssetExportPresetPassthrough;
        outputFileType = AVFileTypeWAVE;
    }else if ([pathExtension isEqualToString:@"pcm"]){
        presetName = AVAssetExportPresetPassthrough;
        outputFileType = AVFileTypeCoreAudioFormat;
    }else{
        presetName = AVAssetExportPresetHighestQuality;
        outputFileType = AVFileTypeMPEG4;
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:presetName];
    exporter.outputFileType = outputFileType;
    exporter.timeRange = timeRange;
    exporter.outputURL = [NSURL fileURLWithPath:self.outputPath];
    exporter.shouldOptimizeForNetworkUse = YES;
    self.exportSession = exporter;
    NT_WEAKIFY(self);
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NT_STRONGIFY(self);
        self->_private = NO;
        if (!self.exportSession.error && self.isSaveAlbum) {
            [self fe_saveToAlbumCompletion:completion];
        }else {
            completion(self.exportSession.error);
        }
    }];
}

- (void)fe_exportUpdateWithTimeRange:(CMTimeRange)timeRange cropPercent:(float)cropPercent coverImage:(UIImage *)coverImage presetName:(NSString *)presetName completion:(FEExportCompletionBlock)completion {
    
    AVAssetTrack *videoTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    UIImageOrientation orientation = [FEVideoCommonService fe_orientationFromAVAssetTrack:videoTrack];
    
    if (orientation != UIImageOrientationUp) {
        NT_WEAKIFY(self);
        _private = YES;
        [self fe_exportWithFreme:30 completion:^(NSError * _Nullable error) {
            NT_STRONGIFY(self);
            if (error) {
                completion(error);
                return;
            }
            self.videoAsset = [AVAsset assetWithURL:self.exportSession.outputURL];
            [self fe_exportUpdateWithTimeRange:timeRange cropPercent:cropPercent coverImage:coverImage presetName:presetName completion:completion];
        }];
        return;
    }
        
    CGSize renderSize = videoTrack.naturalSize;
    
    AVMutableVideoComposition *videoComposion = [AVMutableVideoComposition videoComposition];
    videoComposion.renderSize = renderSize;
    videoComposion.frameDuration = CMTimeMake(1, 30);
    
    if (coverImage) {
        CALayer *parentLayer = [CALayer layer];
        parentLayer.geometryFlipped = YES;
        parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
        CALayer *videoLayer = [CALayer layer];
        videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
        [parentLayer addSublayer:videoLayer];
        
        CALayer *coverImageLayer = [CALayer layer];
        coverImageLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
        [videoLayer addSublayer:coverImageLayer];
        coverImageLayer.contents = (__bridge id _Nullable)(coverImage.CGImage);
        coverImageLayer.contentsGravity = kCAGravityResizeAspectFill;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(1.f);
        animation.toValue = @(0.0f);
        animation.duration = 0.1f;
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:kCAFillModeForwards];
        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
        [coverImageLayer addAnimation:animation forKey:@"opacity"];
        videoComposion.animationTool = [AVVideoCompositionCoreAnimationTool
                                        videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                        inLayer:parentLayer];
    }

    AVMutableVideoCompositionInstruction *compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compositionInstruction.timeRange = timeRange;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
    if (cropPercent < 1 && cropPercent > 0.1) {
        CGFloat width = floor(renderSize.width * cropPercent / 4.0) * 4;
        CGFloat height = floor(renderSize.height * cropPercent / 4.0) * 4;
        CGFloat x = floor((renderSize.width - width) / 2.0);
        CGFloat y = floor((renderSize.height - height) / 2.0);

        CGRect cropRect = CGRectMake(x, y, width, height);
        videoComposion.renderSize = cropRect.size;
        [layerInstruction setCropRectangle:cropRect atTime:kCMTimeZero];
        [layerInstruction setTransform:CGAffineTransformMakeTranslation(-x, -y) atTime:kCMTimeZero];
    }
    
    compositionInstruction.layerInstructions = @[layerInstruction];
    videoComposion.instructions = @[compositionInstruction];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.videoAsset presetName:presetName];
    exporter.timeRange = timeRange;
    exporter.videoComposition = videoComposion;
    [self _fe_exportWithExportSession:exporter completion:completion];
}

#pragma mark -- private
- (void)_fe_exportWithExportSession:(AVAssetExportSession *)exportSession completion:(FEExportCompletionBlock)completion {
    exportSession.outputURL = [NSURL fileURLWithPath:self.outputPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    self.exportSession = exportSession;
    NT_WEAKIFY(self);
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        NT_STRONGIFY(self);
        if (!self) {
            return;
        }
        self->_private = NO;
        if (!self.exportSession.error && self.isSaveAlbum) {
            [self fe_saveToAlbumCompletion:completion];
        }else {
            completion(self.exportSession.error);
        }
    }];
}

#pragma mark -- getter
- (CGFloat)progress {
    return self.exportSession.progress;
}

- (NSString *)outputPath {
    if (_private) {
        return self.privatePath;
    }
    return [super outputPath];
}

- (NSString *)privatePath {
    if (!_privatePath) {
        _privatePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fe_temp_export.mp4"];
    }
    unlink(_privatePath.UTF8String);
    return _privatePath;
}

@end
