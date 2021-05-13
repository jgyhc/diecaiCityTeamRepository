
//
//  UIScrollView+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIScrollView+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIScrollView_NTAdd)

@implementation UIScrollView (NTAdd)

- (void)setInsetT:(CGFloat)insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetT;
    self.contentInset = inset;
}

- (CGFloat)insetT {
    return self.contentInset.top;
}

- (void)setInsetB:(CGFloat)insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetB;
    self.contentInset = inset;
}

- (CGFloat)insetB {
    return self.contentInset.bottom;
}

- (void)setInsetL:(CGFloat)insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetL;
    self.contentInset = inset;
}

- (CGFloat)insetL {
    return self.contentInset.left;
}

- (void)setInsetR:(CGFloat)insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetR;
    self.contentInset = inset;
}

- (CGFloat)insetR {
    return self.contentInset.right;
}

- (void)setOffsetX:(CGFloat)offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

- (CGFloat)offsetX {
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}

- (void)setContentW:(CGFloat)contentW {
    CGSize size = self.contentSize;
    size.width = contentW;
    self.contentSize = size;
}

- (CGFloat)contentW {
    return self.contentSize.width;
}

- (void)setContentH:(CGFloat)contentH {
    CGSize size = self.contentSize;
    size.height = contentH;
    self.contentSize = size;
}

- (CGFloat)contentH {
    return self.contentSize.height;
}


- (void)nt_scrollToTop {
    [self nt_scrollToTopAnimated:YES];
}

- (void)nt_scrollToBottom {
    [self nt_scrollToBottomAnimated:YES];
}

- (void)nt_scrollToLeft {
    [self nt_scrollToLeftAnimated:YES];
}

- (void)nt_scrollToRight {
    [self nt_scrollToRightAnimated:YES];
}

- (void)nt_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)nt_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)nt_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)nt_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
