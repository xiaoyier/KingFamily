//
//  KFHttpTool.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHttpTool.h"

@implementation KFHttpTool

single_implementation(KFHttpTool)

- (void)loadDataWithOffset:(NSInteger)offSet completionBlock:(completionBlock)completionBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"http://mobapi.meilishuo.com/2.0/twitter/popular.json?offset=%ld&limit=30&access_token=b92e0c6fd3ca919d3e7547d446d9a8c2",offSet];
    
    [self GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        NSArray *resultArr = responseObject[@"data"];
        
        completionBlock(resultArr, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil,error);
    }];
}


@end
