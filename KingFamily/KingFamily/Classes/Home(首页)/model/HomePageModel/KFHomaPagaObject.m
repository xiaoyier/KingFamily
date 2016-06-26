//
//  KFHomaPagaObject.m
//  KingFamily
//
//  Created by Sycamore on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomaPagaObject.h"

@implementation KFHomaPagaObject


- (instancetype)initWithTitle:(NSString *)title array:(NSMutableArray *)array singleItem:(BOOL)singleItem
{
    if (self = [super init]) {
        self.title = title;
        self.array = array;
        self.SingleItem = singleItem;
    }
    return self;

}

+ (instancetype)objectWithTitle:(NSString *)title array:(NSMutableArray *)array singleItem:(BOOL)singleItem
{
    return [[self alloc]initWithTitle:title array:array singleItem:singleItem];
}


@end
