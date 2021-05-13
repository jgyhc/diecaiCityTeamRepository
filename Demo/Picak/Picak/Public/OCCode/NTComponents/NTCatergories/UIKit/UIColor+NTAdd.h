//
//  UIColor+NTAdd.h
//  WxSelected
//
//  Created by YouLoft_MacMini on 15/12/18.
//  Copyright © 2015年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, NTGradientStyle) {
    NTGradientStyleLeftToRight,//左->右渐变
    NTGradientStyleRadial,//中间扩散
    NTGradientStyleTopToBottom//上->下渐变
};

#ifndef NT_RGB
#define NT_RGB(_r_, _g_, _b_) [UIColor colorWithRed:(_r_) / 255.0 green:(_g_) / 255.0 blue:(_b_) / 255.0 alpha:1.0]
#endif

#ifndef NT_RGBA
#define NT_RGBA(_r_, _g_, _b_, _a_) [UIColor colorWithRed:(_r_) / 255.0 green:(_g_) / 255.0 blue:(_b_) / 255.0 alpha:(_a_)]
#endif

#ifndef NT_RGBF
#define NT_RGBF(_r_, _g_, _b_) [UIColor colorWithRed:(_r_) green:(_g_) blue:(_b_) alpha:1.0]
#endif

#ifndef NT_HSB
#define NT_HSB(_h_, _s_, _b_) [UIColor colorWithHue:(_h_) / 360.0f saturation:(_s_) / 100.0f brightness:(_b_)/100.0f alpha:1.0]
#endif

#ifndef NT_HSBA
#define NT_HSBA(_h_, _s_, _b_, _a_) [UIColor colorWithHue:(_h_) / 360.0f saturation:(_s_) / 100.0f brightness:(_b_)/100.0f alpha:_a_]
#endif

#ifndef NT_HEX
#define NT_HEX(_hex_)   [UIColor nt_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

#ifndef NT_HEXA
#define NT_HEXA(_hex_, _alpha_)   [UIColor nt_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_)) alpha:(_alpha_)]
#endif

#ifndef NT_HEXS
#define NT_HEXS(_hex_)   [UIColor nt_colorWithHexString:(_hex_)]
#endif

@interface UIColor (NTAdd)

#pragma mark - fast property (快速获取颜色信息)

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat hue;
/**饱和度*/
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nullable, nonatomic, readonly) NSString *colorSpaceString;
@property (nonatomic, readonly) uint32_t rgbValue;
@property (nonatomic, readonly) uint32_t rgbaValue;
@property (nullable, nonatomic, readonly) NSString *hexString;
@property (nullable, nonatomic, readonly) NSString *hexStringWithAlpha;

#pragma mark - color initailize (颜色初始化相关)


/**Color With HSL*/
+ (UIColor *)nt_colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha;


/**Color With CMYB*/
+ (UIColor *)nt_colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha;

/**Color with hex value*/
+ (UIColor *)nt_colorWithRGB:(uint32_t)rgbValue;
+ (UIColor *)nt_colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)nt_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**Color with hex string*/
+ (nullable UIColor *)nt_colorWithHexString:(NSString *)hexStr;

+ (nullable UIColor *)nt_colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

#pragma mark - color change (颜色改变相关)

/**
 *  混合颜色
 *
 *  @param add       需要混合的颜色
 *  @param blendMode 混合方式
 *
 *  @return 混合后的颜色
 */
- (UIColor *)nt_colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;

/**改变颜色的HSB*/
- (UIColor *)nt_colorByChangeHue:(CGFloat)hueDelta
                   saturation:(CGFloat)saturationDelta
                   brightness:(CGFloat)brightnessDelta
                        alpha:(CGFloat)alphaDelta;

#pragma mark - interpolation (插值相关)
/**
 *  插值两种颜色返回中间的颜色
 *
 *  @param from  起始颜色
 *  @param to    终止颜色
 *  @param ratio 插值比例
 *
 *  @return 插值色
 */
+ (UIColor *)nt_colorWithInterpolationFromValue:(UIColor *)from toValue:(UIColor *)to ratio:(CGFloat)ratio;

#pragma mark - randomColor (随机色)

+ (UIColor *)nt_randomColor;

+ (UIColor *)nt_randomColorInColorArray:(NSArray *)colorArray;

#pragma mark - more color (更多颜色)

#pragma mark - Light Shades

+ (UIColor *)nt_BlackColor;

+ (UIColor *)nt_BlueColor;

+ (UIColor *)nt_BrownColor;

+ (UIColor *)nt_CoffeeColor;

+ (UIColor *)nt_ForestGreenColor;

+ (UIColor *)nt_GrayColor;

+ (UIColor *)nt_GreenColor;

+ (UIColor *)nt_LimeColor;

+ (UIColor *)nt_MagentaColor;

+ (UIColor *)nt_MaroonColor;

+ (UIColor *)nt_MintColor;

+ (UIColor *)nt_NavyBlueColor;

+ (UIColor *)nt_OrangeColor;

+ (UIColor *)nt_PinkColor;

+ (UIColor *)nt_PlumColor;

+ (UIColor *)nt_PowderBlueColor;

+ (UIColor *)nt_PurpleColor;

+ (UIColor *)nt_RedColor;

+ (UIColor *)nt_SandColor;

+ (UIColor *)nt_SkyBlueColor;

+ (UIColor *)nt_TealColor;

+ (UIColor *)nt_WatermelonColor;

+ (UIColor *)nt_WhiteColor;

+ (UIColor *)nt_YellowColor;

+ (UIColor *)nt_BlackColorDark;

+ (UIColor *)nt_BlueColorDark;

+ (UIColor *)nt_BrownColorDark;

+ (UIColor *)nt_CoffeeColorDark;

+ (UIColor *)nt_ForestGreenColorDark;

+ (UIColor *)nt_GrayColorDark;

+ (UIColor *)nt_GreenColorDark;

+ (UIColor *)nt_LimeColorDark;

+ (UIColor *)nt_MagentaColorDark;

+ (UIColor *)nt_MaroonColorDark;

+ (UIColor *)nt_MintColorDark;

+ (UIColor *)nt_NavyBlueColorDark;

+ (UIColor *)nt_OrangeColorDark;

+ (UIColor *)nt_PinkColorDark;

+ (UIColor *)nt_PlumColorDark;

+ (UIColor *)nt_PowderBlueColorDark;

+ (UIColor *)nt_PurpleColorDark;

+ (UIColor *)nt_RedColorDark;

+ (UIColor *)nt_SandColorDark;

+ (UIColor *)nt_SkyBlueColorDark;

+ (UIColor *)nt_TealColorDark;

+ (UIColor *)nt_WatermelonColorDark;

+ (UIColor *)nt_WhiteColorDark;

+ (UIColor *)nt_YellowColorDark;

#pragma mark - Gradient Color (渐变色相关)
+ (UIColor *)nt_colorWithGradientStyle:(NTGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors;
+ (UIColor *)nt_colorWithGradientFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withFrame:(CGRect)frame andColors:(NSArray *)colors;

#pragma mark - Color Macro (颜色宏)
#ifndef NT_BLACK_COLOR
#define NT_BLACK_COLOR [UIColor nt_BlackColor]
#endif

#ifndef NT_BLUE_COLOR
#define NT_BLUE_COLOR [UIColor nt_BlueColor]
#endif

#ifndef NT_BROWN_COLOR
#define NT_BROWN_COLOR [UIColor nt_BrownColor]
#endif

#ifndef NT_COFFEE_COLOR
#define NT_COFFEE_COLOR [UIColor nt_CoffeeColor]
#endif

#ifndef NT_FOREST_GREEN_COLOR
#define NT_FOREST_GREEN_COLOR [UIColor nt_ForestGreenColor]
#endif

#ifndef NT_GRAY_COLOR
#define NT_GRAY_COLOR [UIColor nt_GrayColor]
#endif

#ifndef NT_GREEN_COLOR
#define NT_GREEN_COLOR [UIColor nt_GreenColor]
#endif

#ifndef MT_LIME_COLOR
#define MT_LIME_COLOR [UIColor nt_LimeColor]
#endif

#ifndef NT_MAGENTA_COLOR
#define NT_MAGENTA_COLOR [UIColor nt_MagentaColor]
#endif

#ifndef NT_MAROON_COLOR
#define NT_MAROON_COLOR [UIColor nt_MaroonColor]
#endif

#ifndef NT_MINT_COLOR
#define NT_MINT_COLOR [UIColor nt_MintColor]
#endif

#ifndef NT_NAVY_BLUE_COLOR
#define NT_NAVY_BLUE [UIColor nt_NavyBlueColor]
#endif

#ifndef NT_ORANGE_COLOR
#define NT_ORANGE_COLOR [UIColor nt_OrangeColor]
#endif

#ifndef NT_PINK_COLOR
#define NT_PINK_COLOR [UIColor nt_PinkColor]
#endif

#ifndef NT_PLUM_COLOR
#define NT_PLUM_COLOR [UIColor nt_PlumColor]
#endif

#ifndef NT_POWDER_BLUE_COLOR
#define NT_POWDER_BLUE_COLOR [UIColor nt_PowderBlueColor]
#endif

#ifndef NT_PURPLE_COLOR
#define NT_PURPLE_COLOR [UIColor nt_PurpleColor]
#endif

#ifndef NT_RED_COLOR
#define NT_RED_COLOR [UIColor nt_RedColor]
#endif

#ifndef NT_SAND_COLOR
#define NT_SAND_COLOR [UIColor nt_SandColor]
#endif

#ifndef NT_SKY_BLUE_COLOR
#define NT_SKY_BLUE_COLOR [UIColor nt_SkyBlueColor]
#endif

#ifndef NT_TEAL_COLOR
#define NT_TEAL_COLOR [UIColor nt_TealColor]
#endif

#ifndef NT_WATERMELON_COLOR
#define NT_WATERMELON_COLOR [UIColor nt_WatermelonColor]
#endif

#ifndef NT_WHITE_COLOR
#define NT_WHITE_COLOR [UIColor nt_WhiteColor]
#endif

#ifndef NT_YELLOW_COLOR
#define NT_YELLOW_COLOR [UIColor nt_YellowColor]
#endif

#ifndef NT_BLACK_DARK_COLOR
#define NT_BLACK_DARK_COLOR [UIColor nt_BlackColorDark]
#endif

#ifndef NT_BLUE_DARK_COLOR
#define NT_BLUE_DARK_COLOR [UIColor nt_BlueColorDark]
#endif

#ifndef NT_BROWN_DARK_COLOR
#define NT_BROWN_DARK_COLOR [UIColor nt_BrownColorDark]
#endif

#ifndef NT_COFFEE_DARK_COLOR
#define NT_COFFEE_DARK_COLOR [UIColor nt_CoffeeColorDark]
#endif

#ifndef NT_FOREST_GREEN_DARK_COLOR
#define NT_FOREST_GREEN_DARK_COLOR [UIColor nt_ForestGreenColorDark]
#endif

#ifndef NT_GRAY_DARK_COLOR
#define NT_GRAY_DARK_COLOR [UIColor nt_GrayColorDark]
#endif

#ifndef NT_GEEN_DARK_COLOR
#define NT_GEEN_DARK_COLOR [UIColor nt_GreenColorDark]
#endif

#ifndef NT_LIME_DARK_COLOR
#define NT_LIME_DARK_COLOR [UIColor nt_LimeColorDark]
#endif

#ifndef NT_MAGENTA_DARK_COLOR
#define NT_MAGENTA_DARK_COLOR [UIColor nt_MagentaColorDark]
#endif

#ifndef NT_MAROON_DARK_COLOR
#define NT_MAROON_DARK_COLOR [UIColor nt_MaroonColorDark]
#endif

#ifndef NT_MINT_DARK_COLOR
#define NT_MINT_DARK_COLOR [UIColor nt_MintColorDark]
#endif

#ifndef NT_NAVY_BLUE_DARK_COLOR
#define NT_NAVY_BLUE_DARK_COLOR [UIColor nt_NavyBlueColorDark]
#endif

#ifndef NT_ORANGE_DARK_COLOR
#define NT_ORANGE_DARK_COLOR [UIColor nt_OrangeColorDark]
#endif

#ifndef NT_PINK_DARK_COLOR
#define NT_PINK_DARK_COLOR [UIColor nt_PinkColorDark]
#endif

#ifndef NT_PLUM_DARK_COLOR
#define NT_PLUM_DARK_COLOR [UIColor nt_PlumColorDark]
#endif

#ifndef NT_POWDER_BLUE_DARK_COLOR
#define NT_POWDER_BLUE_DARK_COLOR [UIColor nt_PowderBlueColorDark]
#endif

#ifndef NT_PURPLE_DARK_COLOR
#define NT_PURPLE_DARK_COLOR [UIColor nt_PurpleColorDark]
#endif

#ifndef NT_RED_DARK_COLOR
#define NT_RED_DARK_COLOR [UIColor nt_RedColorDark]
#endif

#ifndef NT_SAND_DARK_COLOR
#define NT_SAND_DARK_COLOR [UIColor nt_SandColorDark]
#endif

#ifndef NT_SKY_BLUE_DARK_COLOR
#define NT_SKY_BLUE_DARK_COLOR [UIColor nt_SkyBlueColorDark]
#endif

#ifndef NT_TEAL_DARK_COLOR
#define NT_TEAL_DARK_COLOR [UIColor nt_TealColorDark]
#endif

#ifndef NT_WATERMELON_DARK_COLOR
#define NT_WATERMELON_DARK_COLOR [UIColor nt_WatermelonColorDark]
#endif

#ifndef NT_WHITE_DARK_COLOR
#define NT_WHITE_DARK_COLOR [UIColor nt_WhiteColorDark]
#endif

#ifndef NT_YELLOW_DARK_COLOR
#define NT_YELLOW_DARK_COLOR [UIColor nt_YellowColorDark]
#endif

#ifndef NT_BLACK_ORIG_COLOR
#define NT_BLACK_ORIG_COLOR [UIColor blackColor]
#endif

#ifndef NT_DARK_GARY_ORIG_COLOR
#define NT_DARK_GARY_ORIG_COLOR [UIColor darkGrayColor]
#endif

#ifndef NT_LIGHT_GARY_ORIG_COLOR
#define NT_LIGHT_GARY_ORIG_COLOR [UIColor lightGrayColor]
#endif

#ifndef NT_WHITE_ORIG_COLOR
#define NT_WHITE_ORIG_COLOR [UIColor whiteColor]
#endif

#ifndef NT_GARY_ORIG_COLOR
#define NT_GARY_ORIG_COLOR [UIColor grayColor]
#endif

#ifndef NT_RED_ORIG_COLOR
#define NT_RED_ORIG_COLOR [UIColor redColor]
#endif

#ifndef NT_GREEN_ORIG_COLOR
#define NT_GREEN_ORIG_COLOR [UIColor greenColor]
#endif

#ifndef NT_BLUE_ORIG_COLOR
#define NT_BLUE_ORIG_COLOR [UIColor blueColor]
#endif

#ifndef NT_CYAN_ORIG_COLOR
#define NT_CYAN_ORIG_COLOR [UIColor cyanColor]
#endif

#ifndef NT_YELLOW_ORIG_COLOR
#define NT_YELLOW_ORIG_COLOR [UIColor yellowColor]
#endif

#ifndef NT_MAGENTA_ORIG_COLOR
#define NT_MAGENTA_ORIG_COLOR [UIColor magentaColor]
#endif

#ifndef NT_ORANGE_ORIG_COLOR
#define NT_ORANGE_ORIG_COLOR [UIColor orangeColor]
#endif

#ifndef NT_PURPLE_ORIG_COLOR
#define NT_PURPLE_ORIG_COLOR [UIColor purpleColor]
#endif

#ifndef NT_BROWN_ORIG_COLOR
#define NT_BROWN_ORIG_COLOR [UIColor brownColor]
#endif

#ifndef NT_CLEAR_COLOR
#define NT_CLEAR_COLOR [UIColor clearColor]
#endif


@end

NS_ASSUME_NONNULL_END
