//
//  XWLanguageTool.m
//  weather+
//
//  Created by wazrx on 16/4/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTLanguageTool.h"

@implementation NTLanguageTool

+ (BOOL)nt_isChinese {
    static BOOL isChinese = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isChinese = [[self xwp_language] hasPrefix:@"zh"];
    });
    return isChinese;
}

+ (BOOL)nt_isSimplifiedChinese {
    static BOOL isSimplifiedChinese = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSimplifiedChinese = [[self xwp_language] hasPrefix:@"zh-Hans"];
    });
    return isSimplifiedChinese;
}

+ (BOOL)nt_isTraditionalChinese {
    static BOOL isTraditionalChinese = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isTraditionalChinese = [[self xwp_language] hasPrefix:@"zh-HK"] || [[self xwp_language] hasPrefix:@"zh-TW"] || [[self xwp_language] hasPrefix:@"zh-Hant"];
    });
    return isTraditionalChinese;
}

+ (BOOL)nt_isEnglish {
    return ![self nt_isChinese];
}


+ (NSString *)xwp_language{
    static NSString *language = @"en-CN";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSLog(@"%@", languages);
        [languages enumerateObjectsUsingBlock:^(NSString *lanStr, NSUInteger idx, BOOL * stop) {
            if ([lanStr hasPrefix:@"zh"] || [lanStr hasPrefix:@"en"]) {
                language = lanStr;
                *stop = YES;
            }
        }];
    });
    return language;
}

+ (NSString *)nt_getCurrentLocalSymbol{
    if ([self nt_isSimplifiedChinese]) {
        return @"zh_cn";
    }
    if ([self nt_isTraditionalChinese]) {
        return @"zh_tw";
    }
    return @"en_us";
    
}

+ (NSString *)nt_languageString{
    return [self xwp_language];
}

@end
