//
//  NSDictionary+jasonStringToJasonDic.h
//
//
//  Created by Sycamor on 16/5/8.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (jasonStringToJasonDic)
/**
 *  字符串类型的jason返回字典类型的jason数据
 *
 *  @param jsonString
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
