


#import <Foundation/Foundation.h>

@interface FileSize : NSObject
/**
 *  给定一个文件夹路径，返回该文件夹的尺寸
 *
 *  @param path 文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getFileSizeWithPath:(NSString *)path;

/**
 *  给定一个文件夹，删除该文件夹下的所有子文件夹
 *
 *  @param path 文件夹全路径
 */
+ (void)removeFilesAtPath:(NSString *)path;

@end
