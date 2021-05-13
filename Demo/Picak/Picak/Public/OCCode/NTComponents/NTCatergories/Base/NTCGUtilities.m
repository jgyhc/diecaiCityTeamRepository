//
//  NTCGUtilities.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/16.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTCGUtilities.h"
#import "UIDevice+NTAdd.h"

CGFloat NTScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}


CGFloat NTScreenWidthRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    });
    return ratio;
//    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
//    CGFloat ratio;
//    CGFloat base = [[UIDevice currentDevice] respondsToSelector:@selector(isPad)] && [UIDevice currentDevice].isPad ? isPortrait ? 768.0f : 1024.0f : 375.0f;
//    CGFloat width = [[UIDevice currentDevice] respondsToSelector:@selector(isPad)] && [UIDevice currentDevice].isPad ? [UIScreen mainScreen].bounds.size.width : isPortrait ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
//    ratio = width / base;
//    return ratio;
}

CGFloat NTScreenHeightRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.height / 667.0f;
    });
    return ratio;
//    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
//    CGFloat ratio;
//    CGFloat base = [[UIDevice currentDevice] respondsToSelector:@selector(isPad)] && [UIDevice currentDevice].isPad ? isPortrait ? 1024.0f : 768.0f : 667.0f;
//    CGFloat height = [[UIDevice currentDevice] respondsToSelector:@selector(isPad)] && [UIDevice currentDevice].isPad ? [UIScreen mainScreen].bounds.size.height : isPortrait ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
//    ratio = height / base;
//    return ratio;
}

CGSize NTScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
    });
    return size;
}

CGRect NTScreenBounds(){
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [UIScreen mainScreen].bounds;
    });
    return bounds;
}

CGPoint NTScreenCenter(){
    static CGPoint center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = NTCenterOfFrame(NTScreenBounds());
    });
    return center;
}


