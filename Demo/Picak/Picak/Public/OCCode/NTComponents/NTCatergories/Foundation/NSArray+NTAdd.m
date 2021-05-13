//
//  NSArray+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSArray+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"
#import <objc/message.h>

#define MutableSelf NSMutableArray *mutableSelf = [NSMutableArray arrayWithArray:self]

NT_SYNTH_DUMMY_CLASS(NSArray_NTAdd)

@implementation NSArray (NTAdd)

+ (void)load{
    [NSClassFromString(@"__NSArray0") nt_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(_nt_emptyObjectIndex:)];
    
//    [NSClassFromString(@"__NSArrayI") nt_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(_nt_arrObjectIndex:)];
//    [NSClassFromString(@"__NSArrayM") nt_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(_nt_mArrObjectIndex:)];
//    [NSClassFromString(@"__NSFrozenArrayM") nt_swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(_nt_fArrObjectIndex:)];
    
//    [NSClassFromString(@"__NSArrayI") nt_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(_nt_arrObjectIndexedSubscript:)];
//    [NSClassFromString(@"__NSArrayM") nt_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(_nt_mArrObjectIndexedSubscript:)];
//    [NSClassFromString(@"__NSFrozenArrayM") nt_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(_nt_fArrObjectIndexedSubscript:)];
    
//    [NSClassFromString(@"__NSArrayM") nt_swizzleInstanceMethod:@selector(insertObject:atIndex:) with:@selector(_nt_fMutableInsertObject:atIndex:)];
//    [NSClassFromString(@"__NSFrozenArrayM") nt_swizzleInstanceMethod:@selector(insertObject:atIndex:) with:@selector(_nt_mutableInsertObject:atIndex:)];
    
    [NSClassFromString(@"__NSArrayM") nt_swizzleInstanceMethod:@selector(setObject:atIndex:) with:@selector(_nt_setObject:atIndex:)];
    [NSClassFromString(@"__NSFrozenArrayM") nt_swizzleInstanceMethod:@selector(setObject:atIndex:) with:@selector(_nt_fSetObject:atIndex:)];
    
    [NSClassFromString(@"__NSArrayM") nt_swizzleInstanceMethod:@selector(setObject:atIndexedSubscript:) with:@selector(_nt_setObject:atIndexedSubscript:)];
    [NSClassFromString(@"__NSFrozenArrayM") nt_swizzleInstanceMethod:@selector(setObject:atIndexedSubscript:) with:@selector(_nt_fSetObject:atIndexedSubscript:)];
}

- (id)nt_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)nt_objectOrNilAtIndex:(NSUInteger)index {
    if (index < self.count && self.count) {
        return self[index];
    }else{
        NT_LOG(@"⚠️:数组%p->%@在取值的时候越界了，返回了nil，请注意检查", self, self);
        return nil;
    }
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

- (NSArray *)nt_arrayAfterRandom {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self];
    for (NSUInteger i = temp.count; i > 1; i--) {
        [temp exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    return temp.copy;
}


+ (NSArray *)nt_arrayFromPlist:(NSString *)plistName{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

- (NSArray *)nt_addObject:(id)object {
    MutableSelf;
    [mutableSelf addObject:object];
    return mutableSelf.copy;
}

- (NSArray *)nt_addObjectsFromArray:(NSArray *)array {
    MutableSelf;
    [mutableSelf addObjectsFromArray:array];
    return mutableSelf.copy;
}

- (NSArray *)nt_removeObject:(id)object {
    MutableSelf;
    [mutableSelf removeObject:object];
    return mutableSelf.copy;
}

- (NSArray *)nt_removeObjectInArray:(NSArray *)array{
    MutableSelf;
    [mutableSelf removeObjectsInArray:array];
    return mutableSelf.copy;
}

- (NSArray *)nt_removeObjectAtIndex:(NSUInteger)index{
    if (index < self.count && self.count) {
        MutableSelf;
        [mutableSelf removeObjectAtIndex:index];
        return mutableSelf.copy;
    }else{
        return self;
    }
}

- (NSArray *)nt_insertObject:(id)object atIndex:(NSUInteger)index {
    MutableSelf;
    [mutableSelf insertObject:object atIndex:index];
    return mutableSelf.copy;
}

- (NSArray *)nt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object{
    if (index > self.count - 1) {
        return self;
    }
    MutableSelf;
    [mutableSelf replaceObjectAtIndex:index withObject:object];
    return mutableSelf.copy;
}

- (NSArray *)nt_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2{
    if (idx1 > self.count - 1 || idx2 > self.count - 1) return self;
    MutableSelf;
    [mutableSelf exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    return mutableSelf.copy;
}


#pragma mark - Exchange Methods

#define _NT_GET_OBJ_AT_INDEX_HANDLE \
if (index >= self.count || index < 0) { \
    NT_LOG(@"⚠️:数组%p->%@在通过index=%zd取值的时候越界了，返回了nil，请注意检查", self, self, index); \
    return nil; \
}

- (id)_nt_emptyObjectIndex:(NSInteger)index{
    return nil;
}

- (id)_nt_arrObjectIndex:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_arrObjectIndex:index];
}

- (id)_nt_mArrObjectIndex:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_mArrObjectIndex:index];
}

- (id)_nt_fArrObjectIndex:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_fArrObjectIndex:index];
}

- (id)_nt_arrObjectIndexedSubscript:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_arrObjectIndexedSubscript:index];
}

- (id)_nt_mArrObjectIndexedSubscript:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_mArrObjectIndexedSubscript:index];
}

- (id)_nt_fArrObjectIndexedSubscript:(NSInteger)index{
    _NT_GET_OBJ_AT_INDEX_HANDLE
    return [self _nt_fArrObjectIndexedSubscript:index];
}

#define _NT_SET_OBJ_AT_INDEX(_cmd_) \
if (object) { \
if (index <= self.count) { \
    _cmd_; \
}else{ \
    NT_LOG(@"⚠️:数组%p->%@要在index=%zd插入数据的时候越界了，请注意检查", self, self, index); \
} \
}else{ \
    NT_LOG(@"⚠️:数组%p->%@在index=%zd处被插入了一个nil，请注意检查", self, self, index); \
}

- (void)_nt_mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_mutableInsertObject:object atIndex:index]);
}

- (void)_nt_fMutableInsertObject:(id)object atIndex:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_fMutableInsertObject:object atIndex:index]);
}

- (void)_nt_setObject:(id)object atIndex:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_setObject:object atIndex:index]);
}

- (void)_nt_fSetObject:(id)object atIndex:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_fSetObject:object atIndex:index]);
}

- (void)_nt_setObject:(id)object atIndexedSubscript:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_setObject:object atIndexedSubscript:index]);
}

- (void)_nt_fSetObject:(id)object atIndexedSubscript:(NSUInteger)index{
    _NT_SET_OBJ_AT_INDEX([self _nt_fSetObject:object atIndex:index]);
}

@end
