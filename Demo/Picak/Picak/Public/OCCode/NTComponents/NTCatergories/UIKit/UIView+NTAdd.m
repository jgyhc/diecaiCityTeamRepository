//
//  UIView+NTAdd.m
//  RedEnvelopes
//
//  Created by YouLoft_MacMini on 16/3/9.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIView+NTAdd.h"
#import "CALayer+NTAdd.h"
#import "UIColor+NTAdd.h"
#import "NSObject+NTAdd.h"
#import <objc/runtime.h>
#import "NTCGUtilities.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIView_NTAdd)

@implementation UIView (NTAdd)

+ (void)load{
    [self nt_swizzleInstanceMethod:@selector(layoutSublayersOfLayer:) with:@selector(_nt_layoutSublayersOfLayer:)];
//    [self nt_swizzleInstanceMethod:@selector(hitTest:withEvent:) with:@selector(_nt_hitTest:withEvent:)];
    [self nt_swizzleInstanceMethod:@selector(pointInside:withEvent:) with:@selector(_nt_pointInside:withEvent:)];
}

- (CGFloat)nt_x {
    return self.frame.origin.x;
}

- (void)setNt_x:(CGFloat)nt_x {
    CGRect frame = self.frame;
    frame.origin.x = nt_x;
    self.frame = frame;
}

- (CGFloat)nt_y {
    return self.frame.origin.y;
}

- (void)setNt_y:(CGFloat)nt_y {
    CGRect frame = self.frame;
    frame.origin.y = nt_y;
    self.frame = frame;
}

- (CGFloat)nt_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNt_right:(CGFloat)nt_right {
    CGRect frame = self.frame;
    frame.origin.x = nt_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)nt_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNt_bottom:(CGFloat)nt_bottom {
    CGRect frame = self.frame;
    frame.origin.y = nt_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)nt_width {
    return self.bounds.size.width;
}

- (void)setNt_width:(CGFloat)nt_width {
    CGRect bounds = self.bounds;
    bounds.size.width = nt_width;
    self.bounds = bounds;
}

- (CGFloat)nt_height {
    return self.bounds.size.height;
}

- (void)setNt_height:(CGFloat)nt_height {
    CGRect bounds = self.bounds;
    bounds.size.height = nt_height;
    self.bounds = bounds;
}

- (CGFloat)nt_centerX {
    return self.center.x;
}

- (void)setNt_centerX:(CGFloat)nt_centerX {
    self.center = CGPointMake(nt_centerX, self.center.y);
}

- (CGFloat)nt_centerY {
    return self.center.y;
}

- (void)setNt_centerY:(CGFloat)nt_centerY {
    self.center = CGPointMake(self.center.x, nt_centerY);
}

- (CGPoint)nt_origin {
    return self.frame.origin;
}

- (void)setNt_origin:(CGPoint)nt_origin {
    CGRect frame = self.frame;
    frame.origin = nt_origin;
    self.frame = frame;
}

- (CGSize)nt_size {
    return self.bounds.size;
}

- (void)setNt_size:(CGSize)nt_size {
    CGRect bounds = self.bounds;
    bounds.size = nt_size;
    self.bounds = bounds;
}

- (CGFloat)rightFromSuperView{
    if (!self.superview) return 0;
    return self.superview.nt_width - self.nt_right;
}

- (void)setRightFromSuperView:(CGFloat)rightFromSuperView{
    if (!self.superview) return;
    self.nt_y = self.superview.nt_width - self.nt_width - rightFromSuperView;
}

- (CGFloat)bottomFromSuperView{
    if (!self.superview) return 0;
    return self.superview.nt_height - self.nt_bottom;
}

- (void)setBottomFromSuperView:(CGFloat)bottomFromSuperView{
    if (!self.superview) return;
    self.nt_y = self.superview.nt_height - self.nt_height - bottomFromSuperView;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (UIImage *)contentImage{
    return self.layer.contentImage;
}

- (void)setContentImage:(UIImage *)contentImage{
    self.layer.contentImage = contentImage;
}

- (UIBezierPath *)maskPath{
    return self.layer.maskPath;
}

- (void)setMaskPath:(UIBezierPath *)maskPath{
    self.layer.maskPath = maskPath;
}

- (void)nt_borderWithColor:(UIColor *)color width:(CGFloat)width{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setEndEditingBeforTouch:(BOOL)nt_endEditingBeforTouch{
    [self nt_setAssociateValue:@(nt_endEditingBeforTouch) withKey:"nt_endEditingBeforTouch"];
}

- (void)setTouchBlock:(void (^)(UIView * _Nonnull))touchBlock{
    [self nt_setAssociateCopyValue:touchBlock withKey:"nt_touchBlock"];
}

- (BOOL)endEditingBeforTouch{
    return [[self nt_getAssociatedValueForKey:"nt_endEditingBeforTouch"] boolValue];
}

- (void (^)(UIView * _Nonnull))touchBlock{
    return [self nt_getAssociatedValueForKey:"nt_touchBlock"];
    
}

//+ (instancetype)nt_tempViewForFrameWithBlock:(NTAddViewBlock)block{
//    UIView *view = [self new];
//    [view.layer nt_setAssociateValue:block withKey:"NTAddViewBlock"];
//    return view;
//}

- (void)setExternalTouchInset:(UIEdgeInsets)externalTouchInset{
    [self nt_setAssociateValue:[NSValue valueWithUIEdgeInsets:externalTouchInset] withKey:"nt_externalTouchInset"];
}

- (UIEdgeInsets)externalTouchInset{
    return [[self nt_getAssociatedValueForKey:"nt_externalTouchInset"] UIEdgeInsetsValue];
}

- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (UIImage *)snapshotImage {
    return [self nt_snapshotWithAlpha:self.opaque size:self.bounds.size];
}

- (CGImageRef)snapshotImageRef {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 4);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRef cgImage2 = CGBitmapContextCreateImage(ctx);
    UIGraphicsEndImageContext();
    return cgImage2;
}

- (UIImage *)snapshotAlphaImage{
    return [self nt_snapshotWithAlpha:0 size:self.bounds.size];
}

- (UIImage *)nt_snapshotWithAlpha:(CGFloat)alpha size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, alpha, 4);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRef cgImage2 = CGBitmapContextCreateImage(ctx);
    UIImage *snap = [UIImage imageWithCGImage:cgImage2];
    CGImageRelease(cgImage2);
//    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)nt_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates{
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 4);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)fe_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates scale:(CGFloat)scale {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    
    CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width * scale, self.bounds.size.height * scale);

    UIGraphicsBeginImageContextWithOptions(size, self.opaque, scale);
    [self drawViewHierarchyInRect:rect afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)fe_snapshotImageOpaque:(BOOL)opaque scale:(CGFloat)scale {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width * scale, self.bounds.size.height * scale);

    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)nt_shadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    [self.layer nt_shadowWithColor:color offset:offset radius:radius];
}

- (void)nt_anchorPointChangedToPoint:(CGPoint)point {
    [self.layer nt_anchorPointChangedToPoint:point];
}

- (void)nt_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIViewController *)nt_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (void)setLineColor:(UIColor *)lineColor{
    lineColor = lineColor ?: NT_HEX(e5e5e5);
    [self nt_setAssociateValue:lineColor withKey:"nt_lineColor"];
}

- (UIColor *)lineColor{
    return [self nt_getAssociatedValueForKey:"nt_lineColor"] ?: NT_HEX(e5e5e5);
}

- (void)setShowTopLine:(BOOL)showTopLine{
    UIView *topLine = [self nt_getAssociatedValueForKey:"nt_topLine"];
    if (showTopLine) {
        if (!topLine) {
            UIView *topLine = [UIView new];
            topLine.backgroundColor = self.lineColor;
            [self addSubview:topLine];
            [self nt_setAssociateValue:topLine withKey:"nt_topLine"];
            if (CGRectEqualToRect(CGRectZero, self.frame)) {
                topLine.frame = CGRectMake(0, 0, self.nt_width, 0.5);
            }
        }else{
            topLine.hidden = NO;
        }
    }else{
        topLine.hidden = YES;
    }
}

- (BOOL)showTopLine{
    UIView *topLine = [self nt_getAssociatedValueForKey:"nt_topLine"];
    return (topLine && topLine.hidden == NO);
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    UIView *bottomLine = [self nt_getAssociatedValueForKey:"nt_bottomLine"];
    if (showBottomLine) {
        if (!bottomLine) {
            UIView *bottomLine = [UIView new];
            bottomLine.backgroundColor = self.lineColor;
            [self addSubview:bottomLine];
            [self nt_setAssociateValue:bottomLine withKey:"nt_bottomLine"];
            if (CGRectEqualToRect(CGRectZero, self.frame)) {
                bottomLine.frame = CGRectMake(0, self.nt_height - 0.5, self.nt_width, 0.5);
            }
        }else{
            bottomLine.hidden = NO;
        }
    }else{
        bottomLine.hidden = YES;
    }
}

- (BOOL)showBottomLine{
    UIView *bottomLine = [self nt_getAssociatedValueForKey:"nt_bottomLine"];
    return (bottomLine && bottomLine.hidden == NO);
}

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self.layer nt_roundedCornerWithRadius:radius cornerColor:color];
}

- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self.layer nt_roundedCornerWithRadius:radius cornerColor:color corners:corners];
}

- (void)nt_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self.layer nt_roundedCornerWithCornerRadii:cornerRadii cornerColor:color corners:corners borderColor:borderColor borderWidth:borderWidth];
}



#pragma mark - exchanged methods

- (void)_nt_layoutSublayersOfLayer:(CALayer *)layer{
    [self _nt_layoutSublayersOfLayer:layer];
//    NTAddViewBlock block = [layer nt_getAssociatedValueForKey:"NTAddViewBlock"];
//    if (block) {
//        block(self.frame);
//        block = nil;
//        objc_removeAssociatedObjects(layer);
//        [self removeFromSuperview];
//    }
    UIView *bottomLine = [self nt_getAssociatedValueForKey:"nt_bottomLine"];
    if (bottomLine) {
        bottomLine.frame = CGRectMake(0, self.nt_height - 0.5, self.nt_width, 0.5);
    }
    
    UIView *topLine = [self nt_getAssociatedValueForKey:"nt_topLine"];
    if (topLine) {
        topLine.frame = CGRectMake(0, 0, self.nt_width, 0.5);
    }
}

- (BOOL)_nt_pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (UIEdgeInsetsEqualToEdgeInsets(self.externalTouchInset, UIEdgeInsetsZero)) {
        return [self _nt_pointInside:point withEvent:event];
    }
    CGRect externalFrame = CGRectMake(-self.externalTouchInset.left, -self.externalTouchInset.top, self.nt_width + (self.externalTouchInset.left + self.externalTouchInset.right), self.nt_height + self.externalTouchInset.top + self.externalTouchInset.bottom);
    return CGRectContainsPoint(externalFrame, point);
    
}

//- (UIView *)_nt_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *view = [self _nt_hitTest:point withEvent:event];
//    NT_BLOCK(self.touchBlock, view);
//    return view;
//}

- (UIViewController *)parentViewController{
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
