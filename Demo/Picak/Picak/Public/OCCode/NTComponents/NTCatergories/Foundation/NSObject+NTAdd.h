//
//  NSObject+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/14.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NTAdd)

@property (nonatomic, readonly) id jsonObject;
@property (nonatomic, readonly) NSString *nt_jsonString;
@property (nonatomic, readonly) NSData *jsonData;

#pragma mark - swizzling (方法交换相关)

+ (void)nt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

+ (void)nt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

- (void)nt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

- (void)nt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


#pragma mark - associate (关联相关)

- (void)nt_setAssociateValue:(id)value withKey:(void *)key;

- (void)nt_setAssociateWeakValue:(id)value withKey:(void *)key;

- (void)nt_setAssociateCopyValue:(id)value withKey:(void *)key;

- (id)nt_getAssociatedValueForKey:(void *)key;

- (void)nt_removeAssociateWithKey:(void *)key;

- (void)nt_removeAllAssociatedValues;

+ (void)nt_setAssociateValue:(id)value withKey:(void *)key;

+ (void)nt_setAssociateWeakValue:(id)value withKey:(void *)key;

+ (void)nt_setAssociateCopyValue:(id)value withKey:(void *)key;

+ (id)nt_getAssociatedValueForKey:(void *)key;

+ (void)nt_removeAssociateWithKey:(void *)key;

+ (void)nt_removeAllAssociatedValues;

#pragma mark - runtime other (runtime 其它相关)

+ (NSArray *)nt_getAllPropertyNames;

+ (NSArray *)nt_getAllIvarNames;

+ (NSArray *)nt_getAllInstanceMethodsNames;

+ (NSArray *)nt_getAllClassMethodsNames;

/**将对象的所有NSString属性设置为传入的string，如@"--"*/
- (void)nt_setAllNSStringPropertyWithString:(NSString *)string;

#pragma mark - KVO

/**
 *  通过Block方式注册一个KVO，通过该方式注册的KVO无需手动移除，其会在被监听对象销毁的时候自动移除,所以下面的两个移除方法一般无需使用
 *
 *  @param keyPath 监听路径
 *  @param block   KVO回调block，obj为监听对象，oldVal为旧值，newVal为新值
 */
- (void)nt_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id obj, id oldVal, id newVal))block;

/**
 *  提前移除指定KeyPath下的BlockKVO(一般无需使用，如果需要提前注销KVO才需要)
 *
 *  @param keyPath 移除路径
 */
- (void)nt_removeObserverBlockForKeyPath:(NSString *)keyPath;

/**
 *  提前移除所有的KVOBlock(一般无需使用)
 */
- (void)nt_removeAllObserverBlocks;

#pragma mark - Notification

/**
 *  通过block方式注册通知，通过该方式注册的通知无需手动移除，同样会自动移除
 *
 *  @param name  通知名
 *  @param block 通知的回调Block，notification为回调的通知对象
 */
- (void)nt_addNotificationForName:(NSString *)name block:(void (^)(NSNotification *notification))block;

/**
 *  提前移除某一个name的通知
 *
 *  @param name 需要移除的通知名
 */
- (void)nt_removeNotificationForName:(NSString *)name;

/**
 *  提前移除所有通知
 */
- (void)nt_removeAllNotification;

/**
 *  发送一个通知
 *
 *  @param name     通知名
 *  @param userInfo 数据字典
 */
- (void)nt_postNotificationWithName:(NSString *)name userInfo:(nullable NSDictionary *)userInfo;


//发起键盘监听

- (void)nt_addKeyboardObserve:(void(^)(BOOL isShow, float keyboardHeight))config;

@end

NS_ASSUME_NONNULL_END
