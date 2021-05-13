//
//  XWBaseView.m
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NTBaseView.h"

@implementation NTBaseView

+ (instancetype)nt_viewWithViewModel:(__kindof NSObject *)viewModel{
    NTBaseView *view = [self new];
    view->_viewModel = viewModel;
    [view nt_initailizeUI];
    [view nt_addUserEvents];
    return view;
}

- (void)nt_initailizeUI{};
- (void)nt_addUserEvents{};

@end
