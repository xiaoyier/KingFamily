//
//  KFSectionFooterView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/25.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSectionFooterView.h"
#import <Masonry.h>

@interface KFSectionFooterView ()

@property (nonatomic,weak) UILabel *label;

@end

@implementation KFSectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //初始化设置
        [self initialSetup];
        
        //布局
        [self setLayout];
    }
    return self;
}

- (void)initialSetup
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFont12;
    label.textColor = KFColor(50, 50, 50);
    [self addSubview:label];
    _label = label;

}

- (void)setLayout
{
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];

}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
}

@end
