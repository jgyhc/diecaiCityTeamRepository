//
//  NSFileManager+NTAdd.h
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/6.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, NTFileManagerSortType) {
    NTFileManagerSortTypeByCreatTime = 0,
    NTFileManagerSortTypeByModifyTime,
    NTFileManagerSortTypeByFileSize,
};

@interface NSFileManager (NTAdd)

+ (BOOL)nt_isFileExistsAtPath:(NSString *)path;
+ (BOOL)nt_isDirectoryExistsAtPath:(NSString *)path;
+ (BOOL)nt_creatDirectoryAtPath:(NSString *)path;
+ (BOOL)nt_deletFileAtPath:(NSString *)path;
+ (BOOL)nt_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

+ (NSString *)nt_sizeStringAtPath:(NSString *)path;//保留小数点2为的大小字符串 自动判别KB、MB、GB
+ (unsigned long long)nt_sizeValueAtPath:(NSString *)path;

/**
 对文件夹文件进行排序，并返回排序路径数据
 */
+ (NSArray<NSString *> *)nt_sortDirectoryAtPath:(NSString *)path by:(NTFileManagerSortType)sortType ascend:(BOOL)ascend;

/**
 将文件夹保持在某个大小（采取删除部分文件的方式），如果此文件夹只有一个文件该方法无效，删除按照排序的结果从排序数组的第一个路径依次删除
 */
+ (void)nt_holdDirectoryAtPath:(NSString *)path forSize:(unsigned long long)size deleteBy:(NTFileManagerSortType)sortType ascend:(BOOL)ascend;

@end
