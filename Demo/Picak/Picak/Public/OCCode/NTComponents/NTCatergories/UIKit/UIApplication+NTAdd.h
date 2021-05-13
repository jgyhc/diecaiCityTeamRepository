//
//  UIApplication+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_APPLICATION
#define NT_APPLICATION [UIApplication sharedApplication]
#endif

@interface UIApplication (NTAdd)


#pragma mark - folder path

@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;


@property (nonatomic, readonly) NSURL *tempURL;
@property (nonatomic, readonly) NSString *tempPath;

#pragma mark - appInfo

@property (nullable, nonatomic, readonly) NSString *appBundleName;
@property (nullable, nonatomic, readonly) NSString *appBundleID;
@property (nullable, nonatomic, readonly) NSString *appVersion;
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;
@property (nullable, nonatomic, readonly) UIImage *appIco;
/**是否破解，未从app store 下载，但不能完全保证正确性，*/
@property (nonatomic, readonly) BOOL isPirated;
@property (nonatomic, readonly) BOOL isDebug;
@property (nonatomic, readonly) BOOL isBeingDebugged;
@property (nonatomic, readonly) int64_t memoryUsage;
@property (nonatomic, readonly) float cpuUsage;

@property (nullable, nonatomic, readonly) UIImage *launchImage;
- (UIImage *)nt_launchImageWithLaunchScreenName:(NSString *)name;

- (void)nt_clearBadgeNumber;

- (void)nt_checkNewVersionWithAppID:(NSString *)appID completion:(void(^)(BOOL hasNew, NSString *storeURL, NSString *newVersion))completion;


@end

NS_ASSUME_NONNULL_END
