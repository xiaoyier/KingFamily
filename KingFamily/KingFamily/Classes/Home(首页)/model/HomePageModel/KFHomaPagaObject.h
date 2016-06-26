//
//  KFHomaPagaObject.h
//  KingFamily
//
//  Created by Sycamore on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFHomaPagaObject : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,assign,getter=isSingleItem) BOOL SingleItem;   //表示是否section里只显示一行

- (instancetype)initWithTitle:(NSString *)title array:(NSMutableArray *)array singleItem:(BOOL)singleItem;

+ (instancetype)objectWithTitle:(NSString *)title array:(NSMutableArray *)array singleItem:(BOOL)singleItem;

@end
