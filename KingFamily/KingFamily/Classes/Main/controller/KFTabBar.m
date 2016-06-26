//
//  KFTabBar.m
//
//  Created by Sycamore on 16/4/27.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFTabBar.h"

@interface KFTabBar ()

@property (nonatomic,weak) UIButton *publishButton;

@end

@implementation KFTabBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    //创建发布按钮
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
    [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
    _publishButton = publishButton;
    [self addSubview:publishButton];
    
    //监听按钮的点击
    [publishButton addTarget:self action:@selector(publishButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger index = 0;
    CGFloat y = 0;
    CGFloat width = self.width / (self.items.count + 1);
    CGFloat height = self.height;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == 2) {
                index ++;
            }
            view.frame = CGRectMake(index * width, y, width, height);
//            BSLog(@"%@",NSStringFromCGRect(view.frame));
            index ++;

        }
        _publishButton.center = [self convertPoint:self.center fromView:self.superview];
        _publishButton.width = width;
        _publishButton.height = height;
    }
    
    
}


- (void)publishButtonDidClick
{
//    BSFunction;
    self.operation();
}


@end
