//
//  FEVideoExportService.h
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/3/18.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEVideoSaveService.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ORAnimationBlock)(CALayer * superLayer, dispatch_block_t completion);

@interface FEVideoExportService : FEVideoSaveService

@property (nonatomic, readonly) CGFloat progress;

- (void)fe_exportWithAnimationBlock:(ORAnimationBlock _Nullable)animationBlock completion:(FEExportCompletionBlock)completion;

- (void)fe_exportForRenderSize:(CGSize)renderSize videoFrame:(CGRect)videoFrame WithAnimationBlock:(ORAnimationBlock _Nullable)animationBlock completion:(FEExportCompletionBlock)completion;

- (void)fe_exportWithAudioAsset:(AVAsset *)audioAsset timeRange:(CMTimeRange)timeRange atTime:(CMTime)time completion:(FEExportCompletionBlock)completion;
- (void)fe_exportWithAudioAsset:(AVAsset *)audioAsset completion:(FEExportCompletionBlock)completion; //音频循环

- (void)fe_exportWithFreme:(int)frame completion:(FEExportCompletionBlock)completion;

//30fps
- (void)fe_exportWithTimeRange:(CMTimeRange)timeRange presetName:(NSString *)presetName completion:(FEExportCompletionBlock)completion;
- (void)fe_exportWithTimeRange:(CMTimeRange)timeRange completion:(FEExportCompletionBlock)completion;

//排重
- (void)fe_exportUpdateWithTimeRange:(CMTimeRange)timeRange
                         cropPercent:(float)cropPercent
                          coverImage:(UIImage *_Nullable)coverImage
                          presetName:(NSString *)presetName
                          completion:(FEExportCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END
