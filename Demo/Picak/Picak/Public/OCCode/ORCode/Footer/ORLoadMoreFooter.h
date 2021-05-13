//
//  ORLoadMoreFooter.h
//  NTStartget
//
//  Created by 欧阳荣 on 2018/7/12.
//  Copyright © 2018 NineTonTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefreshFooter.h>

@interface ORLoadMoreFooter : MJRefreshFooter


- (BOOL)animating;

@property (nonatomic, assign) CGFloat verticalInset;
@property (nonatomic, assign) CGFloat triggerInset;

@property (nonatomic, copy) NSString *loadingText;
@property (nonatomic, copy) NSString *endText;

@property (nonatomic, copy) BOOL (^endRefreshTxtHidde)(void);

- (void)refreshBottowTxt;

@end
