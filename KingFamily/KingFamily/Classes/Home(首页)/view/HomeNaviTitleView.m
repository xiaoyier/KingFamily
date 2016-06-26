//
//  HomeNaviTitleView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "HomeNaviTitleView.h"
#import "KFHomeTitleButton.h"

@interface HomeNaviTitleView ()
@property (weak, nonatomic) IBOutlet UIImageView *titleView;

@property (weak, nonatomic) IBOutlet KFHomeTitleButton *dropMenuButton;
@end

@implementation HomeNaviTitleView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialSetUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self initialSetUp];
}

//初始化设置
- (void)initialSetUp
{
    self.backgroundColor = [UIColor clearColor];
    _cityTitle = @"广东";
    [self.dropMenuButton setTitle:_cityTitle forState:UIControlStateNormal];
    self.dropMenuButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.dropMenuButton setImage:[UIImage imageNamed:@"siteArrow"] forState:UIControlStateNormal];
    
    [self.dropMenuButton addTarget:self action:@selector(dropMenuButtonDidClick) forControlEvents:UIControlEventTouchDown];
    //已经确定好内部子空间的位置尺寸后，就不需要调用sizeToFit了
//    [self.dropMenuButton sizeToFit];

}

//按钮点击，交由控制器去处理
- (void)dropMenuButtonDidClick
{
    //将代码块传进来，在这里面处理；
    self.operation();
}

- (void)setCityTitle:(NSString *)cityTitle
{
    _cityTitle = cityTitle;
    [self.dropMenuButton setTitle:cityTitle forState:UIControlStateNormal];
}


+ (instancetype)homeNaviTitleView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"HomeNaviTitleView" owner:nil options:nil]lastObject];
}
@end
