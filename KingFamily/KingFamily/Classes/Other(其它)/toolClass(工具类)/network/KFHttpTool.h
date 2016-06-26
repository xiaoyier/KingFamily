//
//  KFHttpTool.h
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^completionBlock)(NSArray *result , NSError *error);

@interface KFHttpTool : AFHTTPSessionManager


single_interface(KFHttpTool)

- (void)loadDataWithOffset:(NSInteger)offSet completionBlock:(completionBlock)completionBlock;

@end
