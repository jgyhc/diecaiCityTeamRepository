//
//  FEAppleLoginService.m
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/2.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEAppleLoginService.h"
#import <AuthenticationServices/AuthenticationServices.h>

API_AVAILABLE(ios(13.0))
@interface FEAppleLoginService ()<ASAuthorizationControllerDelegate>

@property (nonatomic, strong) ASAuthorizationController * authorizationController;
@property (nonatomic, copy) AppleRequestSuccess successBlock;
@property (nonatomic, copy) AppleRequestFailure failureBlock;

@end

@implementation FEAppleLoginService

- (BOOL)enable {
    return !!NSClassFromString(@"ASAuthorizationController");
}

- (void)fe_appleRequest:(AppleRequestSuccess)successBlock error:(AppleRequestFailure)failureBlock {
    if (self.enable) {
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        [self.authorizationController performRequests];
    }
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])       {
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        NSString * user = credential.user;
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
         
        if (self.successBlock) {
            self.successBlock(user, authorizationCode, identityToken);
        }
    }
}
 
- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    if (self.failureBlock) {
        self.failureBlock(error); // error.code => ASAuthorizationError
    }
}

- (ASAuthorizationController *)authorizationController API_AVAILABLE(ios(13.0)) {
    if (_authorizationController == nil) {
        ASAuthorizationAppleIDProvider * provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest * request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
         
        _authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        _authorizationController.delegate = self;
    }
    return _authorizationController;
}


@end
