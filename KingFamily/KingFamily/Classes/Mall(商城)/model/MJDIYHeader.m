//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"

@interface MJDIYHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *s;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation MJDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // 打酱油的开关
    UIImageView *s = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dragdown"]];
    
    [self addSubview:s];
    self.s = s;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brandLogo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.logo = logo;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.color = [UIColor redColor];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.label.frame = self.bounds;
    self.label.center = CGPointMake(self.mj_w * 0.5 + 50, self.mj_h * 0.5);
    
    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 200);
    self.logo.center = CGPointMake(self.mj_w * 0.5, -self.logo.mj_h + 110);
    
    self.loading.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    
//    self.s.bounds = CGRectMake(0, 0, 20, 20);
    self.s.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    
    switch (state) {
        case MJRefreshStateIdle:
            //不加大括号会报错
        {
            [self.loading stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                self.s.transform = CGAffineTransformMakeRotation(2 * M_PI);
            }];
            self.label.text = @"加载完毕";
            self.s.hidden = NO;
            break;
        }
        case MJRefreshStatePulling:
        {
            [self.loading stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                self.s.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            self.s.hidden = NO;
            self.label.text = @"释放刷新...";
            break;
        }
        case MJRefreshStateRefreshing:
        {
            self.s.transform = CGAffineTransformMakeRotation(2 * M_PI);
            self.label.text = @"正在刷新..";
            self.s.hidden = YES;
            [UIView animateWithDuration:0.1 animations:^{
                [self.loading startAnimating];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//}

@end
