//
//  HomeNaviTitleView.h
//  KingFamily
//
//  Created by Sycamore on 16/4/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
//注意block的定义方式
typedef void(^Operation)() ;

@interface HomeNaviTitleView : UIView

@property (nonatomic,copy) NSString *cityTitle;

//定义一个block，当自己的按钮点击时候，将控制器跳转的block给传过来
@property (nonatomic,copy) Operation operation;

+ (instancetype)homeNaviTitleView;



@end
