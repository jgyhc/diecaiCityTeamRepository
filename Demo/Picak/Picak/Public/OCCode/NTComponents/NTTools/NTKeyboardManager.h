//
//  XWKeyboardManager.h
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTSingleton.h"

@interface NTKeyboardManager : NSObject
@property (nonatomic, readonly) CGFloat keyboardHeight;
@property (nonatomic, readonly) BOOL isKeyboardVisble;

- (void)nt_setKeyboardWillShow:(dispatch_block_t)keyboardWillShow;
- (void)nt_setKeyboardWillHidden:(dispatch_block_t)keyboardWillHidden;

NTSingletonH(KeyboardManager)
@end
