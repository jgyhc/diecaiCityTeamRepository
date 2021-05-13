//
//  UIImage+NTAdd.h
//  WxSelected
//
//  Created by YouLoft_MacMini on 15/12/29.
//  Copyright © 2015年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIImage *NTImage(NSString *imageName);

@interface UIImage (NTAdd)

@property (nonatomic, readonly) BOOL hasAlphaChannel;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;
@property (nonatomic, readonly) CGSize scaleSize;

#pragma mark - image initailize (图片初始化相关)
+ (UIImage *)nt_maskRoundCornerRadiusImageWithColor:(UIColor *)color cornerRadii:(CGSize)cornerRadii size:(CGSize)size corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

+ (UIImage *)nt_centerPlaceHolderImageWithImageName:(NSString *)imageName placeHolderSize:(CGSize)placeHolderSize backColor:(UIColor *)backColor size:(CGSize)size key:(nullable NSString *)key;//key 为重用标识符，自己构建,没有则表示重新创建;


+ (UIImage *)nt_centerPlaceHolderImageWithCenterName:(NSAttributedString *)title backColor:(UIColor *)backColor size:(CGSize)size key:(nullable NSString *)key;//key 为重用标识符，自己构建,没有则表示重新创建

+ (UIImage *)nt_imageWithPDF:(id)dataOrPath;

+ (UIImage *)nt_imageWithPDF:(id)dataOrPath size:(CGSize)size;

+ (UIImage *)nt_imageWithEmoji:(NSString *)emoji size:(CGFloat)size;

/**尺寸默认1*1*/
+ (UIImage *)nt_imageWithColor:(UIColor *)color;

+ (UIImage *)nt_imageWithColor:(UIColor *)color size:(CGSize)size;

/**通过绘制block，绘制一张图片*/
+ (UIImage *)nt_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

#pragma mark - modify image (图片修改相关, 裁剪，缩放，旋转)
- (nullable UIImage *)nt_imageByResizeToSize:(CGSize)size;

- (nullable UIImage *)nt_imageByResizeToAspectFillSize:(CGSize)size;//将图片进行AspectFill后裁剪size大小


- (nullable UIImage *)nt_imageByCropToRect:(CGRect)rect;

- (nullable UIImage *)nt_imageByInsetEdge:(UIEdgeInsets)insets withColor:(nullable UIColor *)color;

- (nullable UIImage *)nt_imageByRoundCornerRadius:(CGFloat)radius;

- (nullable UIImage *)nt_imageByRoundCornerRadius:(CGFloat)radius showSize:(CGSize)size;

- (nullable UIImage *)nt_imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;

- (nullable UIImage *)nt_imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;

- (nullable UIImage *)nt_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

- (nullable UIImage *)nt_imageByRotateLeft90;

- (nullable UIImage *)nt_imageByRotateRight90;

- (nullable UIImage *)nt_imageByRotate180;

- (nullable UIImage *)nt_imageByFlipVertical;

- (nullable UIImage *)nt_imageByFlipHorizontal;

#pragma mark - effect image(给图片添加效果相关，如颜色、模糊等)
- (nullable UIImage *)nt_imageByShadowWithShadowColor:(UIColor *)shadowColor shadowInsets:(UIEdgeInsets)insets blur:(CGFloat)blur offset:(CGSize)offset;

- (nullable UIImage *)nt_imageByTintColor:(UIColor *)color;

- (nullable UIImage *)nt_imageByAlpha:(CGFloat)alpha;

- (nullable UIImage *)nt_addImage:(UIImage *)image;

- (nullable UIImage *)nt_imageByGrayscale;

- (nullable UIImage *)nt_imageByBlurSoft;

- (nullable UIImage *)nt_imageByBlurLight;

- (nullable UIImage *)nt_imageByBlurExtraLight;

- (nullable UIImage *)nt_imageByBlurDark;

- (nullable UIImage *)nt_imageByBlurWithTint:(UIColor *)tintColor;

- (nullable UIImage *)nt_imageByBlurRadius:(CGFloat)blurRadius
                              tintColor:(nullable UIColor *)tintColor
                               tintMode:(CGBlendMode)tintBlendMode
                             saturation:(CGFloat)saturation
                              maskImage:(nullable UIImage *)maskImage;

- (nullable UIImage *)nt_resizeableImageInCenter;

//马赛克化
- (UIImage *)nt_transToMosaicImageBlockLevel:(NSUInteger)level;

- (UIImage *)nt_scaleImageToFitScreenSize;

#pragma mark - save (图片保存)
- (void)nt_saveImageWithCompletionHandle:(void(^)(BOOL successed))completion;
- (BOOL)nt_saveToFilePath:(NSString *)filePath compressionQuality:(CGFloat)compressionQuality;//compressionQuality只用于jpg，1 best 0 lost

#pragma mark - 压缩
- (UIImage *)nt_compressToByte:(NSUInteger)maxLength;
//直接调用这个方法进行压缩体积,减小大小
- (UIImage *)nt_zip;

#pragma mark - 解码
- (UIImage *)nt_decode;
@end

NS_ASSUME_NONNULL_END
