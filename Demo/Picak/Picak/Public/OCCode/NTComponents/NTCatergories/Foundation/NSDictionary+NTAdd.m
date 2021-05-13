

//
//  NSDictionary+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSDictionary+NTAdd.h"
#import "NTCategoriesMacro.h"
#import "NSObject+NTAdd.h"

NT_SYNTH_DUMMY_CLASS(NSDictionary_NTAdd)

#define MutableSelf NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self]

@implementation NSDictionary (NTAdd)

+ (void)load{
    [NSClassFromString(@"__NSDictionaryM") nt_swizzleInstanceMethod:@selector(setObject:forKey:) with:@selector(_nt_setObject:forKey:)];
}


- (BOOL)nt_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSString *)nt_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)nt_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSDictionary *)nt_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
}

- (NSDictionary *)nt_dictionaryFromPlist:(NSString *)plistName{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

- (NSDictionary *)nt_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (!anObject || !aKey) return self;
    MutableSelf;
    dict[aKey] = anObject;
    return dict.copy;
}

- (NSDictionary *)nt_removeObjectForKey:(id)aKey{
    if (!aKey) return self;
    MutableSelf;
    [dict removeObjectForKey:aKey];
    return dict.copy;
}

- (NSDictionary *)nt_addEntriesFromDictionary:(NSDictionary *)subDict{
    if (!subDict.count) return self;
    MutableSelf;
    [dict addEntriesFromDictionary:subDict];
    return dict.copy;
}

- (void)_nt_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (!anObject) {
        NT_LOG(@"⚠️尝试在%p->%@中的key=%@的位置插入了一个nil值，请注意检查！", self, self, aKey);
        return;
    };
    if (!aKey) {
        NT_LOG(@"⚠️尝试在%p->%@中创建一个空的key值，请注意检查！", self, self);
        return;
    }
    [self _nt_setObject:anObject forKey:aKey];
}
@end
