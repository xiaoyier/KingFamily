//
//  NSString+ArrayIndex.h
//  KingFamily
//
//  Created by Sycamore on 16/4/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ArrayIndex)

//根据索引获取指定数组里的指定字符串
+ (NSString *)stringWithArray:(NSArray *)array index:(NSInteger )index;


@end
