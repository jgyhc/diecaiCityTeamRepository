//
//  CALayer+NTAdd.m
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/1/28.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "CALayer+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "UIImage+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(CALayer_NTAdd)

static void *const _kCALayerNTaddMaskCornerRadiusLayerKey = "com.nineton.calayer.ntadd.maskcornerradiuslayerkey";
static NSMutableSet<UIImage *> *maskCornerRaidusImageSet;

@implementation CALayer (NTAdd)

+ (void)load{
    [CALayer nt_swizzleInstanceMethod:@selector(layoutSublayers) with:@selector(_nt_layoutSublayers)];
}


- (UIImage *)nt_snapshotImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)nt_snapshotPDF{
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)nt_shadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius{
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)nt_removeAllSublayers{
    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)nt_shakeInXWithDistace:(CGFloat)distance repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration{
    [self removeAnimationForKey:@"nt_shakeInXWithDistace"];
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.translation.x";
    anim.values=@[@(0), @(distance),@(0),@(-distance), @(0)];
    anim.repeatCount = count;
    anim.duration = duration;
    [self addAnimation:anim forKey:@"nt_shakeInXWithDistace"];
}

- (void)nt_shakeInYWithDistace:(CGFloat)distance repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration{
    [self removeAnimationForKey:@"nt_shakeInYWithDistace"];
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.translation.y";
    anim.values=@[@(0), @(distance),@(0),@(-distance), @(0)];
    anim.repeatCount = count;
    anim.duration = duration;
    [self addAnimation:anim forKey:@"nt_shakeInYWithDistace"];
}

- (void)nt_rotationInZWithAngle:(CGFloat)angle repeatCount:(NSUInteger)count duration:(NSTimeInterval)duration{
    [self removeAnimationForKey:@"nt_rotationInZWithAngle"];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.fromValue = @(0);
    anim.toValue = @(angle);
    anim.duration = duration;
    anim.repeatCount = count;
    [self addAnimation:anim forKey:@"nt_rotationInZWithAngle"];
}

- (CGFloat)nt_x{
    return self.frame.origin.x;
}

- (void)setNt_x:(CGFloat)nt_x{
    CGRect frame = self.frame;
    frame.origin.x = nt_x;
    self.frame = frame;
}

- (CGFloat)nt_y{
    return self.frame.origin.y;
}

- (void)setNt_y:(CGFloat)nt_y{
    CGRect frame = self.frame;
    frame.origin.y = nt_y;
    self.frame = frame;
}

- (CGFloat)nt_right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNt_right:(CGFloat)nt_right{
    CGRect frame = self.frame;
    frame.origin.x = nt_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)nt_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNt_bottom:(CGFloat)nt_bottom{
    CGRect frame = self.frame;
    frame.origin.y = nt_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)nt_width{
    return self.bounds.size.width;
}

- (void)setNt_width:(CGFloat)nt_width{
    CGRect bounds = self.bounds;
    bounds.size.width = nt_width;
    self.bounds = bounds;
}

- (CGFloat)nt_height{
    return self.bounds.size.height;
}

- (void)setNt_height:(CGFloat)nt_height{
    CGRect bounds = self.bounds;
    bounds.size.height = nt_height;
    self.bounds = bounds;
}

- (CGPoint)nt_center{
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setNt_center:(CGPoint)nt_center {
    CGRect frame = self.frame;
    frame.origin.x = nt_center.x - frame.size.width * 0.5;
    frame.origin.y = nt_center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)nt_centerX{
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setNt_centerX:(CGFloat)nt_centerX{
    CGRect frame = self.frame;
    frame.origin.x = nt_centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)nt_centerY{
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setNt_centerY:(CGFloat)nt_centerY{
    CGRect frame = self.frame;
    frame.origin.y = nt_centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)nt_origin{
    return self.frame.origin;
}

- (void)setNt_origin:(CGPoint)nt_origin{
    CGRect frame = self.frame;
    frame.origin = nt_origin;
    self.frame = frame;
}

- (CGSize)nt_size{
    return self.frame.size;
}

- (void)setNt_size:(CGSize)nt_size{
    CGRect frame = self.frame;
    frame.size = nt_size;
    self.frame = frame;
}

- (CGFloat)transformRotation{
    NSNumber *v = [self valueForKeyPath:@"transform.rotation"];
    return v.doubleValue;
}

- (void)setTransformRotation:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.rotation"];
}

- (CGFloat)transformRotationX{
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.x"];
    return v.doubleValue;
}

- (void)setTransformRotationX:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.rotation.x"];
}

- (CGFloat)transformRotationY{
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.y"];
    return v.doubleValue;
}

- (void)setTransformRotationY:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.rotation.y"];
}

- (CGFloat)transformRotationZ{
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.z"];
    return v.doubleValue;
}

- (void)setTransformRotationZ:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.rotation.z"];
}

- (CGFloat)transformScaleX{
    NSNumber *v = [self valueForKeyPath:@"transform.scale.x"];
    return v.doubleValue;
}

- (void)setTransformScaleX:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.scale.x"];
}

- (CGFloat)transformScaleY{
    NSNumber *v = [self valueForKeyPath:@"transform.scale.y"];
    return v.doubleValue;
}

- (void)setTransformScaleY:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.scale.y"];
}

- (CGFloat)transformScaleZ{
    NSNumber *v = [self valueForKeyPath:@"transform.scale.z"];
    return v.doubleValue;
}

- (void)setTransformScaleZ:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.scale.z"];
}

- (CGFloat)transformScale{
    NSNumber *v = [self valueForKeyPath:@"transform.scale"];
    return v.doubleValue;
}

- (void)setTransformScale:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.scale"];
}

- (CGFloat)transformTranslationX{
    NSNumber *v = [self valueForKeyPath:@"transform.translation.x"];
    return v.doubleValue;
}

- (void)setTransformTranslationX:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.translation.x"];
}

- (CGFloat)transformTranslationY{
    NSNumber *v = [self valueForKeyPath:@"transform.translation.y"];
    return v.doubleValue;
}

- (void)setTransformTranslationY:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.translation.y"];
}

- (CGFloat)transformTranslationZ{
    NSNumber *v = [self valueForKeyPath:@"transform.translation.z"];
    return v.doubleValue;
}

- (void)setTransformTranslationZ:(CGFloat)v{
    [self setValue:@(v) forKeyPath:@"transform.translation.z"];
}

- (CGFloat)m34 {
    return self.transform.m34;
}

- (void)setM34:(CGFloat)v {
    CATransform3D d = self.transform;
    d.m34 = v;
    self.transform = d;
}

- (UIImage *)contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setContentImage:(UIImage *)contentImage{
    self.contents = (__bridge id)contentImage.CGImage;
}

- (UIBezierPath *)maskPath{
    CAShapeLayer *maskLayer = (CAShapeLayer *)self.mask;
    if ([maskLayer isKindOfClass:[CAShapeLayer class]]) {
        return [UIBezierPath bezierPathWithCGPath:maskLayer.path];
    }
    return nil;
}

- (void)setMaskPath:(UIBezierPath *)maskPath{
    CAShapeLayer *maskLayer = (CAShapeLayer *)self.mask;
    if (![maskLayer isKindOfClass:[CAShapeLayer class]]) {
        maskLayer = [CAShapeLayer new];
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
    }
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}

- (void)nt_anchorPointChangedToPoint:(CGPoint)point {
    self.nt_x += (point.x - self.anchorPoint.x) * self.nt_width;
    self.nt_y += (point.y - self.anchorPoint.y) * self.nt_height;
    self.anchorPoint = point;
}

- (void)nt_anchorPointChangedTotopLeft {
    [self nt_anchorPointChangedToPoint:CGPointMake(0, 0)];
}

- (void)nt_anchorPointChangedTotopCenter {
    [self nt_anchorPointChangedToPoint:CGPointMake(0.5, 0)];
}

- (void)nt_anchorPointChangedToTopRight {
    [self nt_anchorPointChangedToPoint:CGPointMake(1, 0)];
}

- (void)nt_anchorPointChangedToMidLeft {
    [self nt_anchorPointChangedToPoint:CGPointMake(0, 0.5)];
}

- (void)nt_anchorPointChangedToMidCenter {
    [self nt_anchorPointChangedToPoint:CGPointMake(0.5, 0.5)];
}

- (void)nt_anchorPointChangedToMidRight {
    [self nt_anchorPointChangedToPoint:CGPointMake(1, 0.5)];
}

- (void)nt_anchorPointChangedToBottomLeft {
    [self nt_anchorPointChangedToPoint:CGPointMake(0, 1)];
}

- (void)nt_anchorPointChangedToBottomCenter {
    [self nt_anchorPointChangedToPoint:CGPointMake(0.5, 1)];
}

- (void)nt_anchorPointChangedToBottomRight {
    [self nt_anchorPointChangedToPoint:CGPointMake(1, 1)];
}

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self nt_roundedCornerWithRadius:radius cornerColor:color corners:UIRectCornerAllCorners];
}

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self nt_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:color corners:corners borderColor:nil borderWidth:0];
}

- (void)nt_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    if (!color) return;
    CALayer *cornerRadiusLayer = [self nt_getAssociatedValueForKey:_kCALayerNTaddMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self nt_setAssociateValue:cornerRadiusLayer withKey:_kCALayerNTaddMaskCornerRadiusLayerKey];
    }
    if (color) {
        [cornerRadiusLayer nt_setAssociateValue:color withKey:"_nt_cornerRadiusImageColor"];
    }else{
        [cornerRadiusLayer nt_removeAssociateWithKey:"_nt_cornerRadiusImageColor"];
    }
    [cornerRadiusLayer nt_setAssociateValue:[NSValue valueWithCGSize:cornerRadii] withKey:"_nt_cornerRadiusImageRadius"];
    [cornerRadiusLayer nt_setAssociateValue:@(corners) withKey:"_nt_cornerRadiusImageCorners"];
    if (borderColor) {
        [cornerRadiusLayer nt_setAssociateValue:borderColor withKey:"_nt_cornerRadiusImageBorderColor"];
    }else{
        [cornerRadiusLayer nt_removeAssociateWithKey:"_nt_cornerRadiusImageBorderColor"];
    }
    [cornerRadiusLayer nt_setAssociateValue:@(borderWidth) withKey:"_nt_cornerRadiusImageBorderWidth"];
    UIImage *image = [self _nt_getCornerRadiusImageFromSet];
    if (image) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = image;
        [CATransaction commit];
    }
    
}

- (UIImage *)_nt_getCornerRadiusImageFromSet{
    if (!self.bounds.size.width || !self.bounds.size.height) return nil;
    CALayer *cornerRadiusLayer = [self nt_getAssociatedValueForKey:_kCALayerNTaddMaskCornerRadiusLayerKey];
    UIColor *color = [cornerRadiusLayer nt_getAssociatedValueForKey:"_nt_cornerRadiusImageColor"];
    if (!color) return nil;
    CGSize radius = [[cornerRadiusLayer nt_getAssociatedValueForKey:"_nt_cornerRadiusImageRadius"] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer nt_getAssociatedValueForKey:"_nt_cornerRadiusImageCorners"] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer nt_getAssociatedValueForKey:"_nt_cornerRadiusImageBorderWidth"] floatValue];
    UIColor *borderColor = [cornerRadiusLayer nt_getAssociatedValueForKey:"_nt_cornerRadiusImageBorderColor"];
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGSize imageSize = [[obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageSize"] CGSizeValue];
        UIColor *imageColor = [obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageColor"];
        CGSize imageRadius = [[obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageRadius"] CGSizeValue];
        NSUInteger imageCorners = [[obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageCorners"] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageBorderWidth"] floatValue];
        UIColor *imageBorderColor = [obj nt_getAssociatedValueForKey:"_nt_cornerRadiusImageBorderColor"];
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) && borderWidth == imageBorderWidth) || (!borderColor && !imageBorderColor) || (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) && CGColorEqualToColor(imageColor.CGColor, color.CGColor) && imageCorners == corners && CGSizeEqualToSize(radius, imageRadius) && isBorderSame;
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        image = [UIImage nt_maskRoundCornerRadiusImageWithColor:color cornerRadii:radius size:self.bounds.size corners:corners borderColor:borderColor borderWidth:borderWidth];
        [image nt_setAssociateValue:[NSValue valueWithCGSize:self.bounds.size] withKey:"_nt_cornerRadiusImageSize"];
        [image nt_setAssociateValue:color withKey:"_nt_cornerRadiusImageColor"];
        [image nt_setAssociateValue:[NSValue valueWithCGSize:radius] withKey:"_nt_cornerRadiusImageRadius"];
        [image nt_setAssociateValue:@(corners) withKey:"_nt_cornerRadiusImageCorners"];
        if (borderColor) {
            [image nt_setAssociateValue:color withKey:"_nt_cornerRadiusImageBorderColor"];
        }
        [image nt_setAssociateValue:@(borderWidth) withKey:"_nt_cornerRadiusImageBorderWidth"];
        [maskCornerRaidusImageSet addObject:image];
    }
    return image;
}

#pragma mark - exchage Methods

- (void)_nt_layoutSublayers{
    [self _nt_layoutSublayers];
    CALayer *cornerRadiusLayer = [self nt_getAssociatedValueForKey:_kCALayerNTaddMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        UIImage *aImage = [self _nt_getCornerRadiusImageFromSet];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = aImage;
        cornerRadiusLayer.frame = self.bounds;
        [CATransaction commit];
        [self addSublayer:cornerRadiusLayer];
    }
}

@end
