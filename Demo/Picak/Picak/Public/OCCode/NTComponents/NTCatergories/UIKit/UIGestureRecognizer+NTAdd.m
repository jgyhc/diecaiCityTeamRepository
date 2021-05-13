//
//  UIGestureRecognizer+NTAdd.m
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/12.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIGestureRecognizer+NTAdd.h"
#import "NSObject+NTAdd.h"

@interface _NTGestureTargetObject : NSObject

@property (nonatomic, copy) void(^config)(UIGestureRecognizer *gestureRecognizer);
@end

@implementation _NTGestureTargetObject

- (void)_nt_event:(UIGestureRecognizer *)gestureRecognizer{
    if (_config) {
        _config(gestureRecognizer);
    }
}

@end

@implementation UIGestureRecognizer (NTAdd)

+ (instancetype)nt_recognizerWithBlock:(void (^)(__kindof UIGestureRecognizer*))config{
    _NTGestureTargetObject *target = [_NTGestureTargetObject new];
    target.config = config;
    UIGestureRecognizer *gesture = [[self alloc] initWithTarget:target action:@selector(_nt_event:)];
    [gesture nt_setAssociateValue:target withKey:"nt_gestureTargetObject"];
    return gesture;
}

- (void)nt_setActionBlock:(void (^)(__kindof UIGestureRecognizer *))config{
    _NTGestureTargetObject *target = [self nt_getAssociatedValueForKey:"nt_gestureTargetObject"];
    if (!target) {
        target = [_NTGestureTargetObject new];
        [self nt_setAssociateValue:target withKey:"nt_gestureTargetObject"];
    }
    target.config = config;
    [self removeTarget:nil action:nil];
    [self addTarget:target action:@selector(_nt_event:)];
    
}

@end
