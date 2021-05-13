//
//  XWBaseCollectionViewCell.m
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NTBaseCollectionViewCell.h"
#import "NTCatergory.h"

@implementation NTBaseCollectionViewCell{
    __weak UICollectionView *_collectionView;
}

+ (instancetype)nt_cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath model:(__kindof NSObject *)model{
    __kindof NTBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (!cell->_collectionView) cell->_collectionView = collectionView;
    cell->_model = model;
    [cell nt_updateUI];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self nt_initailizeUI];
    [self nt_addUserEvents];
    return self;
}

+ (NSString *)cellIdentifier{
    NSString *_theCellIdentifier = [self nt_getAssociatedValueForKey:_cmd];
    if (!_theCellIdentifier) {
        _theCellIdentifier =  [NSString stringWithFormat:@"_%@Identifier", NSStringFromClass(self)];
        [self nt_setAssociateValue:_theCellIdentifier withKey:_cmd];
    }
    return _theCellIdentifier;
}

- (NSIndexPath *)indexPath{
    return [_collectionView indexPathForCell:self];
}

- (void)nt_updateUI{}
- (void)nt_addUserEvents{};
- (void)nt_initailizeUI{};

@end
