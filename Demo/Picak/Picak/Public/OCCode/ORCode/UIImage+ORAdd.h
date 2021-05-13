//
//  UIImage+ORAdd.h
//  FlyingEffects
//
//  Created by 欧阳荣 on 2020/3/31.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ORAdd)

- (NSData *)or_compressQualityWithMaxLength:(NSInteger)maxLength;
- (nullable UIImage *)or_imageByResizeToSize:(CGSize)size;


- (UIImage *)or_upImage;
- (CVPixelBufferRef)or_pixelBuffer;
- (CVPixelBufferRef)bgraPixelBuffer;
- (UIImage *)or_imageWithBrightness:(CGFloat)brightness;

+ (UIImage *)bufferImageCreateWithSampleBuffer:(CMSampleBufferRef)sampleBuffer imageOrientation:(UIImageOrientation)orientation;
+ (UIImage *)bufferImageCreateWithPixelBuffer:(CVPixelBufferRef)pixelBuffer imageOrientation:(UIImageOrientation)orientation;

- (UIImage *)or_addCornerRadius:(CGFloat)radius;
- (UIImage *)or_allCornerImage;
@end

NS_ASSUME_NONNULL_END
