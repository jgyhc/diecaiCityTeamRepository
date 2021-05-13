//
//  CALayer+NTAdd.h
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/1/28.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (NTAdd)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - snapShot(截图相关)

- (UIImage *)nt_snapshotImage;

- (NSData *)nt_snapshotPDF;

#pragma mark- shadow(阴影相关)

- (void)nt_shadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

#pragma mark - animation(动画相关)

- (void)nt_shakeInXWithDistace:(CGFloat)distance repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration;

- (void)nt_shakeInYWithDistace:(CGFloat)distance repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration;

- (void)nt_rotationInZWithAngle:(CGFloat)angle repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration;

#pragma mark - anchorPoint(锚点相关)

- (void)nt_anchorPointChangedToPoint:(CGPoint)point;

- (void)nt_anchorPointChangedTotopLeft;
- (void)nt_anchorPointChangedTotopCenter;
- (void)nt_anchorPointChangedToTopRight;
- (void)nt_anchorPointChangedToMidLeft;
- (void)nt_anchorPointChangedToMidCenter;
- (void)nt_anchorPointChangedToMidRight;
- (void)nt_anchorPointChangedToBottomLeft;
- (void)nt_anchorPointChangedToBottomCenter;
- (void)nt_anchorPointChangedToBottomRight;

#pragma mark - ohter

- (void)nt_removeAllSublayers;

#pragma mark -  fast property

@property (nonatomic) CGFloat nt_x;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat nt_y;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat nt_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat nt_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat nt_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat nt_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGPoint nt_center;      ///< Shortcut for center.
@property (nonatomic) CGFloat nt_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat nt_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint nt_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  nt_size; ///< Shortcut for frame.size.


@property (nonatomic) CGFloat transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic) CGFloat transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic) CGFloat transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic) CGFloat transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic) CGFloat transformScale;        ///< key path "tranform.scale"
@property (nonatomic) CGFloat transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic) CGFloat transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic) CGFloat transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic) CGFloat transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic) CGFloat transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic) CGFloat transformTranslationZ; ///< key path "tranform.translation.z"
@property (nonatomic) CGFloat m34; //, -1/1000 is a good value.It should be set before other transform shortcut."

@property (nonatomic, strong) UIImage *contentImage;//set image for layer content

@property (nonatomic, strong) UIBezierPath *maskPath;

#pragma mark - 圆角

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color;

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners;

- (void)nt_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


@end

NS_ASSUME_NONNULL_END
