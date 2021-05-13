//
//  NSDictionary+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_DICT_SET_OBJECT
#define NT_DICT_SET_OBJECT(_dict_, _key_, _object_) \
id obj = (_object_ ); \
id akey = (_key_); \
if (!obj) { \
    NT_LOG(@"⚠️尝试在%p->%@中的key=%@的位置插入了一个nil值，请注意检查！", (_dict_), (_dict_), (_key_)) \
} else if(!akey) { \
    NT_LOG(@"⚠️尝试在%p->%@中创建一个空的key值，请注意检查！", (_dict_), (_dict_)); \
} else { \
    [(_dict_) setObject:obj forKey:akey];}
#endif

@interface NSDictionary (NTAdd)

- (nullable NSDictionary *)nt_dictionaryFromPlist:(NSString *)plistName;

- (BOOL)nt_containsObjectForKey:(id)key;
- (nullable NSString *)nt_jsonStringEncoded;
- (nullable NSString *)nt_jsonPrettyStringEncoded;
/**根据keys数组返回对应的字典*/
- (nullable NSDictionary *)nt_entriesForKeys:(NSArray *)keys;

- (nullable NSDictionary *)nt_addEntriesFromDictionary:(NSDictionary *)subDict;

- (NSDictionary *)nt_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (NSDictionary *)nt_removeObjectForKey:(id)aKey;


@end

NS_ASSUME_NONNULL_END
