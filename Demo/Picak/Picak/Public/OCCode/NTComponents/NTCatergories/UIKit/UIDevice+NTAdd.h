//
//  UIDevice+NTAdd.h
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/2/25.
//  Copyright © 2016年 wazrx. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NT_CURRENT_DEVICE
#define NT_CURRENT_DEVICE [UIDevice currentDevice]
#endif

#ifndef NT_IS_IPAD
#define NT_IS_IPAD [UIDevice currentDevice].isPad
#endif

typedef NS_ENUM(NSUInteger, NTDeviceHeightType) {
    NTDeviceHeightTypeIPhone6 = 0, //6 And 7
    NTDeviceHeightTypeHeightType6Plus, //6P and 7P
    NTDeviceHeightTypeIPhone5, //5 and 5s
    NTDeviceHeightTypeIPhone4, // 4 and 4s
    NTDeviceHeightTypeIPhoneX, // iphoneX
};

typedef NS_ENUM(NSUInteger, NTLocationStatus) {
    NTLocationStatusNotDetermined = 0,
    NTLocationStatusAuthorized,
    NTLocationStatusDenied
};

@interface UIDevice (NTAdd)

#pragma mark - device info (设备信息相关)

@property (nonatomic, readonly) NTDeviceHeightType deviceHeightType;

@property (nonatomic,readonly) NSString *idfv;

@property (nonatomic,readonly) NSString *macString;

@property (nonatomic,readonly) NSString *uuid;

@property (nonatomic, readonly) BOOL isPad;

@property (nonatomic, readonly) BOOL isSimulator;

@property (nonatomic, readonly) BOOL hasCamera;

@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

@property (nonatomic, readonly) NSUInteger cpuNumber;

//8.0,9.1
@property (nonatomic, readonly) double systemVersionValue;

//"iPhone9,2"
@property (nonatomic, readonly) NSString *modelInfo;

//"iPhone 5s"
@property (nonatomic, readonly) NSString *modelInfoName;

//"中国移动"
@property (nonatomic, readonly) NSString *moblieOperatorName;

//@"192.168.1.111，wifi的内网ip"
@property (nonatomic, readonly) NSString *ipAddressWIFI;
//外网ip
@property (nonatomic, readonly) NSString *ipAddressWaiWIFI;

//@"10.2.2.222,蜂窝移动网络IP"
@property (nonatomic, readonly) NSString *ipAddressCell;

@property (nonatomic, readonly) int64_t diskSpace;

@property (nonatomic, readonly) int64_t diskSpaceFree;

@property (nonatomic, readonly) int64_t diskSpaceUsed;

@property (nonatomic, readonly) int64_t memoryTotal;

#pragma mark - check Allow (判断系统行为是否允许，通知定位等)

@property (nonatomic, readonly) BOOL allowNotification;
@property (nonatomic, readonly) NTLocationStatus locationStatus;

@property (nonatomic, readonly) BOOL allowLocation;

#pragma mark - open setting (打开系统设置界面)

/**
 *  打开系统通知界面
 *
 *  @param completeBlock 回到app后的回调
 */
+ (void)nt_openSystemNotificationSettingPageWithCompleteHandle:(void(^)(BOOL isAllowed))completeBlock;

/**打开设置界面*/
+ (void)nt_openSystemSettingPage;


+ (NSDictionary *)nt_getAllDeviceInfo;

+ (void)nt_idfaWithResult:(void(^)(NSString *))result;

@end

NS_ASSUME_NONNULL_END
