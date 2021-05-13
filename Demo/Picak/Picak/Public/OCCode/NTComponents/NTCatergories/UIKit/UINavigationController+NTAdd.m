
//
//  UINavigationController+NTAdd.m
//  叮咚(dingdong)
//
//  Created by YouLoft_MacMini on 16/1/31.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UINavigationController+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UINavigationController_NTAdd)

@interface _NTInteractivePopGestureDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> originalDelegate;
@property (nonatomic) CGFloat edgeSpacing;
@end

@implementation _NTInteractivePopGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NT_LOG(@"%hhd", [self.originalDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch]);
//    CGFloat edgeSpacing = self.edgeSpacing;
//    if (!edgeSpacing) {
//        edgeSpacing = 30;
//    }
//    if (self.navigationController.childViewControllers.count == 1 || [gestureRecognizer locationInView:gestureRecognizer.view].x > edgeSpacing) {
//        return NO;
//    }
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat edgeSpacing = self.edgeSpacing;
    if (!edgeSpacing) {
        edgeSpacing = MAXFLOAT;
    }
    if (self.navigationController.childViewControllers.count == 1 || [gestureRecognizer locationInView:gestureRecognizer.view].x > edgeSpacing) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(id)press{
    return [self.originalDelegate gestureRecognizer:gestureRecognizer shouldReceivePress:press];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
@end

@implementation UINavigationController (NTAdd)

+(void)load{
    [self nt_swizzleInstanceMethod:@selector(pushViewController:animated:) with:@selector(_xw1_pushViewController:animated:)];
}

/**如果想要手势在边缘不响应始终响应pop事件而不响应有冲突的collectionView事件，可重写collectionView的hitTest方法，进行判断*/

- (void)nt_regisetFullScreenGestureWithEdgeSpacing:(CGFloat)edgeSpacing{
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handleNavigationTransition = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handleNavigationTransition];
    [pan nt_setAssociateValue:@(edgeSpacing) withKey:"nt_edgeSpacing"];
    _NTInteractivePopGestureDelegate *delegate = [_NTInteractivePopGestureDelegate new];
    delegate.navigationController = self;
    delegate.edgeSpacing = edgeSpacing;
    delegate.originalDelegate = target;
    pan.delegate = delegate;
    [self nt_setAssociateValue:pan withKey:"_nt_panGesture"];
    [self.view addGestureRecognizer:pan];
    [self nt_setAssociateValue:delegate withKey:"_nt_innerDelegate"];
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)nt_disableFullScreenGesture{
    UIPanGestureRecognizer *pan = [self nt_getAssociatedValueForKey:"_nt_panGesture"];
    pan.enabled = NO;
}

- (void)nt_enableFullScreenGesture{
    UIPanGestureRecognizer *pan = [self nt_getAssociatedValueForKey:"_nt_panGesture"];
    pan.enabled = YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat edgeSpacing = [[gestureRecognizer nt_getAssociatedValueForKey:"nt_edgeSpacing"] floatValue];
    if (!edgeSpacing) {
        edgeSpacing = MAXFLOAT;
    }
    if (self.childViewControllers.count == 1 || [gestureRecognizer locationInView:gestureRecognizer.view].x > edgeSpacing || self.view.subviews.lastObject != self.navigationBar) {
        return NO;
    }
    return YES;
}

#pragma mark - getter methods


- (BOOL)hidesBottomBarWhenEveryPushed{
    return [[self nt_getAssociatedValueForKey:"nt_hidesBottomBarWhenPushed"] boolValue];
}

- (UIImage *)customBackImage{
    return [self nt_getAssociatedValueForKey:"nt_customBackImage"];
}

- (BOOL)hideBottomLine{
    return [[self nt_getAssociatedValueForKey:"nt_hideBottomLine"] boolValue];
}

#pragma mark - setter methods

- (void)setHidesBottomBarWhenEveryPushed:(BOOL)hidesBottomBarWhenEveryPushed{
    [self nt_setAssociateValue:@(hidesBottomBarWhenEveryPushed) withKey:"nt_hidesBottomBarWhenPushed"];
}

- (void)setCustomBackImage:(UIImage *)customBackImage{
    [self nt_setAssociateValue:customBackImage withKey:"nt_customBackImage"];
}

- (void)setHideBottomLine:(BOOL)hideBottomLine{
    [self nt_setAssociateValue:@(hideBottomLine) withKey:"nt_hideBottomLine"];
    static UIView *lineView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineView = [self _nt_findHairlineImageViewUnder:self.navigationBar];
    });
    lineView.hidden = hideBottomLine;
}

#pragma mark - exchange methods


- (void)_xw1_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.hidesBottomBarWhenEveryPushed && self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    UIImage *backImage = self.customBackImage;
    if (backImage && self.viewControllers.count > 0) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(_nt_back)];
        viewController.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
    [self _xw1_pushViewController:viewController animated:animated];
}

#pragma mark - private methods

- (void)_nt_back{
    [self popViewControllerAnimated:YES];
}



- (UIImageView *)_nt_findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self _nt_findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
