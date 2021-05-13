//
//  NTCGUtilities.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/16.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTCategoriesMacro.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Screen Ratio And Ratio Value
CGFloat NTScreenScale(void);

CGFloat NTScreenWidthRatio(void);

CGFloat NTScreenHeightRatio(void);

CGSize NTScreenSize(void);

CGRect NTScreenBounds(void);

CGPoint NTScreenCenter(void);

// main screen's scale
#ifndef NT_SCREEN_SCALE
#define NT_SCREEN_SCALE NTScreenScale()
#endif

// main screen's bounds
#ifndef NT_SCREEN_BOUNDS
#define NT_SCREEN_BOUNDS NTScreenBounds()
#endif

// main screen's size (portrait)
#ifndef NT_SCREEN_SIZE
#define NT_SCREEN_SIZE NTScreenSize()
#endif

#ifndef NT_SCREEN_CENTER
#define NT_SCREEN_CENTER NTScreenCenter()
#endif

// main screen's width (portrait)
#ifndef NT_SCREEN_WIDTH
#define NT_SCREEN_WIDTH NTScreenSize().width
#endif

// main screen's height (portrait)
#ifndef NT_SCREEN_HEIGHT
#define NT_SCREEN_HEIGHT NTScreenSize().height
#endif

// main screen's height (portrait)
#ifndef NT_WIDTH_RATIO
#define NT_WIDTH_RATIO NTScreenWidthRatio()
#endif

// main screen's height (portrait)
#ifndef NT_HEIGHT_RATIO
#define NT_HEIGHT_RATIO NTScreenHeightRatio()
#endif

static inline CGFloat NTWidthRatio(CGFloat number){
    return number * NTScreenWidthRatio();
}

static inline CGFloat NTHeightRatio(CGFloat number){
    return number * NTScreenHeightRatio();
}


static inline CGSize NTSizeMake(CGFloat width, CGFloat height){
    CGSize size; size.width = NTWidthRatio(width); size.height = NTWidthRatio(height); return size;
}

static inline CGSize NTSizeRatio(CGSize size){
    return NTSizeMake(size.width, size.height);
}

static inline CGPoint NTPointMake(CGFloat x, CGFloat y){
    CGPoint point; point.x = NTWidthRatio(x); point.y = NTWidthRatio(y); return point;
}

static inline CGPoint NTPointRatio(CGPoint point){
    return NTPointMake(point.x, point.y);
}

static inline CGRect NTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    CGRect rect;
    rect.origin.x = NTWidthRatio(x); rect.origin.y = NTWidthRatio(y);
    rect.size.width = NTWidthRatio(width); rect.size.height = NTWidthRatio(height);
    return rect;
}

static inline CGRect NTRectRatio(CGRect rect){
    return NTRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

static inline UIEdgeInsets NTEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
    UIEdgeInsets insets = {NTWidthRatio(top), NTWidthRatio(left), NTWidthRatio(bottom), NTWidthRatio(right)};
    return insets;
}

static inline UIEdgeInsets NTEdgeInsetsRatio(UIEdgeInsets edgeInsets){
    return NTEdgeInsetsMake(edgeInsets.top, edgeInsets.left, edgeInsets.bottom, edgeInsets.right);
}

#pragma mark - Bezier Methods
//插值公式 == 一阶贝塞尔
static inline CGFloat NTInterpolation(CGFloat from, CGFloat to, CGFloat ratio){
    return from + (to - from) * ratio;
}

static inline CGFloat NTTwoOrdreBezier(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat t){
    return powf(1 - t, 2) * p0 + 2 * t * (1 - t) * p1 + powf(t, 2) * p2;
}

static inline CGFloat NTThreeOrderBezier(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat p3, CGFloat t){
    return powf(1 - t, 3) * p0 + 3 * p1 * t * powf(1 - t, 2) + 3 * p2 * powf(t, 2) * (1 - t) + p3 * powf(t, 3);
}

static inline CGPoint NTPointOnOneOrderBezier(CGPoint p0, CGPoint p1, CGFloat t){
    return CGPointMake(NTInterpolation(p0.x, p1.x, t), NTInterpolation(p0.y, p1.y, t));
}

static inline CGPoint NTPointOnTwoOrderBezier(CGPoint p0, CGPoint p1, CGPoint p2 , CGFloat t){
    return CGPointMake(NTTwoOrdreBezier(p0.x, p1.x, p2.x, t), NTTwoOrdreBezier(p0.y, p1.y, p2.y, t));
}

static inline CGPoint NTPointOnThreeOrderBezier(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3 , CGFloat t){
    return CGPointMake(NTThreeOrderBezier(p0.x, p1.x, p2.x, p3.x, t), NTThreeOrderBezier(p0.x, p1.x, p2.x, p3.x, t));
}

#pragma mark - other methods
static inline CGRect NTBoundsOfFrame(CGRect frame){
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

static inline CGPoint NTCenterOfFrame(CGRect frame){
    return CGPointMake(frame.origin.x + frame.size.width / 2.0f, frame.origin.y + frame.size.height / 2.0f);
}

static inline CGPoint NTCenterOfSize(CGSize size){
    return CGPointMake(size.width / 2.0f, size.height / 2.0f);
}

static inline CGRect NTFrameWithCenterAndSize(CGPoint center, CGSize size){
    return CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
}
#if TARGET_OS_IOS
static inline BOOL NTIndexPathEqual(NSIndexPath *indexPath1, NSIndexPath *indexPath2){
    return indexPath1 && indexPath2 && indexPath1.item == indexPath2.item && indexPath1.section == indexPath2.section;
}
#endif

static inline UIEdgeInsets NTEdgeInsetsByOneValue(CGFloat value){
    return UIEdgeInsetsMake(value, value, value, value);
}

static inline UIEdgeInsets NTEdgeInsetsByTwoValue(CGFloat topAndBottom, CGFloat leftAndRight){
    return UIEdgeInsetsMake(topAndBottom, leftAndRight, topAndBottom, leftAndRight);
}
static inline CGFloat NTDegreesToRadians(CGFloat degrees){
    return degrees * M_PI / 180;
}

static inline CGFloat NTRadiansToDegrees(CGFloat radians){
    return radians * 180 / M_PI;
}
static inline CGFloat NTDiagonalLengthOfFrame (CGRect frame){
    return sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2));
}

static inline CGFloat NTLengthOfTwoPoint(CGPoint point1, CGPoint point2){
    return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
}

static inline CGPoint NTCenterPointOfTwoPoint(CGPoint point1, CGPoint point2){
    return CGPointMake(point1.x + 0.5 * (point2.x - point1.x), point1.y + 0.5 * (point2.y - point1.y));
}

static inline CGPoint NTPointTranslation(CGPoint point, CGPoint translation){
    return CGPointMake(point.x + translation.x, point.y + translation.y);
}

static inline NSInteger NTCentigradeToFahrenheit(NSInteger num){
    return round(num * 1.8 + 32);
}

NS_ASSUME_NONNULL_END
