
//
//  NSMutableArray+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSMutableArray+NTAdd.h"
#import "NSArray+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSMutableArray_NTAdd)

@implementation NSMutableArray (NTAdd)


- (void)nt_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)nt_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (id)nt_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self nt_removeFirstObject];
    }
    return obj;
}

- (id)nt_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self nt_removeLastObject];
    }
    return obj;
}

- (id)nt_popObjectAtIndexPath:(NSUInteger)index {
    id obj = nil;
    if (self.count) {
        obj = [self nt_objectOrNilAtIndex:index];
        if (obj) {
            [self removeObjectAtIndex:index];
        }
    }
    return obj;
}

- (void)nt_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)nt_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)nt_random {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}
@end
