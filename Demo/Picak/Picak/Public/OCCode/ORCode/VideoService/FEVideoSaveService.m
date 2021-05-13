//
//  FEVideoSaveService.m
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/4/17.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEVideoSaveService.h"
#import "FEVideoCommonService.h"

@interface FEVideoSaveService ()

//@property (nonatomic, strong) FEVideoCommonService *commonService;

@end

@implementation FEVideoSaveService


- (instancetype)initWithVideoAsset:(AVAsset *)videoAsset outputPath:(NSString *)outputPath
{
    self = [super init];
    if (self) {
        _videoAsset = videoAsset;
        unlink(outputPath.UTF8String);
        _outputPath = outputPath;
        _isSaveAlbum = NO;
    }
    return self;
}

- (void)fe_saveToAlbumCompletion:(FEExportCompletionBlock)completion {
    [FEVideoCommonService fe_saveAssetToPhotoWithPath:self.outputPath completion:^(NSError * _Nullable error, NSString * _Nonnull identifier) {
        self->_localIdentifer = identifier;
        if (completion) {
            completion(error);
        }
    }];
//    [self.commonService fe_saveAssetToPhotoWithPath:self.outputPath completion:completion];
}

//- (FEVideoCommonService *)commonService {
//    if (!_commonService) {
//        _commonService = [FEVideoCommonService new];
//    }
//    return _commonService;
//}

@end
