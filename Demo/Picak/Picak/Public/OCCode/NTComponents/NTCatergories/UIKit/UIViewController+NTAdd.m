//
//  UIViewController+NTAdd.m
//  XWPhotoPicker
//
//  Created by wazrx on 16/8/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIViewController+NTAdd.h"
#import "NTCategoriesMacro.h"
#import "NSObject+NTAdd.h"
#import "NSString+NTAdd.h"

NT_SYNTH_DUMMY_CLASS(UIViewController_NTAdd)

@implementation UIViewController (NTAdd)



- (BOOL)isViewVisible{
    return [self isViewLoaded] && [[self view] window] != nil;
}

- (UIViewController *)nt_topViewController{
    UIViewController *vc = self;
    if (vc.presentedViewController) {
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
    }
    if ([vc isKindOfClass:[UINavigationController class]]){
        vc = ((UINavigationController *)vc).viewControllers.lastObject;
    }
    return vc;
}

- (UIViewController *)nt_findTopVCWithExcludeVCInfos:(NSArray<NSString *> *)infos{
    if (!infos.count) return self.nt_topViewController;
    UIViewController *vc = self;
    if (vc.presentedViewController) {
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        while (vc.presentingViewController && [self _nt_checkVC:vc excludeInfos:infos]) {
            vc = vc.presentingViewController;
        }
    }
    if ([vc isKindOfClass:[UINavigationController class]]){
        NSMutableArray *temp = ((UINavigationController *)vc).viewControllers.mutableCopy;
        vc = temp.lastObject;
        while (temp.count > 1 && [self _nt_checkVC:vc excludeInfos:infos]) {
            [temp removeLastObject];
            vc = temp.lastObject;
        }
    }
    return vc;
}

- (BOOL)_nt_checkVC:(UIViewController *)vc excludeInfos:(NSArray<NSString *> *)infos{
    __block BOOL needExclude = NO;
    for (NSString *info in infos) {
        if ([NSStringFromClass([vc class]) nt_containsString:info]) {
            needExclude = YES;
            return YES;
        }
    }
    return NO;
}

@end
