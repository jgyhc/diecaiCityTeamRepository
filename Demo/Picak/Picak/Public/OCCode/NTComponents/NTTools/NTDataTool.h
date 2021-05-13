//
//  XWDataTool.h
//  NewCenterWeather
//
//  Created by wazrx on 16/4/28.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTCategoriesMacro.h"

NS_ASSUME_NONNULL_BEGIN


static inline NSArray * NTValidateArray(NSArray *rawArray){
    if (![rawArray isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return rawArray;
};

static inline NSString * NTValidateString(NSString *rawString){
    if (!rawString || [rawString isKindOfClass: [NSNull class]]) {
        return @"";
    }
    if (![rawString isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", rawString];
    }
    return rawString;
};

static inline NSDictionary * NTValidateDict(NSDictionary *rawDict){
    if (![rawDict isKindOfClass:[NSDictionary class]]) {
        return @{};
    }
    return rawDict;
};

/**
 带占位字符串校验，如果rawString无效，则返placeHolder
 */
static inline NSString * NTValidateStringWithPlacHolder(NSString *rawString, NSString *placeHolder){
    if (!rawString || [rawString isKindOfClass: [NSNull class]]) {
        return (!placeHolder || ![placeHolder isKindOfClass:[NSString class]]) ? @"" : placeHolder;
    }
    if (![rawString isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", rawString];
    }
    return rawString;
};


NS_ASSUME_NONNULL_END
