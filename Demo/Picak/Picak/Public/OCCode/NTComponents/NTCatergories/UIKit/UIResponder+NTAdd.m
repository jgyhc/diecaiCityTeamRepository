//
//  UIResponder+NTAdd.m
//  WeChatBusinessTool
//
//  Created by 肖文 on 2016/10/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIResponder+NTAdd.h"
#import "NTCategoriesMacro.h"
#import <objc/message.h>

@implementation UIResponder (NTAdd)

- (void)nt_setHandleURLConfig:(BOOL (^)(NSURL *))config{
    [self _nt_swizzeHandelURLMethods:config];
}

- (void)_nt_swizzeHandelURLMethods:(BOOL(^)(NSURL * config))config{
//    Class swizzleClass = NT_APPLICATION.delegate.class;
//    SEL originalSelector1 = sel_registerName("application:handleOpenURL:");
//    id newMethod1 = ^BOOL(__unsafe_unretained id objSelf, UIApplication *application, NSURL *url){
//        if (config) {
//            return config(url);
//        }
//        return YES;
//    };
//    IMP newIMP1 = imp_implementationWithBlock(newMethod1);
//    NT_LOG(@"%zd", class_addMethod(swizzleClass, originalSelector1, newIMP1, "i@:@@"))
//    
//    SEL originalSelector2 = sel_registerName("application:openURL:options:");
//    id newMethod2 = ^BOOL(__unsafe_unretained id objSelf, UIApplication *application, NSURL *url, NSDictionary * options){
//        if (config) {
//            return config(url);
//        }
//        return YES;
//    };
//    IMP newIMP2 = imp_implementationWithBlock(newMethod2);
//    NT_LOG(@"%zd", class_addMethod(swizzleClass, originalSelector2, newIMP2, "i@:@@@"))
//    
//    SEL originalSelector3 = sel_registerName("application:openURL:sourceApplication:annotation:");
//    id newMethod3 = ^BOOL(__unsafe_unretained id objSelf, UIApplication *application, NSURL *url, NSString *souceApplication, id annotation){
//        if (config) {
//            return config(url);
//        }
//        return YES;
//    };
//    IMP newIMP3 = imp_implementationWithBlock(newMethod3);
//    NT_LOG(@"%zd", class_addMethod(swizzleClass, originalSelector3, newIMP3, "i@:@@@@"))
}

@end
