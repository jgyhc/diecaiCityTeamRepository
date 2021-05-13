//
//  FEVideoSaveService.h
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/4/17.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FEVideoCommonService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FEExportCompletionBlock)(NSError * _Nullable error);

@interface FEVideoSaveService : NSObject

@property (nonatomic, assign) BOOL isSaveAlbum;
@property (nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic, copy) NSString *outputPath;

//save success
@property (nonatomic, readonly) NSString *localIdentifer;

- (instancetype)initWithVideoAsset:(AVAsset *_Nullable)videoAsset outputPath:(NSString *)outputPath;

- (void)fe_saveToAlbumCompletion:(FEExportCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
