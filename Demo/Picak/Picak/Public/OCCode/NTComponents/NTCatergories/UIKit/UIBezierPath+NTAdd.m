
//
//  UIBezierPath+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIBezierPath+NTAdd.h"
#import "NSArray+NTAdd.h"
#import "UIFont+NTAdd.h"
#import <CoreText/CoreText.h>
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIBezierPath_NTAdd)

@implementation UIBezierPath (NTAdd)

+ (UIBezierPath *)nt_bezierPathWithText:(NSString *)text font:(UIFont *)font {
    
    CTFontRef ctFont = font.ctFontRef;
    if (!ctFont) return nil;
    NSDictionary *attrs = @{ (__bridge id)kCTFontAttributeName:(__bridge id)ctFont };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CFRelease(ctFont);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
    if (!line) return nil;
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
            CFRange glyphRange = CFRangeMake(iGlyph, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            if (glyphPath) {
                CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(cgPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
    CFRelease(cgPath);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

+ (UIBezierPath *)nt_smoothPathWithPoints:(NSArray *)points contractionFactor:(CGFloat)factor{
    if (!points.count) return nil;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[points[0] CGPointValue]];
    points = [points nt_removeObjectAtIndex:0];
    if (points.count < 3) {
        switch (points.count) {
            case 1:
            {
                NSValue * point0Value = points[0];
                CGPoint point0 = [point0Value CGPointValue];
                [path addLineToPoint:point0];
            }
                break;
            case 2:
            {
                NSValue * point0Value = points[0];
                CGPoint point0 = [point0Value CGPointValue];
                NSValue * point1Value = points[1];
                CGPoint point1 = [point1Value CGPointValue];
                [path addQuadCurveToPoint:point1 controlPoint:ControlPointForTheBezierCanThrough3Point(path.currentPoint, point0, point1)];
            }
                break;
            default:
                break;
        }
    }
    
    CGPoint previousPoint = CGPointZero;
    
    CGPoint previousCenterPoint = CGPointZero;
    CGPoint centerPoint = CGPointZero;
    CGFloat centerPointDistance = 0;
    
    CGFloat obliqueAngle = 0;
    
    CGPoint previousControlPoint1 = CGPointZero;
    CGPoint previousControlPoint2 = CGPointZero;
    CGPoint controlPoint1 = CGPointZero;
    
    previousPoint = path.currentPoint;
    
    for (int i = 0; i < points.count; i++) {
        
        NSValue * pointIValue = points[i];
        CGPoint pointI = [pointIValue CGPointValue];
        
        if (i > 0) {
            
            previousCenterPoint = CenterPointOf(path.currentPoint, previousPoint);
            centerPoint = CenterPointOf(previousPoint, pointI);
            
            centerPointDistance = DistanceBetweenPoint(previousCenterPoint, centerPoint);
            
            obliqueAngle = ObliqueAngleOfStraightThrough(centerPoint, previousCenterPoint);
            
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 * factor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * factor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * factor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * factor * centerPointDistance * sin(obliqueAngle));
        }
        
        if (i == 1) {
            
            [path addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 1 && i < points.count - 1) {
            
            [path addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        else if (i == points.count - 1) {
            
            [path addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [path addQuadCurveToPoint:pointI controlPoint:controlPoint1];
        }
        else {
            
        }
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
    }
    return path;
}

CGFloat ObliqueAngleOfStraightThrough(CGPoint point1, CGPoint point2)   //  [-π/2, 3π/2)
{
    CGFloat obliqueRatio = 0;
    CGFloat obliqueAngle = 0;
    
    if (point1.x > point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = atan(obliqueRatio);
    }
    else if (point1.x < point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = M_PI + atan(obliqueRatio);
    }
    else if (point2.y - point1.y >= 0) {
        
        obliqueAngle = M_PI/2;
    }
    else {
        obliqueAngle = -M_PI/2;
    }
    
    return obliqueAngle;
}

CGPoint ControlPointForTheBezierCanThrough3Point(CGPoint point1, CGPoint point2, CGPoint point3)
{
    return CGPointMake(2 * point2.x - (point1.x + point3.x) / 2, 2 * point2.y - (point1.y + point3.y) / 2);
}

CGFloat DistanceBetweenPoint(CGPoint point1, CGPoint point2)
{
    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
}

CGPoint CenterPointOf(CGPoint point1, CGPoint point2)
{
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}

@end
