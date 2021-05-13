//
//  FEVideoWriteService.h
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/4/17.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEVideoSaveService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FEWriteAssetProtocol <NSObject>

@property (nonatomic) NSTimeInterval beginTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) AVAsset *asset;
@property (nonatomic) NSString *filePath;
@property (nonatomic) NSString *key;

@end

typedef CVPixelBufferRef _Nonnull(^FEWriteBufferBlock)(UIImage* bgImage, NSDictionary *foreBufferInfo, float progress);
typedef CVPixelBufferRef _Nonnull(^FEWriteSingleBufferBlock)(UIImage* assetImage, float progress);

@interface FEVideoWriteService : FEVideoSaveService

@property (nonatomic, copy) UIImage *customBgImage;
@property (nonatomic, assign) BOOL needCutout;
@property (nonatomic, copy) NSString *_Nullable audioFile;
@property (nonatomic, assign) CGSize exportSize;

- (void)fe_writeWithBeginTime:(CMTime)beginTime
                      endTime:(CMTime)endTime
                   audioAsset:(AVAsset * _Nullable)audioAsset
             writeBufferBlock:(FEWriteSingleBufferBlock)writeBufferBlock
                   completion:(FEExportCompletionBlock)completion;

- (void)fe_writeWithDuration:(CMTime)duration
                       image:(UIImage *)image
                  audioAsset:(AVAsset * _Nullable)audioAsset
               progressBlock:(void(^)(float progress))progressBlock
                  completion:(FEExportCompletionBlock)completion;

@end

extern NSString *const kWriteVideoPathKey;
extern NSString *const kWriteBeginTimeKey;
extern NSString *const kWriteEndTimeKey;

NS_ASSUME_NONNULL_END
