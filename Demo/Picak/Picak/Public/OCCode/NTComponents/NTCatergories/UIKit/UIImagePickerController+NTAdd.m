//
//  UIImagePickerController+NTAdd.m
//  WeChatBusinessTool
//
//  Created by wazrx on 16/8/31.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIImagePickerController+NTAdd.h"
#import "UIImage+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"
#import "NTCGUtilities.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


NT_SYNTH_DUMMY_CLASS(UIImagePickerController_NTAdd)

@interface _NTPickerDelegateObject : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^completion)(UIImage *selectImage);

@end

@implementation _NTPickerDelegateObject

- (void)dealloc{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (portraitImg.size.width > NT_SCREEN_WIDTH * NT_SCREEN_SCALE) {
        portraitImg = [portraitImg nt_imageByResizeToSize:CGSizeMake(NT_SCREEN_WIDTH * NT_SCREEN_SCALE, NT_SCREEN_WIDTH * NT_SCREEN_SCALE * portraitImg.size.height / portraitImg.size.width)];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NT_BLOCK(_completion, portraitImg);
    }else{
        NT_WEAKIFY(self);
        [picker dismissViewControllerAnimated:YES completion:^{
            NT_STRONGIFY(self);
            NT_BLOCK(self.completion, portraitImg);
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NT_BLOCK(_completion, nil);
    }else{
        NT_WEAKIFY(self);
        [picker dismissViewControllerAnimated:YES completion:^{
            NT_STRONGIFY(self);
            NT_BLOCK(self.completion, nil);
        }];
    }
}

@end

@implementation UIImagePickerController (NTAdd)

- (void)dealloc{
    NT_LOG(@"picker销毁了");
}


+ (void)nt_showImgaePickerWithType:(NTImagePickerType)type firstFrontCamera:(BOOL)userFront showConfig:(void(^)(UIImagePickerController * picker))showConfig completion:(void(^)(UIImage *selectImage))completion failed:(void(^)(NTImagePickerShowErrorType errorType))failed {
    UIImagePickerController *picker = [UIImagePickerController new];
    switch (type) {
        case NTImagePickerTypeTakePhoto: {
            if (![self _nt_isCameraAvailable]) {
                NT_BLOCK(failed, NTImagePickerShowErrorTypeNoCamera);
                return;
            }
            if (![self _nt_doesCameraSupportTakingPhotos]) {
                NT_BLOCK(failed, NTImagePickerShowErrorTypeCannotSuppotTakePhoto);
                return;
            }
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (userFront && [self _nt_isFrontCameraAvailable]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            
            break;
        }
        case NTImagePickerTypeChooseFromAlbum: {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            break;
        }
    }
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    picker.mediaTypes = mediaTypes;
    _NTPickerDelegateObject *obj = [_NTPickerDelegateObject new];
    obj.completion = completion;
    picker.delegate = obj;
    [picker nt_setAssociateValue:obj withKey:"nt_delegateObj"];
    NT_BLOCK(showConfig, picker);
}

+ (BOOL)_nt_isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)_nt_isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)_nt_doesCameraSupportTakingPhotos {
    return [self _nt_cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)_nt_cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

@end
