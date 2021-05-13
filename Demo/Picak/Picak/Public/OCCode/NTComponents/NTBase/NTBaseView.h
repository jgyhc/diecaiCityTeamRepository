//
//  XWBaseView.h
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTBaseView : UIView

@property (nonatomic, readonly) __kindof NSObject *viewModel;

+ (instancetype)nt_viewWithViewModel:(__kindof NSObject *)viewModel NS_REQUIRES_SUPER;


#pragma mark - Overwrite Methods
- (void)nt_initailizeUI;
- (void)nt_addUserEvents;


@end
