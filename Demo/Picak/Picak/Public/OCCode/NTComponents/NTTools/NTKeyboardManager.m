//
//  XWKeyboardManager.m
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTKeyboardManager.h"
#import "NTCatergory.h"


__attribute__((constructor))
static void NTStartKeyboardAbserve(){
    NT_LOG(@"开启键盘监听");
    [NTKeyboardManager shareKeyboardManager];
}

@interface NTKeyboardManager ()
@property (nonatomic, readwrite) CGFloat keyboardHeight;
@property (nonatomic, readwrite) BOOL isKeyboardVisble;
@property (nonatomic, strong) NSMutableSet *showBlockSet;
@property (nonatomic, strong) NSMutableSet *hiddenBlockSet;

@end

@implementation NTKeyboardManager
NTSingletonM(KeyboardManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showBlockSet = [NSMutableSet new];
        _hiddenBlockSet = [NSMutableSet new];
        [self _nt_addKeyboardObserve];
    }
    return self;
}

- (void)_nt_addKeyboardObserve{
    NT_WEAKIFY(self);
    [self nt_addNotificationForName:UIKeyboardWillChangeFrameNotification block:^(NSNotification * _Nonnull notification) {
        NT_STRONGIFY(self);
        if ([notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height) {
            if ([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y == NT_SCREEN_HEIGHT) {
                self.keyboardHeight = 0;
                self.isKeyboardVisble = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hiddenBlockSet enumerateObjectsUsingBlock:^(dispatch_block_t  _Nonnull obj, BOOL * _Nonnull stop) {
                        NT_BLOCK(obj);
                    }];
                });
                
            }else{
                self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
                self.isKeyboardVisble = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.showBlockSet enumerateObjectsUsingBlock:^(dispatch_block_t  _Nonnull obj, BOOL * _Nonnull stop) {
                        NT_BLOCK(obj);
                    }];
                    NT_LOG(@"调用键盘block");
                });
            }
        }
    }];
}

- (void)nt_setKeyboardWillShow:(dispatch_block_t)keyboardWillShow{
    [_showBlockSet addObject:keyboardWillShow];
}

- (void)nt_setKeyboardWillHidden:(dispatch_block_t)keyboardWillHidden{
    [_hiddenBlockSet addObject:keyboardWillHidden];
    
}

@end
