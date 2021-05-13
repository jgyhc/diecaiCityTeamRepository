//
//  UITableView+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/17.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UITableView+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(UITableView_NTAdd)

@implementation UITableView (NTAdd)

- (void)nt_updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}
@end
