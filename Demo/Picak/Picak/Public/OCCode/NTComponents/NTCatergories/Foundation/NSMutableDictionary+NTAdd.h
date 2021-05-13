//
//  NSMutableDictionary+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (NTAdd)

/**移除并返回对应key的value*/
- (nullable id)nt_popObjectForKey:(id)aKey;
/**移除并返回对应keys数组的values*/
- (nullable NSDictionary *)nt_popEntriesForKeys:(NSArray *)keys;

#pragma mark - weak references (弱引用相关)
/**将object加入字典但字典对其弱引用*/
- (void)nt_weakSetObject:(id)object key:(id<NSCopying>)key;
/**将dict加入字典但字典对其弱引用*/
- (void)nt_weakSetDictionary:(NSDictionary *)otherDictionary;
/**将弱引用对象取出来*/
- (id)nt_weakObjectForKey:(id<NSCopying>)key;


@end
NS_ASSUME_NONNULL_END
