//
//  XWBaseTableViewCell.m
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NTBaseTableViewCell.h"
#import "NTCatergory.h"

@interface NTBaseTableViewCell ()

@end

@implementation NTBaseTableViewCell{
    __weak UITableView *_tableView;
}

+ (instancetype)nt_cellWithTableView:(UITableView *__weak)tableView model:(__kindof NSObject *)model{
    NSString *_theCellIdentifier = [self nt_getAssociatedValueForKey:_cmd];
    if (!_theCellIdentifier) {
        _theCellIdentifier = [NSString stringWithFormat:@"_%@Identifier", NSStringFromClass(self)];
        [self nt_setAssociateValue:_theCellIdentifier withKey:_cmd];
    }
    __kindof NTBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_theCellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_theCellIdentifier];
        cell->_tableView = tableView;
        [cell nt_initailizeUI];
        [cell nt_addUserEvents];
    }
    cell->_model = model;
    [cell nt_updateUI];
    return cell;
}

- (NSIndexPath *)indexPath{
    return [_tableView indexPathForCell:self];
}

- (void)nt_initailizeUI{}
- (void)nt_addUserEvents{};
- (void)nt_updateUI{}

@end
