//
//  NSDictionary+PropertyName.m
//  
//
//  Created by Sycamore on 16/4/17.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "NSDictionary+PropertyName.h"

@implementation NSDictionary (PropertyName)

- (void)createPropertyName
{
    
    //初始化一个字符串，用来拼接
    NSMutableString *codes = [NSMutableString string];
    
    //遍历每个key,取出来
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *code;
        
        //根据value的类型去添加
        if ([value isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic,copy) NSString *%@;",key];
        }
        else if ([value isKindOfClass:[NSDictionary class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSDictionary *%@;",key];

        }
        
        else if ([value isKindOfClass:[NSArray class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSArray *%@;",key];
            
        }
        
        //注意，bool类型为__NSCFBoolean,为系统的私有类，我们是不能直接使用的
        else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;",key];
            
        }
        else if ([value isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) int %@;",key];
            
        }
       

        //拼接字符串
        [codes appendFormat:@"\n%@\n",code];
    }];
    //将拼接完成的字符串打印出来
    NSLog(@"%@",codes);
}

@end
