//
//  XWBaseCollectionViewCell.h
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, class) NSString *cellIdentifier;
@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) __kindof NSObject *model;

+ (instancetype)nt_cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath model:(__kindof NSObject *)model;

#pragma mark - Overwrite Methods
- (void)nt_initailizeUI;
- (void)nt_addUserEvents;
- (void)nt_updateUI;


@end
