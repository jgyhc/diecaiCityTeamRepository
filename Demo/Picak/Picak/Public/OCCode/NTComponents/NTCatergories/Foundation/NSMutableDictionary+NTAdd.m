

//
//  NSMutableDictionary+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSMutableDictionary+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSMutableDictionary_NTAdd)

typedef id(^NTWeakReferencesBlock)(void);

@implementation NSMutableDictionary (NTAdd)

- (void)nt_weakSetObject:(id)object key:(id<NSCopying>)key{
    if (!key) {
        return;
    }
    [self setObject:[self _nt_makeWeakReferencesObjectBlockWithObject:object] forKey:key];
}

- (void)nt_weakSetDictionary:(NSDictionary *)otherDictionary{
    if (!otherDictionary.count) {
        return;
    }
    [otherDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self setObject:[self _nt_makeWeakReferencesObjectBlockWithObject:obj] forKey:key];
    }];
}

- (id)nt_weakObjectForKey:(id<NSCopying>)key{
    NTWeakReferencesBlock weakReferencesObjectBlock = self[key];
    return weakReferencesObjectBlock ? weakReferencesObjectBlock() : nil;
}

- (NTWeakReferencesBlock)_nt_makeWeakReferencesObjectBlockWithObject:(id)object{
    if (!object) {
        return nil;
    }
    NT_WEAKIFY(object);
    return ^(){
        NT_STRONGIFY(object);
        return object;
    };
}

- (id)nt_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

- (NSDictionary *)nt_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dic[key] = value;
        }
    }
    return dic;
}

@end
