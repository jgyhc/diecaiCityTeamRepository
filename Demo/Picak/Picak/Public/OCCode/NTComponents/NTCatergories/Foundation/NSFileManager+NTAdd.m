//
//  NSFileManager+NTAdd.m
//  WeChatBusinessTool
//
//  Created by wazrx on 16/9/6.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#define FileManager [NSFileManager defaultManager]

#import "NSFileManager+NTAdd.h"
#import "NTCategoriesMacro.h"

@implementation NSFileManager (NTAdd)

+ (BOOL)nt_isFileExistsAtPath:(NSString *)path{
    return [self _nt_FileExistsAtPath:path isDirectory:NO];
}

+ (BOOL)nt_isDirectoryExistsAtPath:(NSString *)path{
    return [self _nt_FileExistsAtPath:path isDirectory:YES];
}

+ (BOOL)nt_creatDirectoryAtPath:(NSString *)path{
    if ([self _nt_FileExistsAtPath:path isDirectory:YES]) {
        return YES;
    }else {
        BOOL reslut = [FileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        return reslut;
    }
}

+ (BOOL)nt_deletFileAtPath:(NSString *)path{
    NSError *error = nil;
    [FileManager removeItemAtPath:path error:&error];
    return error ? NO : YES;
}

+ (BOOL)_nt_FileExistsAtPath:(NSString *)path isDirectory:(BOOL)isDirectory{
    if (!path.length) return NO;
    BOOL flag = NO;
    BOOL reslut = [FileManager fileExistsAtPath:path isDirectory:&flag];
    if (reslut && flag == isDirectory) {
        return YES;
    }
    return NO;
}

+ (BOOL)nt_moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    NSError *error = nil;
    [FileManager moveItemAtPath:fromPath toPath:toPath error:&error];
    return error ? NO : YES;
}

+ (unsigned long long)nt_sizeValueAtPath:(NSString *)path{
    unsigned long long size = 0;
    BOOL isDir = NO;
    BOOL exist = [FileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!exist) return size;
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [FileManager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            size += [FileManager attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    }else{
        size += [FileManager attributesOfItemAtPath:path error:nil].fileSize;
    }
    return size;
}

+ (NSString *)nt_sizeStringAtPath:(NSString *)path{
    NSString *sizeText = @"0.00KB";
    unsigned long long size = [self nt_sizeValueAtPath:path];
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%lluB", size];
    }
    return sizeText;
}

+ (NSArray<NSString *> *)nt_sortDirectoryAtPath:(NSString *)path by:(NTFileManagerSortType)sortType ascend:(BOOL)ascend{
    BOOL isDir = NO;
    BOOL exist = [FileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir || !exist) return nil;
    NSArray *paths = [FileManager subpathsAtPath:path];
    NSMutableArray *fullPaths = [NSMutableArray arrayWithCapacity:paths.count];
    [paths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fullPaths addObject:[path stringByAppendingPathComponent:obj]];
    }];
    return [fullPaths sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull path1, NSString *  _Nonnull path2) {
        NSDictionary *att1 = [FileManager attributesOfItemAtPath:ascend ? path1 : path2 error:nil];
        NSDictionary *att2 = [FileManager attributesOfItemAtPath:ascend ? path2 : path1 error:nil];
        switch (sortType) {
            case NTFileManagerSortTypeByCreatTime:
                return [[att1 objectForKey:NSFileCreationDate] compare:[att2 objectForKey:NSFileCreationDate]];;
            case NTFileManagerSortTypeByModifyTime:
                return [[att1 objectForKey:NSFileModificationDate] compare:[att2 objectForKey:NSFileModificationDate]];
            case NTFileManagerSortTypeByFileSize:
                return[[att1 objectForKey:NSFileSize] compare:[att2 objectForKey:NSFileSize]];
        }
    }];
}

+ (void)nt_holdDirectoryAtPath:(NSString *)path forSize:(unsigned long long)size deleteBy:(NTFileManagerSortType)sortType ascend:(BOOL)ascend{
    dispatch_async(dispatch_queue_create("com.nineton.ntcomponents.sortfile.queue", DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        BOOL isDir = NO;
        BOOL exist = [FileManager fileExistsAtPath:path isDirectory:&isDir];
        if (!isDir || !exist) return;
        unsigned long long directorySize = [self nt_sizeValueAtPath:path];
        if (directorySize <= size) return;
        NSMutableArray * sortArray = [NSMutableArray arrayWithArray:[self nt_sortDirectoryAtPath:path by:sortType ascend:ascend]];
        while (sortArray.count > 1 && [self nt_sizeValueAtPath:path] > size) {
            [self nt_deletFileAtPath:sortArray.firstObject];
            [sortArray removeObjectAtIndex:0];
        }
    });
}

@end
