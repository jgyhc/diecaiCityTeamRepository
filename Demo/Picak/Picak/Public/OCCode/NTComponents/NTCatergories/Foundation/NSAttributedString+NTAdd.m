//
//  NSAttributedString+NTAdd.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/7/19.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NSAttributedString+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSAttributedString_NTAdd)

@implementation NSAttributedString (NTAdd)

+ (void)load{
    [NSClassFromString(@"NSConcreteAttributedString") nt_swizzleInstanceMethod:@selector(initWithString:) with:@selector(_nt_initWithString:)];
    [NSClassFromString(@"NSConcreteAttributedString") nt_swizzleInstanceMethod:@selector(initWithString:attributes:) with:@selector(_nt_initWithString:attributes:)];
    [NSClassFromString(@"NSConcreteMutableAttributedString") nt_swizzleInstanceMethod:@selector(initWithString:) with:@selector(_nt_initMutableWithString:)];
    [NSClassFromString(@"NSConcreteMutableAttributedString") nt_swizzleInstanceMethod:@selector(initWithString:attributes:) with:@selector(_nt_initMutableWithString:attributes:)];
}

#pragma mark - Overwrite Methods
- (instancetype)_nt_initWithString:(NSString *)str{
    if (!str) return nil;
    return [self _nt_initWithString:str];
}

- (instancetype)_nt_initMutableWithString:(NSString *)str{
    if (!str) return nil;
    return [self _nt_initMutableWithString:str];
}

- (instancetype)_nt_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs{
    if (!str) return nil;
    return [self _nt_initWithString:str attributes:attrs];
}

- (instancetype)_nt_initMutableWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs{
    if (!str) return nil;
    return [self _nt_initMutableWithString:str attributes:attrs];
}

@end
