//
//  ORPhotoCropView.m
//  KaDian
//
//  Created by 欧阳荣 on 2019/10/28.
//  Copyright © 2019 Kadian. All rights reserved.
//

#import "ORPhotoCropView.h"
#import "JPImageresizerView.h"
#import "NTCategoriesMacro.h"
#import "UIControl+NTAdd.h"

@interface ORPhotoCropView ()

@property (nonatomic, weak) JPImageresizerView *imageresizerView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation ORPhotoCropView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        _resizeWHScale = 1.0;
        [self _or_initUI];
    }
    return self;
}

- (void)_or_initUI {
    
    
    self.leftBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button;
    });
    
    self.rightBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button;
    });

    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
    
    CGFloat barHeight = [UIScreen mainScreen].bounds.size.height > 800 ? 44 : 20;

    self.leftBtn.frame = CGRectMake(12, barHeight + 8, 60, 30);
    self.rightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 72, barHeight + 8, 60, 30);
    
    NT_WEAKIFY(self);
    [self.leftBtn nt_addConfig:^(__kindof UIControl * _Nonnull control) {
        NT_STRONGIFY(self);
        [self or_hide];
    } forControlEvents:UIControlEventTouchUpInside];

    [self.rightBtn nt_addConfig:^(__kindof UIControl * _Nonnull control) {
         NT_STRONGIFY(self);
        [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
           NT_STRONGIFY(self);
           [self or_hide];
           NT_BLOCK(self.didCropImage, resizeImage);
        }];
    } forControlEvents:UIControlEventTouchUpInside];

    
    self.backgroundColor = [UIColor blackColor];
    [self layoutIfNeeded];
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)or_hide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)or_show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }completion:nil];
}



- (void)or_setUpUIWithImage:(UIImage *)image {
    
    if (image.size.width == 0 || image.size.height == 0) {
        NT_BLOCK(self.didCropImage, [UIImage imageNamed:@"head_icon"]);
        return;
    }
    
    [_imageresizerView removeFromSuperview];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(44, 0, 34, 0);
    JPImageresizerConfigure *configure = [JPImageresizerConfigure blurMaskTypeConfigureWithResizeImage:image isLight:NO make:^(JPImageresizerConfigure *configure) {
        configure.jp_contentInsets(contentInsets).jp_strokeColor(UIColor.whiteColor).jp_bgColor([UIColor blackColor]).jp_resizeImage(image);
    }];
    
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure imageresizerIsCanRecovery:nil imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        
        BOOL enabled = !isPrepareToScale;
        self.leftBtn.enabled =enabled;
        self.rightBtn.enabled =enabled;
    }];
//    imageresizerView.resizeWHScale = self.resizeWHScale;
//    imageresizerView.isLockResizeFrame  = YES;
    imageresizerView.frameType = JPClassicFrameType;
    [self insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    
}


@end

