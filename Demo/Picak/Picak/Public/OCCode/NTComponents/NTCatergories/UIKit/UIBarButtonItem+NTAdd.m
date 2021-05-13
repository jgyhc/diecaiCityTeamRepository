//
//  UIBarButtonItem+NTAdd.m
//  WxSelected
//
//  Created by wazrx on 15/12/20.
//  Copyright © 2015年 wazrx. All rights reserved.
//

#import "UIBarButtonItem+NTAdd.h"
#import "UIControl+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UIBarButtonItem_NTAdd)

@interface _NTBarButtonItemTargetObject : NSObject
@property (nonatomic, weak) UIBarButtonItem *item;
@property (nonatomic, copy) void(^clickedConfg)(UIBarButtonItem *item);

@end

@implementation _NTBarButtonItemTargetObject

- (void)_nt_itemClicked{
    if (!_item || !_clickedConfg) {
        return;
    }
    _clickedConfg(_item);
}

@end

@implementation UIBarButtonItem (NTAdd)

+ (UIBarButtonItem *)nt_itemWithTitle:(NSString *)title clickedHandle:(void(^)(UIBarButtonItem *barButtonItem))clickedConfg {
    _NTBarButtonItemTargetObject *target = [_NTBarButtonItemTargetObject new];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:@selector(_nt_itemClicked)];
    target.item = item;
    target.clickedConfg = clickedConfg;
    [item nt_setAssociateValue:target withKey:_cmd];
    return item;
}

+ (UIBarButtonItem *)nt_itemWithImage:(NSString *)image highImage:(NSString *)highImage clickedHandle:(void(^)(UIBarButtonItem *barButtonItem))clickedConfg {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    UIImage *img = [UIImage imageNamed:image];
    [btn setImage:img forState:UIControlStateNormal];
    if (highImage) {
        [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    // 设置尺寸
    btn.bounds = CGRectMake(0, 0, 21 / img.size.height * img.size.width + 24, 21);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    NT_WEAKIFY(item);
    [btn nt_addConfig:^(UIControl *control) {
        NT_STRONGIFY(item);
        NT_BLOCK(clickedConfg, item);
    } forControlEvents:UIControlEventTouchUpInside];
    return item;
}

@end
