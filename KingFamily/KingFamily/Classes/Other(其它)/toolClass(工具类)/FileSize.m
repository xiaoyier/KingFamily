//
//  FileSize.m
//
//  Created by Sycamore on 16/5/2.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "FileSize.h"

@implementation FileSize

+ (NSInteger)getFileSizeWithPath:(NSString *)path
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //防止使用的饿人乱传值进来，需要做一些处理
    BOOL isDirectory = NO;
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        NSException *exception = [NSException exceptionWithName:@"FileError" reason:@"请传入文件夹路径进来" userInfo: nil];
        
        //记得，异常要抛出
        [exception raise];
    }
    
    //获得所有子路径,此方法会遍历所有子目录以及子目录的子目录，一直遍历下去
    NSArray *subPaths = [manager subpathsAtPath:path];
    NSInteger totleSize = 0;
    //遍历子路径，拼接完整路径
    for (NSString *subPath in subPaths) {
        NSString *fullPath = [path stringByAppendingPathComponent:subPath];
        
        //判断，进行优化,去除隐藏文件夹
        if ([fullPath containsString:@".DS"]) continue;
        
        BOOL isDirectory = NO;
        BOOL isExists = [manager fileExistsAtPath:fullPath isDirectory:&isDirectory];
        //去除空文件夹
        if (!isExists || isDirectory) continue;
        
        NSDictionary *fileAttr = [manager attributesOfItemAtPath:fullPath error:nil];
        
        totleSize += [fileAttr fileSize];
        
    }

    return totleSize;
}


+ (void)removeFilesAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //防止使用的人乱传值进来，需要做一些处理
    BOOL isDirectory = NO;
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        NSException *exception = [NSException exceptionWithName:@"FileError" reason:@"请传入文件夹路径进来" userInfo: nil];
        
        //记得，异常要抛出
        [exception raise];
    }

    NSArray *subPaths = [manager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *subPath in subPaths ) {
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        
        //移除文件夹
        [manager removeItemAtPath:filePath error:nil];
    }

}

@end
