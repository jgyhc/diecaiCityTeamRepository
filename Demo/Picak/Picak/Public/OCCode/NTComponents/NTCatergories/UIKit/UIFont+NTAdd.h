//
//  UIFont+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "NTCGUtilities.h"
#import "NSObject+NTAdd.h"

NS_ASSUME_NONNULL_BEGIN

static inline UIFont* NTFontWithName(NSString *fontName, CGFloat size, BOOL scale){
    size = scale ? NTWidthRatio(size) : size;
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

static inline UIFont* NTFontWithScale(CGFloat size){
    return [UIFont systemFontOfSize:NTWidthRatio(size)];
}

static inline UIFont* NTFontWithScaleUltralight(CGFloat size){
    return NTFontWithName(@"PingFangSC-Ultralight", size, YES);
}

static inline UIFont* NTFontWithScaleLight(CGFloat size){
    return NTFontWithName(@"PingFangSC-Light", size, YES);
}

static inline UIFont* NTFontWithScaleRegular(CGFloat size){
    return NTFontWithName(@"PingFangSC-Regular", size, YES);
}

static inline UIFont* NTFontWithScaleMedium(CGFloat size){
    return NTFontWithName(@"PingFang SC-Medium", size, YES);
}

static inline UIFont* NTFont(CGFloat size){
    return [UIFont systemFontOfSize:size];
}

static inline UIFont* NTFontUltralight(CGFloat size){
    return NTFontWithName(@"PingFang SC-Ultralight", size, NO);
}

static inline UIFont* NTFontLight(CGFloat size){
    return NTFontWithName(@"PingFang SC-Light", size, NO);
}

static inline UIFont* NTFontRegular(CGFloat size){
    return NTFontWithName(@"PingFang SC-Regular", size, NO);
}

static inline UIFont* NTFontMedium(CGFloat size){
    return NTFontWithName(@"PingFang SC-Medium", size, NO);
}

static inline UIFont* NTFontBold(CGFloat size){
    return NTFontWithName(@"PingFangSC-Semibold", size, NO);
}



@interface UIFont (NTAdd)

#pragma mark - check font type

@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0); ///< Whether the font is bold.
@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0); ///< Whether the font is italic.
@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0); ///< Whether the font is mono space.
@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0); ///< Whether the font is color glyphs (such as Emoji).
@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0); ///< Font weight from -1.0 to 1.0. Regular weight
@property (nonatomic, readonly) BOOL isSystemFont;

#pragma mark - font type change

@property (nullable, nonatomic, readonly) UIFont *boldFont;
@property (nullable, nonatomic, readonly) UIFont *italicFont;
@property (nullable, nonatomic, readonly) UIFont *boldItalicFont;
@property (nullable, nonatomic, readonly) UIFont *normalFont;

#pragma mark - create font

+ (nullable UIFont *)nt_fontWithCTFont:(CTFontRef)CTFont;
+ (nullable UIFont *)nt_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;


@property (nullable, nonatomic, readonly) CTFontRef ctFontRef CF_RETURNS_RETAINED;
@property (nullable, nonatomic, readonly) CGFontRef cgFontRef CF_RETURNS_RETAINED;

#pragma mark - Load and unload font

+ (BOOL)nt_loadFontFromPath:(NSURL *)path;
+ (void)nt_unloadFontFromPath:(NSURL *)path;
+ (nullable UIFont *)nt_loadFontFromData:(NSData *)data;
+ (BOOL)nt_unloadFontFromData:(UIFont *)font;

+ (void)nt_loadAllFOntsInPath:(NSString *)path;
+ (void)nt_loadAllFontsInBundle;

+ (UIFont *)nt_loadFontInPath:(NSString *)path size:(CGFloat)size;//for ttf and otf，if font is ttc， return only one font is ttc array

+ (NSArray<UIFont *> *)nt_loadAllFontsInBundleWithSize:(CGFloat)size;//for ttf and otf in bundle



@end

NS_ASSUME_NONNULL_END
