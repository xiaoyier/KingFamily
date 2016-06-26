//
//  UIView+Frame.h
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//给分类添加属性，需要重写其set,get方法，但是不会生成带下划线的成员变量
@property (nonatomic,assign) CGFloat X;
@property (nonatomic,assign) CGFloat Y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@end
