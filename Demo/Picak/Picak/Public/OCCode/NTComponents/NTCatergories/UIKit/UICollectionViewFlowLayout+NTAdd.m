//
//  UICollectionViewFlowLayout+NTAdd.m
//  XWCurrencyExchange
//
//  Created by wazrx on 16/3/6.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UICollectionViewFlowLayout+NTAdd.h"
#import "NSObject+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UICollectionViewFlowLayout_NTAdd)

@implementation UICollectionViewFlowLayout (NTAdd)

+(void)load{
//    [self nt_swizzleInstanceMethod:@selector(prepareLayout) with:@selector(_nt_prepareLayout)];
}

- (void)setFullItem:(BOOL)nt_fullItem{
    [self nt_setAssociateValue:@(nt_fullItem) withKey:"nt_fullItem"];
}

- (BOOL)fullItem{
    BOOL test = [[self nt_getAssociatedValueForKey:"nt_fullItem"] boolValue];
    return test;
}

- (void)_nt_prepareLayout{
    [self _nt_prepareLayout];
    if (self.fullItem) {
        self.itemSize = self.collectionView.bounds.size;
    }
}

@end
