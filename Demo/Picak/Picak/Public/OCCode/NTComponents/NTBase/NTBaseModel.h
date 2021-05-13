//
//  XWBaseModel.h
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTBaseModel : NSObject

+ (NSArray *)nt_modelArrayWithDictArray:(NSArray<NSDictionary *> *)dictArray;

+ (instancetype)nt_modelWithDict:(NSDictionary *)dict;


#pragma mark - Overwrite Methods

- (void)nt_parseDict:(NSDictionary *)dict flag:(BOOL *)skip;

@end
