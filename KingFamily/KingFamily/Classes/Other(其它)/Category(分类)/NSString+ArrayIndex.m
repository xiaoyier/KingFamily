//
//  NSString+ArrayIndex.m
//  KingFamily
//
//  Created by Sycamore on 16/4/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "NSString+ArrayIndex.h"

@implementation NSString (ArrayIndex)


//根据索引获取指定数组里的指定字符串
+ (NSString *)stringWithArray:(NSArray *)array index:(NSInteger )index
{
    if (array.count == 0) {
        return nil;
    }
    NSString *newString = @"" ;
    for (NSInteger i = index * 20; i < (index + 1) * 20; i ++) {
        NSString *string = array[i];
        if (i == index * 20) {
            newString = [newString stringByAppendingFormat:@"[%@,",string] ;
            //            NSLog(@"%@",newString);
        }
        else if ( i > index * 20 && i < (index + 1) * 20 - 1 )
        {
            newString = [newString stringByAppendingFormat:@"%@,",string];
        }
        else{
            newString = [newString stringByAppendingFormat:@"%@]",string];
            
        }
    }
//    NSLog(@"%@",newString);
    
    return newString;
}



@end
