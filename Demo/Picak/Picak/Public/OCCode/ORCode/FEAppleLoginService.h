//
//  FEAppleLoginService.h
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/2.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEAppleLoginService : NSObject

typedef void (^AppleRequestSuccess)(NSString * userId, NSString * authCode, NSString * identityToken);
typedef void (^AppleRequestFailure)(NSError * error);

@property (nonatomic, readonly) BOOL enable;


- (void)fe_appleRequest:(AppleRequestSuccess)successBlock error:(AppleRequestFailure)failureBlock;


@end

NS_ASSUME_NONNULL_END
