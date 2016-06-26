//
//  KFCartTradeItem.h
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFCartTradeItem : NSObject

@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,assign) NSInteger buyCount;
@property (nonatomic,assign) NSInteger leftTime;

@property (nonatomic,assign) BOOL isClicked;         //记录该模型对应的cell是否被点击了

@end
