//
//  UICollectionView+NTAdd.m
//  XWPhotoPicker
//
//  Created by wazrx on 16/8/4.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UICollectionView+NTAdd.h"

@implementation UICollectionView (NTAdd)

- (NSArray *)nt_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
