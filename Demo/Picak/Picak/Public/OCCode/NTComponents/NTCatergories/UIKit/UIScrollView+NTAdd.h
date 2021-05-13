//
//  UIScrollView+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (NTAdd)

@property (assign, nonatomic) CGFloat insetT;
@property (assign, nonatomic) CGFloat insetB;
@property (assign, nonatomic) CGFloat insetL;
@property (assign, nonatomic) CGFloat insetR;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

- (void)nt_scrollToTop;
- (void)nt_scrollToBottom;
- (void)nt_scrollToLeft;
- (void)nt_scrollToRight;
- (void)nt_scrollToTopAnimated:(BOOL)animated;
- (void)nt_scrollToBottomAnimated:(BOOL)animated;
- (void)nt_scrollToLeftAnimated:(BOOL)animated;
- (void)nt_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
