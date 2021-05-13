//
//  XWBaseModel.m
//  haveFun
//
//  Created by 肖文 on 2017/2/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NTBaseModel.h"

@implementation NTBaseModel

+ (NSArray *)nt_modelArrayWithDictArray:(NSArray<NSDictionary *> *)dictArray{
    if (!dictArray.count) return nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dictArray.count];
    __block BOOL skip = NO;
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof NTBaseModel *model = [self new];
        skip = NO;
        [model nt_parseDict:obj flag:&skip];
        if (!skip) {
            [temp addObject:model];
        }
    }];
    return temp.copy;
}

+ (instancetype)nt_modelWithDict:(NSDictionary *)dict{
    __block BOOL skip = NO;
    __kindof NTBaseModel *model = [self new];
    [model nt_parseDict:dict flag:&skip];
    if (skip) return nil;
    return model;
}

- (void)nt_parseDict:(NSDictionary *)dict flag:(BOOL *)skip{};

@end
