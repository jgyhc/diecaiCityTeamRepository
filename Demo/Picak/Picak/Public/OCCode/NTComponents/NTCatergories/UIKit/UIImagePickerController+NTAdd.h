//
//  UIImagePickerController+NTAdd.h
//  WeChatBusinessTool
//
//  Created by wazrx on 16/8/31.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NTImagePickerType) {
    NTImagePickerTypeTakePhoto = 0,
    NTImagePickerTypeChooseFromAlbum
};

typedef NS_ENUM(NSUInteger , NTImagePickerShowErrorType) {
    NTImagePickerShowErrorTypeNoCamera = 0,
    NTImagePickerShowErrorTypeCannotSuppotTakePhoto,
};

@interface UIImagePickerController (NTAdd)
+ (void)nt_showImgaePickerWithType:(NTImagePickerType)type firstFrontCamera:(BOOL)userFront showConfig:(void(^)(UIImagePickerController * picker))showConfig completion:(void(^)(UIImage *selectImage))completion failed:(void(^)(NTImagePickerShowErrorType errorType))failed;

@end
