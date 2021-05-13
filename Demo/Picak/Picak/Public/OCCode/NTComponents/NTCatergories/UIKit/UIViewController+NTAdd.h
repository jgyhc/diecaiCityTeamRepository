//
//  UIViewController+NTAdd.h
//  XWPhotoPicker
//
//  Created by wazrx on 16/8/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NTAdd)

@property (readonly) BOOL isViewVisible;
@property (nonatomic, readonly) UIViewController *nt_topViewController;

- (UIViewController *)nt_findTopVCWithExcludeVCInfos:(NSArray<NSString *> *)infos;

@end
