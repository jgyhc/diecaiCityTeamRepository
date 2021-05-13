//
//  NSNotificationCenter+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_NOTIFICATION_CENTER
#define NT_NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#endif

@interface NSNotificationCenter (NTAdd)
/**保证通知在主线程上执行*/
- (void)nt_postNotificationOnMainThread:(NSNotification *)notification;
- (void)nt_postNotificationOnMainThread:(NSNotification *)notification
                             waitUntilDone:(BOOL)wait;
- (void)nt_postNotificationOnMainThreadWithName:(NSString *)name
                                            object:(nullable id)object;
- (void)nt_postNotificationOnMainThreadWithName:(NSString *)name
                                            object:(nullable id)object
                                          userInfo:(nullable NSDictionary *)userInfo;
- (void)nt_postNotificationOnMainThreadWithName:(NSString *)name
                                            object:(nullable id)object
                                          userInfo:(nullable NSDictionary *)userInfo
                                     waitUntilDone:(BOOL)wait;

@end

NS_ASSUME_NONNULL_END

