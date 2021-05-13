//
//  NSArray+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_ARRAY
#define NT_ARRAY(_array_, _index_) \
({ \
    id obj = nil; \
    if ((_array_).count && (_index_) < (_array_).count) { \
        obj = (_array_)[(_index_)]; \
    }else{ \
        NT_LOG(@"⚠️:数组%p->%@在通过index=%zd取值的时候越界了，返回了nil，请注意检查", (_array_), (_array_), (_index_)); \
    } \
    obj; \
}) 
#endif

#ifndef NT_ARRAY_SET_OBJECT
#define NT_ARRAY_SET_OBJECT(_array_, _index_, _object_) \
id obj = (_object_);\
if (obj) { \
if ((_index_) <= (_array_).count) { \
[(_array_) insertObject:(_object_) atIndex:(_index_)]; \
}else{ \
NT_LOG(@"⚠️:数组%p->%@要在index=%zd插入数据的时候越界了，请注意检查", (_array_), (_array_), (_index_)); \
} \
}else{ \
NT_LOG(@"⚠️:数组%p->%@在index=%zd处被插入了一个nil，请注意检查", (_array_), (_array_), (_index_)); \
}
#endif

@interface NSArray (NTAdd)

+ (nullable NSArray *)nt_arrayFromPlist:(NSString *)plistName;

- (nullable id)nt_randomObject;

- (nullable NSArray *)nt_arrayAfterRandom;

/**objectAtIndex的防止越界的版本，越界返回nil*/
- (nullable id)nt_objectOrNilAtIndex:(NSUInteger)index;

- (NSArray *)nt_addObject:(id)object;
- (NSArray *)nt_addObjectsFromArray:(NSArray *)array;

- (NSArray *)nt_removeObject:(id)object;
- (NSArray *)nt_removeObjectAtIndex:(NSUInteger)index;
- (NSArray *)nt_removeObjectInArray:(NSArray *)array;

- (NSArray *)nt_insertObject:(id)object atIndex:(NSUInteger)index;

- (NSArray *)nt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;

- (NSArray *)nt_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;


- (nullable NSString *)nt_jsonStringEncoded;
- (nullable NSString *)nt_jsonPrettyStringEncoded;


@end

NS_ASSUME_NONNULL_END
