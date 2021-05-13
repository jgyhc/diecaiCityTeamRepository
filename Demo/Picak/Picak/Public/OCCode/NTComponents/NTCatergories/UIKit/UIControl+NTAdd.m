//
//  UIControl+NTAdd.m
//  TryCenter
//
//  Created by wazrx on 16/6/5.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIControl+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCatergory.h"

static void * const _NTUIControlNTaddAllTargetKey = "com.nineton.uicontrol.ntadd.alltargetkey";

@interface _NTControlTargetObject : NSObject

@property (nonatomic, copy) void (^block)(__kindof UIControl *control);
@property (nonatomic, copy) dispatch_block_t simpleBlock;
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _NTControlTargetObject

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (id)initWithSimpleBlock:(dispatch_block_t)simpleBlock events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _simpleBlock = [simpleBlock copy];
        _events = events;
    }
    return self;
}


- (void)invoke:(id)sender {
    if (_block) _block(sender);
    if (_simpleBlock) _simpleBlock();
}

@end

@implementation UIControl (NTAdd)

- (void)nt_removeAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _nt_controlBlockTargets] removeAllObjects];
}

- (void)nt_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!target || !action || !controlEvents) return;
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction)
              forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)nt_addConfig:(void(^)(__kindof UIControl *control))config forControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents || !config) return;
    _NTControlTargetObject *target = [[_NTControlTargetObject alloc]
                                       initWithBlock:config events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _nt_controlBlockTargets];
    [targets addObject:target];
}

- (void)nt_addSimpleConfig:(dispatch_block_t)config forControlEvents:(UIControlEvents)controlEvents{
    if (!controlEvents || !config) return;
    _NTControlTargetObject *target = [[_NTControlTargetObject alloc]
                                      initWithSimpleBlock:config events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _nt_controlBlockTargets];
    [targets addObject:target];
    
}

- (void)nt_setConfig:(void(^)(__kindof UIControl *control))config forControlEvents:(UIControlEvents)controlEvents {
    [self nt_removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self nt_addConfig:config forControlEvents:controlEvents];
}

- (void)nt_setSimpleConfig:(dispatch_block_t)config forControlEvents:(UIControlEvents)controlEvents{
    [self nt_removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self nt_addSimpleConfig:config forControlEvents:UIControlEventTouchUpInside];
}

- (void)nt_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    NSMutableArray *targets = [self _nt_controlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_NTControlTargetObject *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (void)nt_NT_BLOCKActionForControlEvents:(UIControlEvents)controlEvents{
    if (!controlEvents) return;
    NSMutableArray *targets = [self _nt_controlBlockTargets];
    for (_NTControlTargetObject *target in targets) {
        if (target.events & controlEvents) {
            NT_BLOCK(target.simpleBlock);
            NT_BLOCK(target.block, self);
        }
    }
}

- (NSMutableArray *)_nt_controlBlockTargets {
    NSMutableArray *targets = [self nt_getAssociatedValueForKey:_NTUIControlNTaddAllTargetKey];
    if (!targets) {
        targets = @[].mutableCopy;
        [self nt_setAssociateValue:targets withKey:_NTUIControlNTaddAllTargetKey];
    }
    return targets;
}
@end
