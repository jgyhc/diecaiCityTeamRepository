//
//  NTLoadMoreFooter.m
//  NTStartget
//
//  Created by 欧阳荣 on 2018/7/12.
//  Copyright © 2018 NineTonTech. All rights reserved.
//

#import "ORLoadMoreFooter.h"
#import "UIColor+NTAdd.h"
#import "UIFont+NTAdd.h"
#import "UIView+NTAdd.h"

@interface ORLoadMoreFooter ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

/** 一个新的拖拽 */
@property (assign, nonatomic, getter=isOneNewPan) BOOL oneNewPan;
@property (assign, nonatomic) BOOL noAutoLoad;

@end

@implementation ORLoadMoreFooter

- (void)layoutSubviews {
    [super layoutSubviews];
    [_tipLabel sizeToFit];
    CGSize size = _tipLabel.bounds.size;
    CGFloat x = (self.bounds.size.width - size.width - 38) / 2.0;
    CGFloat y = (self.bounds.size.height - 30) / 2.0;
    _indicatorView.frame = CGRectMake(x, y, 30, 30);
    _tipLabel.frame = CGRectMake(x + 38, y, size.width, size.height);
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIActivityIndicatorView new];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = ({
            UILabel *label = [UILabel new];
            label.font = NTFontRegular(NTWidthRatio(11));
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label;
        });
        [self addSubview:_tipLabel];

        
//        UIView *line1 = [UIView new];
//        line1.backgroundColor = NT_HEX(#F4F5FB);
//        [self addSubview:line1];
//        [line1 nt_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self->_tipLabel);
//            make.left.nt_offset(15);
//            make.height.nt_offset(0.5);
//            make.right.mas_equalTo(self->_tipLabel.mas_left).nt_offset(-15);
//        }];
//        _leftLine = line1;
//
//        UIView *line2 = [UIView new];
//        line2.backgroundColor = NT_HEX(#F4F5FB);
//        [self addSubview:line2];
//        [line2 nt_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self->_tipLabel);
//            make.right.nt_offset(15);
//            make.height.nt_offset(0.5);
//            make.left.mas_equalTo(self->_tipLabel.mas_right).nt_offset(15);
//        }];
//        _rightLine = line2;
//
//        line2.hidden = YES;
//        line1.hidden = YES;
    }
    return _tipLabel;
}

- (void)setVerticalInset:(CGFloat)verticalInset {
    _verticalInset = verticalInset;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (BOOL)animating {
    return self.indicatorView.isAnimating;
}



#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.mj_insetB += self.mj_h;
        }
        
        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.mj_insetB -= self.mj_h;
        }
    }
}


#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    _verticalInset = -10;
    _triggerInset = 80;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.mj_y = self.scrollView.mj_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.noAutoLoad || self.state != MJRefreshStateIdle || self.mj_y == 0 || self.animating) return;
    
    if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h + 40) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        
        CGFloat currentOffset = _scrollView.contentOffset.y;
        CGFloat maximumOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
        
        if (maximumOffset > 0 && maximumOffset - currentOffset <= _triggerInset) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != MJRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    if (panState == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  // 不够一个屏幕
            if (_scrollView.mj_offsetY >= - _scrollView.mj_insetT) { // 向上拽
//                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h + 40) {
                [self beginRefreshing];
            }
        }
    } else if (panState == UIGestureRecognizerStateBegan) {
        self.oneNewPan = YES;
    }
}

- (void)beginRefreshing
{
    [ORLoadMoreFooter cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:4];
    
    if (!self.isOneNewPan) return;
    
    [super beginRefreshing];
    
    if (self.scrollView.contentSize.height > self.scrollView.nt_height) {
        self.tipLabel.text = _loadingText ? _loadingText : NSLocalizedString(@"loading", nil);
    }else {
        self.tipLabel.text = nil;
    }
    

    if (self.leftLine.hidden) {
        self.leftLine.hidden = NO;
        self.rightLine.hidden = NO;
    }
    
    self.oneNewPan = NO;
    [self.indicatorView startAnimating];
}

- (void)endRefreshing {
    [super endRefreshing];
    
//    [self refreshBottowTxt]; //这个弄了 就会终止自动刷新
    [self.indicatorView stopAnimating];
}

- (void)endRefreshingWithNoMoreData {
    [super endRefreshingWithNoMoreData];
    
    [self refreshBottowTxt];

    [self.indicatorView stopAnimating];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateRefreshing && MJRefreshStateIdle == oldState) {
        [self executeRefreshingCallback];
    } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        if (MJRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
    
    if (self.scrollView.contentSize.height <= self.scrollView.nt_height) {
        self.tipLabel.text = nil;
    }
    
//    // 根据状态做事情
//    if (state == MJRefreshStateIdle) {
////        if (oldState == MJRefreshStateRefreshing) {
////            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
////            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
////                self.loadingView.alpha = 0.0;
////            } completion:^(BOOL finished) {
////                // 防止动画结束后，状态已经不是MJRefreshStateIdle
////                if (state != MJRefreshStateIdle) return;
////
////                self.loadingView.alpha = 1.0;
////                [self.loadingView stopAnimating];
////
////                self.arrowView.hidden = NO;
////            }];
////        } else {
//            self.arrowView.hidden = NO;
//            [self.loadingView stopAnimating];
//            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//            }];
////        }
//    } else if (state == MJRefreshStatePulling) {
//        self.arrowView.hidden = NO;
//        [self.loadingView stopAnimating];
//        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//            self.arrowView.transform = CGAffineTransformIdentity;
//        }];
//    } else if (state == MJRefreshStateRefreshing) {
//        self.arrowView.hidden = YES;
//        [self.loadingView startAnimating];
//    } else if (state == MJRefreshStateNoMoreData) {
//        self.arrowView.hidden = YES;
//        [self.loadingView stopAnimating];
//    }
    
}

- (void)refreshBottowTxt {
    
    _noAutoLoad = YES;
    
    
    [ORLoadMoreFooter cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(_or_delayAutoLoad) withObject:nil afterDelay:3];
    
    if (self.scrollView.contentSize.height > self.scrollView.nt_height && self.canShowTxt) {
        self.tipLabel.text = _endText ? _endText : NSLocalizedString(@"no more data", nil);
        //到底了，没有更多数据
        self.state = MJRefreshStateNoMoreData;
        
//        if ([NTNetTool nt_getNetStatus] == NTNetStatusTypeNotReachable) {
//            self.tipLabel.text = NSLocalizedString(@"呀！没网啦", nil);
//        }
        self.leftLine.hidden = NO;
        self.rightLine.hidden = NO;
    } else {
        self.leftLine.hidden = YES;
        self.rightLine.hidden = YES;
        self.tipLabel.text = nil;
    }
}

- (void)_or_delayAutoLoad {
    self.noAutoLoad = NO;
}

- (BOOL)canShowTxt {
    BOOL hidde = !self.endRefreshTxtHidde || self.endRefreshTxtHidde();
    return hidde;
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        
        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;
        
        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    }
}


@end
