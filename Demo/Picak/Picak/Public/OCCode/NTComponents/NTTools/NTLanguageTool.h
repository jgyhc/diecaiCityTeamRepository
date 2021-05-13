//
//  XWLanguageTool.h
//  weather+
//
//  Created by wazrx on 16/4/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTLanguageTool : NSObject

//是否为简体中文或繁体中文
+ (BOOL)nt_isChinese;

//简体中文
+ (BOOL)nt_isSimplifiedChinese;

//繁体中文
+ (BOOL)nt_isTraditionalChinese;

//英文
+ (BOOL)nt_isEnglish;

+ (NSString *)nt_languageString;

+ (NSString *)nt_getCurrentLocalSymbol;

@end
