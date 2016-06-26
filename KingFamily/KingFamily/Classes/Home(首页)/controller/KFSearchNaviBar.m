//
//  KFSearchNaviBar.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSearchNaviBar.h"
#import <Masonry/Masonry.h>

@interface KFSearchNaviBar() <UISearchBarDelegate>

@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,weak) UIButton *rightButton;

@end

@implementation KFSearchNaviBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = Bar_TintColor;
    
    //初始化设置
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    [self addSubview:searchBar];
    searchBar.placeholder = @"搜索喜欢的宝贝";
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    _searchBar = searchBar;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _rightButton = button;
    
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(30);
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(30);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(_rightButton.mas_left).offset(-10);
    }];
    
}


- (void)cancel
{
    if (_cancelBlock != nil) {
        _cancelBlock();
    }
}


#pragma mark --UISearchBarDelegate---

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"开始输入");
}


@end
