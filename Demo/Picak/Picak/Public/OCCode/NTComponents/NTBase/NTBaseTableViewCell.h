//
//  XWBaseTableViewCell.h
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTBaseTableViewCell : UITableViewCell

@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) __kindof NSObject *model;

+ (instancetype)nt_cellWithTableView:(__weak UITableView *)tableView model:(__kindof NSObject *)model;

#pragma mark - Overwrite Methods
- (void)nt_initailizeUI;
- (void)nt_addUserEvents;
- (void)nt_updateUI;
@end
