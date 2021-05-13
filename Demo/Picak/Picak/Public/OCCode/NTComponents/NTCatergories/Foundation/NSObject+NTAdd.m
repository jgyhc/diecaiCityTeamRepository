//
//  NSObject+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/14.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSObject+NTAdd.h"
#import "NSString+NTAdd.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSObject_NTAdd)

@interface _NTBlockTarget : NSObject

/**添加一个KVOBlock*/
- (void)nt_addBlock:(void(^)(__weak id obj, id oldValue, id newValue))block;
- (void)nt_addNotificationBlock:(void(^)(NSNotification *notification))block;

- (void)nt_doNotification:(NSNotification*)notification;

@end

@implementation _NTBlockTarget{
    //保存所有的block
    NSMutableSet *_kvoBlockSet;
    NSMutableSet *_notificationBlockSet;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kvoBlockSet = [NSMutableSet new];
        _notificationBlockSet = [NSMutableSet new];
    }
    return self;
}

- (void)nt_addBlock:(void(^)(__weak id obj, id oldValue, id newValue))block{
    [_kvoBlockSet addObject:[block copy]];
}

- (void)nt_addNotificationBlock:(void(^)(NSNotification *notification))block{
    [_notificationBlockSet addObject:[block copy]];
}

- (void)nt_doNotification:(NSNotification*)notification{
    if (!_notificationBlockSet.count) return;
    [_notificationBlockSet enumerateObjectsUsingBlock:^(void (^block)(NSNotification *notification), BOOL * _Nonnull stop) {
        block(notification);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!_kvoBlockSet.count) return;
    BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    //只接受值改变时的消息
    if (prior) return;
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    //执行该target下的所有block
    [_kvoBlockSet enumerateObjectsUsingBlock:^(void (^block)(__weak id obj, id oldVal, id newVal), BOOL * _Nonnull stop) {
        block(object, oldVal, newVal);
    }];
}

@end


@implementation NSObject (NTAdd)

- (NSData *)jsonData{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    return [NSJSONSerialization dataWithJSONObject:self.jsonObject options:kNilOptions error:nil];
}

- (id)jsonObject{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    return self;
}

- (NSString *)nt_jsonString{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding];
}

+ (void)nt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

+ (void)nt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getClassMethod(self, originalSel);
    Method newMethod = class_getClassMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)nt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod([self class], originalSel);
    Method newMethod = class_getInstanceMethod([self class], newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)nt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getClassMethod([self class], originalSel);
    Method newMethod = class_getClassMethod([self class], newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)nt_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nt_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)nt_setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)nt_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)nt_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)nt_removeAllAssociatedValues {
    objc_removeAssociatedObjects(self);
}

+ (void)nt_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)nt_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

+ (void)nt_setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (id)nt_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

+ (void)nt_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

+ (void)nt_removeAllAssociatedValues {
    objc_removeAssociatedObjects(self);
}

+ (NSArray *)nt_getAllPropertyNames {
    NSMutableArray *allNames = @[].mutableCopy;
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(self, &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertys);
    return allNames.copy;
	
}

+ (NSArray *)nt_getAllIvarNames{
    NSMutableArray *allNames = @[].mutableCopy;
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(self, &ivarCount);
    for (int i = 0; i < ivarCount; i ++) {
        Ivar ivar = ivars[i];
        const char * ivarName = ivar_getName(ivar);
        [allNames addObject:[NSString stringWithUTF8String:ivarName]];
    }
    free(ivars);
    return allNames.copy;
}

+ (NSArray *)nt_getAllInstanceMethodsNames {
    NSMutableArray *methodNames = @[].mutableCopy;
    unsigned int count;
    Method *methods = class_copyMethodList(self, &count);
    for (int i = 0; i < count; i++){
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        if (name){
            [methodNames addObject:name];
        }
    }
    free(methods);
    return methodNames.copy;
	
}

+ (NSArray *)nt_getAllClassMethodsNames {
    return [objc_getMetaClass([NSStringFromClass(self) UTF8String]) nt_getAllInstanceMethodsNames];
}

- (void)nt_setAllNSStringPropertyWithString:(NSString *)string {
    NSArray *attributes = [[self class] _nt_getAllPropertyAttributesInClass];
    [attributes enumerateObjectsUsingBlock:^(NSString *attributeString, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSObject _nt_propertyWithAttribute:attributeString isClass:[NSString class]]) {
            NSString * propertyName = [NSObject _nt_getPropertyNameWithAttribute:attributeString];
            SEL setterMethod = [NSObject _nt_getSetterMethodWithProertyName:propertyName];
            if ([self respondsToSelector:setterMethod]) {
                [self performSelectorOnMainThread:setterMethod withObject:string waitUntilDone:YES];
            }
        }
    }];
}

static void *const kNSObjectNTAddKVOBlockKey = "com.nineton.nsobject.ntadd.kvoblockkey";
static void *const kNSObjectNTAddKVOSemaphoreKey = "com.nineton.nsobject.ntadd.kvosemaphoreKey";

- (void)nt_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    dispatch_semaphore_t kvoSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTAddKVOSemaphoreKey];
    dispatch_semaphore_wait(kvoSemaphore, DISPATCH_TIME_FOREVER);
    //取出存有所有KVOTarget的字典
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTAddKVOBlockKey);
    if (!allTargets) {
        //没有则创建
        allTargets = [NSMutableDictionary new];
        //绑定在该对象中
        objc_setAssociatedObject(self, kNSObjectNTAddKVOBlockKey, allTargets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    //获取对应keyPath中的所有target
    _NTBlockTarget *targetForKeyPath = allTargets[keyPath];
    if (!targetForKeyPath) {
        //没有则创建
        targetForKeyPath = [_NTBlockTarget new];
        //保存
        allTargets[keyPath] = targetForKeyPath;
        //如果第一次，则注册对keyPath的KVO监听
        [self addObserver:targetForKeyPath forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    [targetForKeyPath nt_addBlock:block];
    //对第一次注册KVO的类进行dealloc方法调剂
    [self _nt_swizzleDealloc];
    dispatch_semaphore_signal(kvoSemaphore);
}
- (void)nt_removeObserverBlockForKeyPath:(NSString *)keyPath{
    if (!keyPath.length) return;
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTAddKVOBlockKey);
    if (!allTargets) return;
    _NTBlockTarget *target = allTargets[keyPath];
    if (!target) return;
    dispatch_semaphore_t kvoSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTAddKVOSemaphoreKey];
    dispatch_semaphore_wait(kvoSemaphore, DISPATCH_TIME_FOREVER);
    [self removeObserver:target forKeyPath:keyPath];
    [allTargets removeObjectForKey:keyPath];
    dispatch_semaphore_signal(kvoSemaphore);
}

- (void)nt_removeAllObserverBlocks {
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTAddKVOBlockKey);
    if (!allTargets) return;
    dispatch_semaphore_t kvoSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTAddKVOSemaphoreKey];
    dispatch_semaphore_wait(kvoSemaphore, DISPATCH_TIME_FOREVER);
    [allTargets enumerateKeysAndObjectsUsingBlock:^(id key, _NTBlockTarget *target, BOOL *stop) {
        [self removeObserver:target forKeyPath:key];
    }];
    [allTargets removeAllObjects];
    dispatch_semaphore_signal(kvoSemaphore);
}

static void *const kNSObjectNTaddNotificationBlockKey = "com.nineton.nsobject.ntadd.notificationBlockKey";
static void *const kNSObjectNTaddNotificationSemaphoreKey = "com.nineton.nsobject.ntadd.semaphoreKey";

- (void)nt_addNotificationForName:(NSString *)name block:(void (^)(NSNotification *notification))block {
    if (!name || !block) return;
    dispatch_semaphore_t notificationSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTaddNotificationSemaphoreKey];
    dispatch_semaphore_wait(notificationSemaphore, DISPATCH_TIME_FOREVER);
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTaddNotificationBlockKey);
    if (!allTargets) {
        allTargets = @{}.mutableCopy;
        objc_setAssociatedObject(self, kNSObjectNTaddNotificationBlockKey, allTargets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _NTBlockTarget *target = allTargets[name];
    if (!target) {
        target = [_NTBlockTarget new];
        allTargets[name] = target;
        [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(nt_doNotification:) name:name object:nil];
    }
    [target nt_addNotificationBlock:block];
    [self _nt_swizzleDealloc];
    dispatch_semaphore_signal(notificationSemaphore);
    
}

- (void)nt_removeNotificationForName:(NSString *)name{
    if (!name) return;
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTaddNotificationBlockKey);
    if (!allTargets.count) return;
    _NTBlockTarget *target = allTargets[name];
    if (!target) return;
    dispatch_semaphore_t notificationSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTaddNotificationSemaphoreKey];
    dispatch_semaphore_wait(notificationSemaphore, DISPATCH_TIME_FOREVER);
    [[NSNotificationCenter defaultCenter] removeObserver:target];
    [allTargets removeObjectForKey:name];
    dispatch_semaphore_signal(notificationSemaphore);
    
}

- (void)nt_removeAllNotification{
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kNSObjectNTaddNotificationBlockKey);
    if (!allTargets.count) return;
    dispatch_semaphore_t notificationSemaphore = [self _nt_getSemaphoreWithKey:kNSObjectNTaddNotificationSemaphoreKey];
    dispatch_semaphore_wait(notificationSemaphore, DISPATCH_TIME_FOREVER);
    [allTargets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _NTBlockTarget *target, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:target];
    }];
    [allTargets removeAllObjects];
    dispatch_semaphore_signal(notificationSemaphore);
}

- (void)nt_postNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

- (void)nt_addKeyboardObserve:(void (^)(BOOL, float))config{
    [self nt_addNotificationForName:UIKeyboardWillChangeFrameNotification block:^(NSNotification * _Nonnull notification) {
        if ([notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height) {
            BOOL isShow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y != [UIScreen mainScreen].bounds.size.height;
            CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                NT_BLOCK(config, isShow, keyboardHeight);
            });
        }
    }];
}

#pragma mark - private methods

static void * kNSObjectNTaddDeallocHasSwizzledKey = "com.nineton.nsobject.ntadd.dealloc_has_swizzled_key";

/**
 *  调剂dealloc方法，由于无法直接使用运行时的swizzle方法对dealloc方法进行调剂，所以稍微麻烦一些
 */
- (void)_nt_swizzleDealloc{
    //我们给每个类绑定上一个值来判断dealloc方法是否被调剂过，如果调剂过了就无需再次调剂了
    BOOL swizzled = [objc_getAssociatedObject(self.class, kNSObjectNTaddDeallocHasSwizzledKey) boolValue];
    //如果调剂过则直接返回
    if (swizzled) return;
    //开始调剂
    Class swizzleClass = self.class;
    //获取原有的dealloc方法
    SEL deallocSelector = sel_registerName("dealloc");
    //初始化一个函数指针用于保存原有的dealloc方法
    __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
    //实现我们自己的dealloc方法，通过block的方式
    id newDealloc = ^(__unsafe_unretained id objSelf){
        //在这里我们移除所有的KVO
        [objSelf nt_removeAllObserverBlocks];
        //移除所有通知
        [objSelf nt_removeAllNotification];
        //根据原有的dealloc方法是否存在进行判断
        if (originalDealloc == NULL) {//如果不存在，说明本类没有实现dealloc方法，则需要向父类发送dealloc消息(objc_msgSendSuper)
            //构造objc_msgSendSuper所需要的参数，.receiver为方法的实际调用者，即为类本身，.super_class指向其父类
            struct objc_super superInfo = {
                .receiver = objSelf,
                .super_class = class_getSuperclass(swizzleClass)
            };
            //构建objc_msgSendSuper函数
            void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
            //向super发送dealloc消息
            msgSend(&superInfo, deallocSelector);
        }else{//如果存在，表明该类实现了dealloc方法，则直接调用即可
            //调用原有的dealloc方法
            originalDealloc(objSelf, deallocSelector);
        }
    };
    //根据block构建新的dealloc实现IMP
    IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
    //尝试添加新的dealloc方法，如果该类已经复写的dealloc方法则不能添加成功，反之则能够添加成功
    if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
        //如果没有添加成功则保存原有的dealloc方法，用于新的dealloc方法中
        Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
        originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
        originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
    }
    //标记该类已经调剂过了
    objc_setAssociatedObject(self.class, kNSObjectNTaddDeallocHasSwizzledKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)_nt_getAllPropertyAttributesInClass{
    NSMutableArray *allNames = @[].mutableCopy;
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(self, &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getAttributes(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertys);
    return allNames.copy;
}

+ (BOOL)_nt_propertyWithAttribute:(NSString *)attributeString isClass:(Class)className{
    NSString *classSring = NSStringFromClass(className);
    if ([[NSObject _nt_getPropertyClassNameWithAttribute:attributeString] isEqualToString:classSring]) {
        return YES;
    }
    return NO;
}

+ (NSString *)_nt_getPropertyClassNameWithAttribute:(NSString *)attributeString{
    if (!attributeString.length) {
        return nil;
    }
    if ([attributeString rangeOfString:@"\""].location == NSNotFound || [attributeString rangeOfString:@"@"].location == NSNotFound) {
        return nil;
    }
    return [attributeString componentsSeparatedByString:@"\""][1];
}

+ (NSString *)_nt_getPropertyNameWithAttribute:(NSString *)attributeString{
    if (!attributeString.length) {
        return nil;
    }
    NSArray *temp = [attributeString componentsSeparatedByString:@"_"];
    if (temp.count < 2) {
        return nil;
    }
    return temp[1];
}

- (dispatch_semaphore_t)_nt_getSemaphoreWithKey:(void *)key{
    dispatch_semaphore_t semaphore = objc_getAssociatedObject(self, key);
    if (!semaphore) {
        semaphore = dispatch_semaphore_create(1);
    }
    return semaphore;
}

+ (SEL)_nt_getSetterMethodWithProertyName:(NSString *)proertyName{
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:",proertyName.firstCharUpperString]);
}

@end

