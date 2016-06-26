//
//  KFLeftCell.m
//  商品
//
//  Created by XUYAN on 16/5/29.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFLeftCell.h"

@interface KFLeftCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic,weak) UIColor *seletedColor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

@implementation KFLeftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    
    _titleLabel.text = info[@"title"];
//    _titleLabel.textColor = info[@"selectedColor"];
//    _bottomLine.backgroundColor = info[@"selectedColor"];
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (_info != nil) {
        
        _titleLabel.textColor = selected? _info[@"selectedColor"] : [UIColor blackColor];
        _bottomLine.backgroundColor = selected? _info[@"selectedColor"] : [UIColor blackColor];
        _bottomLineHeight.constant = selected? 2 : 1 ;
    }
    
}




@end
