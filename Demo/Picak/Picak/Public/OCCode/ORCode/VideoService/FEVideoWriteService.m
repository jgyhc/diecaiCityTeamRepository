//
//  FEVideoWriteService.m
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/4/17.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEVideoWriteService.h"
#import "NTCategoriesMacro.h"
#import "UIImage+ORAdd.h"

NSString *const kWriteVideoPathKey = @"kWriteVideoPathKey";
NSString *const kWriteBeginTimeKey = @"kWriteBeginTimeKey";
NSString *const kWriteEndTimeKey = @"kWriteEndTimeKey";
static NSString *const kWriteOutPutKey = @"kWriteOutPutKey";


@interface FEVideoWriteService ()

@property (nonatomic, strong) AVAssetReader *assetReader;
@property (nonatomic, strong) AVAssetReader *audioReader;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) NSMutableArray <AVAssetReader *>* foregroundReaders;
@property (nonatomic, strong) AVAssetReaderTrackOutput *audioTrackOutput;
@property (nonatomic, copy) FEExportCompletionBlock completionBlock;
@property (nonatomic, assign) BOOL isPause;

@end

@implementation FEVideoWriteService

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVideoAsset:(AVAsset *)videoAsset outputPath:(NSString *)outputPath
{
    self = [super initWithVideoAsset:videoAsset outputPath:outputPath];
    if (self) {
        _isPause = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_fe_pauseWriter) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_fe_continueWriter) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)_fe_continueWriter {
    _isPause = NO;
}

- (void)_fe_pauseWriter {
    _isPause = YES;
}

- (void)_fe_cancelWriter {
    [_assetReader cancelReading];
    [self.foregroundReaders makeObjectsPerformSelector:@selector(cancelReading)];
    [_assetWriter cancelWriting];
    _audioTrackOutput = nil;
    if (self.completionBlock) {
        self.completionBlock([NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"请勿退出程序", nil)}]);
        self.completionBlock = nil;
    }
}

- (void)fe_writeWithBeginTime:(CMTime)beginTime
                      endTime:(CMTime)endTime
                   audioAsset:(AVAsset *)audioAsset
           writeBufferBlock:(FEWriteSingleBufferBlock)writeBufferBlock
                 completion:(FEExportCompletionBlock)completion {
    
    [self _fe_cancelWriter];

    self.completionBlock = completion;
    __block NSError *outError = nil;
    
    _assetReader = [[AVAssetReader alloc] initWithAsset:self.videoAsset error:&outError];
    if (outError) {
        completion(outError);
        return;
    }
    
    AVAssetTrack *assetTrack = [FEVideoCommonService fe_firstTrackWithAsset:self.videoAsset mediaType:AVMediaTypeVideo];
    NSDictionary *setting =   @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    AVAssetReaderTrackOutput *bgVideoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:assetTrack outputSettings:setting];
    bgVideoOutput.alwaysCopiesSampleData = NO;
    [_assetReader addOutput:bgVideoOutput];

    #pragma mark - writer
    NSURL *writeUrl = [NSURL fileURLWithPath:self.outputPath];
    _assetWriter = [[AVAssetWriter alloc] initWithURL:writeUrl fileType:AVFileTypeMPEG4 error:&outError];
    if (outError) {
        completion(outError);
        return;
    }
    CGSize assetSize = assetTrack.naturalSize;
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:assetSize.width * assetSize.height * 4], AVVideoAverageBitRateKey, nil];

    CGFloat width = assetSize.width;
    CGFloat height = assetSize.height;
    if (!CGSizeEqualToSize(CGSizeZero, _exportSize)) {
        width = _exportSize.width;
        height = _exportSize.height;
    }
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecTypeH264,
                                    AVVideoWidthKey: @(width),
                                    AVVideoHeightKey: @(height),
                                    AVVideoCompressionPropertiesKey: videoCompressionProps};
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    writerInput.expectsMediaDataInRealTime = YES;
    writerInput.mediaTimeScale = self.videoAsset.duration.timescale;
    [_assetWriter addInput:writerInput];
    
    NSDictionary *pixelBufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:pixelBufferAttributes];
    
    AVAssetWriterInput *audioTrackInput = nil;
    
    BOOL isViedeoAssetAudio = audioAsset == nil;
    if (isViedeoAssetAudio) {
        audioAsset = self.videoAsset;
    }
    
    #pragma mark - audio
    if (audioAsset) {
        AVAssetTrack *audioTrack = [FEVideoCommonService fe_firstTrackWithAsset:audioAsset mediaType:AVMediaTypeAudio];
        if (audioTrack) {
            _audioTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:@{(NSString*)AVFormatIDKey : @(kAudioFormatLinearPCM)}];
            if (isViedeoAssetAudio) {
                [_assetReader addOutput:_audioTrackOutput];
            }else {
                _audioReader = [[AVAssetReader alloc] initWithAsset:audioAsset error:&outError];
                [_audioReader addOutput:_audioTrackOutput];
            }
        }
        
        if (_audioTrackOutput) {
            audioTrackInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self configAudioInput]];
            if ([_assetWriter canAddInput:audioTrackInput]) {
                [_assetWriter addInput:audioTrackInput];
            } else {
                audioTrackInput = nil;
            }
        }
    }
    
    #pragma mark - begin
    [_assetReader startReading];
    if (!isViedeoAssetAudio) {
        [_audioReader startReading];
    }

    [_foregroundReaders makeObjectsPerformSelector:@selector(startReading)];

    [_assetWriter startWriting];
    [_assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);

    dispatch_queue_t dispatchQueue = dispatch_queue_create("fe.mediaInput.com", DISPATCH_QUEUE_SERIAL);
    
    CMTimeScale scale = self.videoAsset.duration.timescale;
    endTime = CMTimeConvertScale(endTime, scale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
    beginTime = CMTimeConvertScale(beginTime, scale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);

    CMTime duration = CMTimeSubtract(endTime, beginTime);
    
    
    NT_WEAKIFY(self);

    BOOL isCustomBG = self.customBgImage;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        if (weak_self.isPause == NO && writerInput.readyForMoreMediaData) {

            CMSampleBufferRef bgAssetBuffer = [bgVideoOutput copyNextSampleBuffer];
            
            if (bgAssetBuffer) {
                
                CMTime bgPresentationtTime = CMSampleBufferGetPresentationTimeStamp(bgAssetBuffer);
                
                CMTime currentTime = CMTimeSubtract(bgPresentationtTime, beginTime);
                
                if (currentTime.value < 0) {
                    CFRelease(bgAssetBuffer);
                    return;
                }

                if (currentTime.value > duration.value) {
                    CFRelease(bgAssetBuffer);
                    [writerInput markAsFinished];
                    dispatch_group_leave(dispatchGroup);
                    return;
                }
                
                UIImage *bgImage = isCustomBG ? self.customBgImage : [FEVideoCommonService fe_imageWithBuffer:bgAssetBuffer];

                CGFloat progress = currentTime.value / (duration.value * 1.0);
                CVPixelBufferRef newBuffer = writeBufferBlock(bgImage, progress);
                
                if (!newBuffer) {
                    [writerInput appendSampleBuffer:bgAssetBuffer];
                    CFRelease(bgAssetBuffer);
                    return;
                }
                [adaptor appendPixelBuffer:newBuffer withPresentationTime:currentTime];

                CVBufferRelease(newBuffer);
                CFRelease(bgAssetBuffer);
            }else {
                [writerInput markAsFinished];
                dispatch_group_leave(dispatchGroup);
            }
        }
    }];
    
    if (audioTrackInput) {

        CMTimeScale scale = 44100;
        CMTime audioDuration = CMTimeConvertScale(duration, scale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        CMTime audioBeginTime = CMTimeConvertScale(beginTime, scale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        
        dispatch_group_enter(dispatchGroup);
        dispatch_queue_t dispatchAudioQueue = dispatch_queue_create("fe.audioInput.com", DISPATCH_QUEUE_SERIAL);
    
        
        
        [audioTrackInput requestMediaDataWhenReadyOnQueue:dispatchAudioQueue usingBlock:^{
            NT_STRONGIFY(self);
            if (self.isPause == NO && writerInput.readyForMoreMediaData) {

                CMSampleBufferRef bgAssetBuffer = [self.audioTrackOutput copyNextSampleBuffer];
                if (bgAssetBuffer) {
                    
                    CMTime bgPresentationtTime = CMSampleBufferGetPresentationTimeStamp(bgAssetBuffer);
                    
                    CMTime currentTime = bgPresentationtTime;
                    if (isViedeoAssetAudio) {
                        
                        currentTime = CMTimeSubtract(bgPresentationtTime, audioBeginTime);
                        if (currentTime.value < 0) {
                            CFRelease(bgAssetBuffer);
                            return;
                        }
                    }
                    
                    if (currentTime.value > audioDuration.value) {
                        CFRelease(bgAssetBuffer);
                        [audioTrackInput markAsFinished];
                        dispatch_group_leave(dispatchGroup);
                        return;
                    }
                    
                    CMItemCount count;
                    CMSampleBufferGetSampleTimingInfoArray(bgAssetBuffer, 0, nil, &count);
                    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
                    CMSampleBufferGetSampleTimingInfoArray(bgAssetBuffer, count, pInfo, &count);
                    for (CMItemCount i = 0; i < count; i++)
                    {
                        pInfo[i].decodeTimeStamp = currentTime; // kCMTimeInvalid if in sequence
                        pInfo[i].presentationTimeStamp = currentTime;

                    }
                    CMSampleBufferRef sout;
                    CMSampleBufferCreateCopyWithNewTiming(kCFAllocatorDefault, bgAssetBuffer, count, pInfo, &sout);
                    free(pInfo);
                    
                    [audioTrackInput appendSampleBuffer:sout];
                    CFRelease(bgAssetBuffer);
                } else {
                    [audioTrackInput markAsFinished];
                    dispatch_group_leave(dispatchGroup);
                }
            }
        }];
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        [self.assetReader cancelReading];
        [self.audioReader cancelReading];
        [self.foregroundReaders makeObjectsPerformSelector:@selector(cancelReading)];
        
        if (self.assetWriter.status == 3 || self.assetWriter.status == 4) {
            completion(self.assetWriter.error);
            return;
        }
        
        [self.assetWriter finishWritingWithCompletionHandler:^{
            NT_STRONGIFY(self);
            if (self.assetWriter.status == AVAssetWriterStatusCompleted && self.isSaveAlbum) {
                [self fe_saveToAlbumCompletion:completion];
            }else {
                completion(self.assetWriter.error);
            }
        }];
    });
}

- (void)fe_writeWithDuration:(CMTime)duration
                       image:(UIImage *)image
                  audioAsset:(AVAsset *)audioAsset
               progressBlock:(void(^)(float progress))progressBlock
                  completion:(FEExportCompletionBlock)completion {
    
    [self _fe_cancelWriter];

    self.completionBlock = completion;
    __block NSError *outError = nil;
        
    #pragma mark - writer
    NSURL *writeUrl = [NSURL fileURLWithPath:self.outputPath];
    _assetWriter = [[AVAssetWriter alloc] initWithURL:writeUrl fileType:AVFileTypeMPEG4 error:&outError];
    if (outError) {
        completion(outError);
        return;
    }
    CGSize assetSize = image.size;
//    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:assetSize.width * assetSize.height * 4], AVVideoAverageBitRateKey, nil];

    CGFloat width = assetSize.width;
    CGFloat height = assetSize.height;
    if (!CGSizeEqualToSize(CGSizeZero, _exportSize)) {
        width = _exportSize.width;
        height = _exportSize.height;
    }
    
    NSDictionary *videoCompressionProps = @{
            AVVideoAverageBitRateKey:[NSNumber numberWithDouble:assetSize.width * assetSize.height * 4],
            AVVideoExpectedSourceFrameRateKey:@(30),
            AVVideoMaxKeyFrameIntervalKey:@(1)
    };
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecTypeH264,
                                    AVVideoWidthKey: @(width),
                                    AVVideoHeightKey: @(height),
                                    AVVideoCompressionPropertiesKey: videoCompressionProps};
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    writerInput.expectsMediaDataInRealTime = YES;
    writerInput.mediaTimeScale = self.videoAsset.duration.timescale;
    [_assetWriter addInput:writerInput];
    
    NSDictionary *pixelBufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:pixelBufferAttributes];
    
    AVAssetWriterInput *audioTrackInput = nil;
    
    BOOL isViedeoAssetAudio = audioAsset == nil;
    if (isViedeoAssetAudio) {
        audioAsset = self.videoAsset;
    }
    #pragma mark - audio
    if (audioAsset) {
        
        
        _audioReader = [[AVAssetReader alloc] initWithAsset:audioAsset error:&outError];
        if (outError) {
            completion(outError);
            return;
        }
        
        AVAssetTrack *audioTrack = [FEVideoCommonService fe_firstTrackWithAsset:audioAsset mediaType:AVMediaTypeAudio];
        if (audioTrack) {
            _audioTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:@{(NSString*)AVFormatIDKey : @(kAudioFormatLinearPCM)}];
            [_audioReader addOutput:_audioTrackOutput];
        }
        
        if (_audioTrackOutput) {
            audioTrackInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self configAudioInput]];
            if ([_assetWriter canAddInput:audioTrackInput]) {
                [_assetWriter addInput:audioTrackInput];
            } else {
                audioTrackInput = nil;
            }
        }
    }
    
    #pragma mark - begin
    [_audioReader startReading];
    [_foregroundReaders makeObjectsPerformSelector:@selector(startReading)];

    [_assetWriter startWriting];
    [_assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);

    dispatch_queue_t dispatchQueue = dispatch_queue_create("fe.mediaInput.com", DISPATCH_QUEUE_SERIAL);
    
    CVPixelBufferRef buffer = image.or_pixelBuffer;

    NT_WEAKIFY(self);
    
    int __block frame = 0;
    double totalFrame = CMTimeGetSeconds(duration) * 30;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        if (weak_self.isPause == NO && writerInput.readyForMoreMediaData) {

            [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, (int32_t)30)];
            
            progressBlock(frame / (totalFrame));
            
            if(++frame >= (int)ceilf(totalFrame)) {
                [writerInput markAsFinished];
                dispatch_group_leave(dispatchGroup);
            }
        }
    }];
    
    if (audioTrackInput) {

        CMTimeScale scale = 44100;
        CMTime audioDuration = CMTimeConvertScale(duration, scale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        
        dispatch_group_enter(dispatchGroup);
        dispatch_queue_t dispatchAudioQueue = dispatch_queue_create("fe.audioInput.com", DISPATCH_QUEUE_SERIAL);
        
        [audioTrackInput requestMediaDataWhenReadyOnQueue:dispatchAudioQueue usingBlock:^{
            NT_STRONGIFY(self);
            if (self.isPause == NO && writerInput.readyForMoreMediaData) {

                CMSampleBufferRef bgAssetBuffer = [self.audioTrackOutput copyNextSampleBuffer];
                if (bgAssetBuffer) {
                    
                    CMTime bgPresentationtTime = CMSampleBufferGetPresentationTimeStamp(bgAssetBuffer);
                    
                    if (bgPresentationtTime.value > audioDuration.value) {
                        CFRelease(bgAssetBuffer);
                        [audioTrackInput markAsFinished];
                        dispatch_group_leave(dispatchGroup);
                        return;
                    }
                    
                    [audioTrackInput appendSampleBuffer:bgAssetBuffer];
                    CFRelease(bgAssetBuffer);
                } else {
                    [audioTrackInput markAsFinished];
                    dispatch_group_leave(dispatchGroup);
                }
            }
        }];
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        [self.assetReader cancelReading];
        [self.audioReader cancelReading];
        [self.foregroundReaders makeObjectsPerformSelector:@selector(cancelReading)];
        
        if (self.assetWriter.status == 3 || self.assetWriter.status == 4) {
            completion(self.assetWriter.error);
            return;
        }
        
        [self.assetWriter finishWritingWithCompletionHandler:^{
            NT_STRONGIFY(self);
            if (self.assetWriter.status == AVAssetWriterStatusCompleted && self.isSaveAlbum) {
                [self fe_saveToAlbumCompletion:completion];
            }else {
                completion(self.assetWriter.error);
            }
        }];
    });
    
}


- (UIImage *)_fe_imageWithBuffer:(CMSampleBufferRef)buffer {
    return [FEVideoCommonService fe_imageWithBuffer:buffer];
}

- (NSDictionary *)configAudioInput{
    AudioChannelLayout channelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = kAudioChannelBit_Left,
        .mNumberChannelDescriptions = 0
    };
    NSData *channelLayoutData = [NSData dataWithBytes:&channelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioInputSetting = @{
                                        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey: @(44100),
                                        AVNumberOfChannelsKey: @(2),
                                        AVChannelLayoutKey:channelLayoutData
                                        };
    return audioInputSetting;
}



@end



