//
//  NSDictionary+jasonStringToJasonDic.m
//
//
//  Created by Sycamor on 16/5/8.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "NSDictionary+jasonStringToJasonDic.h"

@implementation NSDictionary (jasonStringToJasonDic)
/**
 *  字符串类型的jason返回字典类型的jason数据
 *
 *  @param jsonString
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
