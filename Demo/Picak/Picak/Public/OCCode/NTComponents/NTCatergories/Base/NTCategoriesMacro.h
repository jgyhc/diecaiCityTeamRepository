//
//  NTCategoriesMacro.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/16.
//  Copyright © 2016年 wazrx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSDate+NTAdd.h"
#ifndef NTCategoriesMacro_h
#define NTCategoriesMacro_h

#ifndef NT_USER_DEFAULTS
#define NT_USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#endif

#ifndef NT_LOCAL
#define NT_LOCAL(_s_) NSLocalizedString((_s_), nil)
#endif

#ifndef NT_ROOT_WINDOW
#define NT_ROOT_WINDOW [UIApplication sharedApplication].delegate.window
#endif

#ifndef NT_MAX_SIZE
#define NT_MAX_SIZE CGSizeMake(MAXFLOAT, MAXFLOAT)
#endif

#ifndef NT_CLAMP // 返回中间值
#define NT_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef NT_SWAP // 值交换
#define NT_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

#ifndef NT_INDEX_PATH
#define NT_INDEX_PATH(_row_, _section_) [NSIndexPath indexPathForRow:(_row_) inSection:(_section_)]
#endif

/**
 说明：在链接静态库的时候如果使用了category，在编译到静态库时，这些代码模块实际上是存在不同的obj文件里的。程序在连接Category方法时，实际上只加载了Category模块，扩展的基类代码并没有被加载。这样，程序虽然可以编译通过，但是在运行时，因为找不到基类模块，就会出现unrecognized selector 这样的错误。我们可以在Other Linker Flags中添加-all_load、-force_load、-ObjC等flag解决该问题，同时也可以使用如下的宏
 使用：
 NT_SYNTH_DUMMY_CLASS(NSString_NTAdd)
 */
#ifndef NT_SYNTH_DUMMY_CLASS
#define NT_SYNTH_DUMMY_CLASS(_name_) \
@interface NT_SYNTH_DUMMY_CLANT_ ## _name_ : NSObject @end \
@implementation NT_SYNTH_DUMMY_CLANT_ ## _name_ @end
#endif

/**
 自定义NSLog
 使用 : NT_LOG("你好%@",@"wazrx")，第一个"前面无需添加@,添加了也无所谓
 解释 : 将上面的打印换成NSLog可得到 NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" "你好%@"), __FILE__, __FUNCTION__, __LINE__, @"wazrx");  fmt用于替换为我们的输出格式字符串，__FILE__宏在预编译时会替换成当前的源文件名,__LINE__宏在预编译时会替换成当前的行号,__FUNCTION__宏在预编译时会替换成当前的函数名称,__VA_ARGS__是一个可变参数的宏,使得打印的参数可以随意，而##可以在__VA_ARGS__的参数为0的时候去掉前面的逗号，保证打印更美观直观

 */

//static inline void NTLog(NSString *fmt, ...){
//    va_list v;
//    va_start(v, fmt);
//    fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, v] UTF8String]);
//    va_end(v);
//}
//
//static inline void XWLog(NSString *fmt, ...){
//    return;
//}

#ifndef NT_LOG
#ifdef DEBUG
#define NT_LOG(fmt, ...) fprintf(stderr,"%s:%d %s\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[[NSDate date] nt_stringWithFormat:@"MM/dd/HH/mm/ss:SSS"] UTF8String], [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define NT_LOG(...)
#endif
#endif


#ifndef NT_PATH_IMAGE
#define NT_PATH_IMAGE(_i_) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:(_i_)]]
#endif

/**
 *  判断block存在后执行
 */
#ifndef NT_BLOCK
#define NT_BLOCK(_b_, ...) if(_b_){_b_(__VA_ARGS__);}
#endif

/**
 NT_STRONGIFY
 NT_STRONGIFY用来解除循环引用
 */
#ifndef NT_WEAKIFY
#if DEBUG
#if __has_feature(objc_arc)
#define NT_WEAKIFY(object) __weak __typeof__(object) weak##_##object = object
#else
#define NT_WEAKIFY(object) __block __typeof__(object) block##_##object = object
#endif
#else
#if __has_feature(objc_arc)
#define NT_WEAKIFY(object) __weak __typeof__(object) weak##_##object = object
#else
#define NT_WEAKIFY(object) __block __typeof__(object) block##_##object = object
#endif
#endif
#endif

#ifndef NT_STRONGIFY
#if DEBUG
#if __has_feature(objc_arc)
#define NT_STRONGIFY(object) __typeof__(object) object = weak##_##object
#else
#define NT_STRONGIFY(object) __typeof__(object) object = block##_##object
#endif
#else
#if __has_feature(objc_arc)
#define NT_STRONGIFY(object) __typeof__(object) object = weak##_##object
#else
#define NT_STRONGIFY(object) __typeof__(object) object = block##_##object
#endif
#endif
#endif


/**使用onExit{...}，可以在一个方法的作用域结束之后执行{}block中的代码，也就是执行_NTBlockCleanUp函数，所以对于某些方法，如果首尾呼应，为了防止最后遗忘 了某些代码，可以使用onExit将代码提前，放在合适的地方，使得逻辑更加集中！
 *原理来自黑魔法：__attribute__((cleanup(aMethod)）,用该黑魔法在一个方法中修饰一个变量A，会在该方法的作用域结束后(大括号，return等)调用aMehod函数，并且传递变量A;
 */

static __unused void _NTBlockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

#ifndef NT_ON_EXIT
#define NT_ON_EXIT __strong void(^block)(void) __attribute__((cleanup(_NTBlockCleanUp), unused)) = ^
#endif


/**去除performSelector在ARC中的警告*/
#ifndef NT_LEAK_WARNING_IGNORE
#define NT_LEAK_WARNING_IGNORE(_method_) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
_method_; \
_Pragma("clang diagnostic pop") \
} while (0)
#endif
#endif /* NTCategoriesMacro_h */


