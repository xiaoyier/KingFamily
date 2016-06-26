//
//  KFSectionHeaderView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSectionHeaderView.h"
#import <Masonry.h>

@interface KFSectionHeaderView ()

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *subTitleLabel;
@property (nonatomic,weak) UIView *line;

@end

@implementation KFSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
        [self setLayout];
    }
    
    return self;
}

//初始化设置
- (void)initialSetup
{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kFont16;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = KFColor(50, 50, 50);
    [self addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KFColor(200, 200, 200);
    [self addSubview:line];
    _line = line;
    
}

//布局子控件
- (void)setLayout
{
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-13.0f);
        make.height.equalTo(@0.8f);
        make.width.equalTo(@35);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(10.0f);
    }];

    

    
        /*
     [_redLine mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.mas_left);
     make.centerY.equalTo(self.mas_centerY);
     make.width.equalTo(@2);
     make.height.equalTo(@15);
     }];
     [_label mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(_redLine.mas_right).offset(3);
     make.centerY.equalTo(self.mas_centerY);
     make.right.equalTo(self.mas_right);
     make.height.equalTo(@15);
     }];
     */
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    if (subTitle == nil) {
        _subTitleLabel.bounds = CGRectZero;
    }
    _subTitleLabel.text = subTitle;
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_line.mas_top).offset(-5.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    
}



@end
