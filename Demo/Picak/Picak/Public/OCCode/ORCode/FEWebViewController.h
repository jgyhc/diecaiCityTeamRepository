//
//  FEWebViewController.h
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/2.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEWebViewController : UIViewController

@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *titleName; 


+ (UIViewController *)fe_webNavgationControllerWithTitle:(NSString *)title webUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
