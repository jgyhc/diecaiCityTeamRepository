//
//  UIView+NTAdd.h
//  RedEnvelopes
//
//  Created by YouLoft_MacMini on 16/3/9.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//typedef void(^NTAddViewBlock)(CGRect frame);

@interface UIView (NTAdd)

#pragma mark - fast property
@property (nonatomic) CGFloat nt_x;
@property (nonatomic) CGFloat nt_y;
@property (nonatomic) CGFloat nt_right;
@property (nonatomic) CGFloat nt_bottom;
@property (nonatomic) CGFloat nt_width;
@property (nonatomic) CGFloat nt_height;
@property (nonatomic) CGFloat nt_centerX;
@property (nonatomic) CGFloat nt_centerY;
@property (nonatomic) CGPoint nt_origin;
@property (nonatomic) CGSize  nt_size;
@property (nonatomic) CGFloat bottomFromSuperView;
@property (nonatomic) CGFloat rightFromSuperView;

#pragma mark - 设置分割线
@property(nonatomic, strong) UIColor *lineColor;
@property (nonatomic) BOOL showBottomLine;
@property (nonatomic) BOOL showTopLine;


@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIBezierPath *maskPath;

#pragma mark - snapshot (截图相关)
@property (nullable, nonatomic, readonly) UIImage *snapshotImage;
@property (nullable, nonatomic, readonly) CGImageRef snapshotImageRef;
@property (nullable, nonatomic, readonly) UIImage *snapshotAlphaImage;
@property (nullable, nonatomic, readonly) NSData *snapshotPDF;

- (UIImage *)nt_snapshotWithAlpha:(CGFloat)alpha size:(CGSize)size;

/**此方法截图比snapshotImage属性更快，但可能导致屏幕刷新，update：是否刷新屏幕后再截图*/
- (nullable UIImage *)nt_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (nullable UIImage *)fe_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates scale:(CGFloat)scale;
- (nullable UIImage *)fe_snapshotImageOpaque:(BOOL)opaque scale:(CGFloat)scale;

#pragma mark- border(阴影相关)
- (void)nt_borderWithColor:(UIColor *)color width:(CGFloat)width;

#pragma mark- shadow(阴影相关)
- (void)nt_shadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

#pragma mark - anchorPoint(锚点相关)
- (void)nt_anchorPointChangedToPoint:(CGPoint)point;

#pragma mark - other
- (void)nt_removeAllSubviews;

/**返回管理着该视图的控制器(包括管理该视图父视图级别的控制器)，可为nil*/
@property (nullable, nonatomic, readonly) UIViewController *nt_viewController;
/**可视透明度，值由自身hidden和alpha以及父视图的hidden和alpha决定*/
@property (nonatomic, readonly) CGFloat visibleAlpha;
/**触摸屏幕时先结束编辑*/
//@property (nonatomic, assign) BOOL endEditingBeforTouch;
/**触摸时回调的block*/
//@property (nonatomic, copy) void(^touchBlock)(UIView *touchView);
/**扩大View的可点击区域，比如设置（10，10，10，10）则该view周围10的范围内依然可判定为view可以响应的点击区域*/
@property (nonatomic, assign) UIEdgeInsets externalTouchInset;

/**返回一个临时视图，一般用于辅助layer的布局，因为layer无法使用自动布局*/
//+ (instancetype)nt_tempViewForFrameWithBlock:(NTAddViewBlock)block;


#pragma mark - 圆角

/**
 设置一个四角圆角
 
 @param radius 圆角半径
 @param color  圆角背景色
 */
- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color;

/**
 设置一个普通圆角
 
 @param radius  圆角半径
 @param color   圆角背景色
 @param corners 圆角位置
 */
- (void)nt_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners;

/**
 设置一个带边框的圆角
 
 @param cornerRadii 圆角半径cornerRadii
 @param color       圆角背景色
 @param corners     圆角位置
 @param borderColor 边框颜色
 @param borderWidth 边框线宽
 */
- (void)nt_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (UIViewController *)parentViewController;

@end
NS_ASSUME_NONNULL_END
