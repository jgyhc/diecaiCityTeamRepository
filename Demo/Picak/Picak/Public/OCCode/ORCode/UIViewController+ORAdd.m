//
//  UIViewController+ORAdd.m
//  NTHandleBarrage
//
//  Created by 欧阳荣 on 2018/4/2.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import "UIViewController+ORAdd.h"

@implementation UIViewController (ORAdd)

/// 获取当前正在显示的ViewController
+ (UIViewController *)currentViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVc findBestViewController:rootVc];
}

/// 获取当前正在显示的ViewController
- (UIViewController *)currentViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:rootVc];
}

- (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (void)or_showAlert:(NSString *)title message:(NSString *)msg {
    [self or_showAlert:title message:msg okAction:nil];
}

- (void)or_showOnlySureAlert:(NSString *)title message:(NSString *)msg okAction:(dispatch_block_t)block {
    [self or_showAlert:title message:msg hasCancel:NO okAction:block cancelAction:nil];
}

- (void)or_showAlert:(NSString *)title message:(NSString *)msg okAction:(dispatch_block_t)block {
    [self or_showAlert:title message:msg hasCancel:YES okAction:block cancelAction:nil];
}

- (void)or_showAlert:(NSString *)title message:(NSString *)msg hasCancel:(BOOL)hasCancel okAction:(dispatch_block_t)okBlock cancelAction:(dispatch_block_t)cancelBlock {
    [self _or_showAlert:title message:msg actionTitles:@[@"Done"] actionTitles:nil style:UIAlertControllerStyleAlert hasCancel:hasCancel completion:^(NSInteger index) {
        if (okBlock) {
            okBlock();
        }
    } cancel:cancelBlock];

}

- (void)or_showAlert:(NSString *)title message:(NSString *)msg destructiveActionTitle:(NSString *)actiontitle style:(UIAlertControllerStyle)style completion:(dispatch_block_t)block {
    
    [self _or_showAlert:title message:msg actionTitles:@[actiontitle] actionTitles:@[@2] style:style hasCancel:YES completion:^(NSInteger index) {
        if (block) {
            block();
        }
    } cancel:nil];
}

- (void)or_showAlert:(NSString *)title message:(NSString *)msg actionTitles:(NSArray<NSString *> *)actionTitles style:(UIAlertControllerStyle)style completion:(void (^)(NSInteger))block {
    
    [self _or_showAlert:title message:msg actionTitles:actionTitles actionTitles:nil style:style hasCancel:YES completion:block cancel:nil];
}

#pragma mark -- private Methods

- (void)_or_showAlert:(NSString *)title message:(NSString *)msg actionTitles:(NSArray<NSString *> *)actionTitles actionTitles:(NSArray *)actionStyles style:(UIAlertControllerStyle)style hasCancel:(BOOL)hasCancel completion:(void (^)(NSInteger))block cancel:(dispatch_block_t)cancelBlock{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:msg attributes:@{NSFontAttributeName : NTFontWithScaleRegular(17)}];
//    [alert setValue:attr forKey:@"attributedMessage"];

    if (hasCancel) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancle", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alert addAction:cancelAction];
    }
    
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertActionStyle style = idx >= actionStyles.count ? 0 : [actionStyles[idx] integerValue];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:style handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(idx);
            }
        }];
        
        [alert addAction:action];
    }];
    
    
    
    [self presentViewController:alert animated:true completion:nil];
}

@end
