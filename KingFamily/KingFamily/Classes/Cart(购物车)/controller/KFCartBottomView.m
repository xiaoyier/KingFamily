//
//  KFCartBottomView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCartBottomView.h"

@interface KFCartBottomView ()

@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;


@end

@implementation KFCartBottomView

+ (instancetype)cartBottomView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFCartBottomView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _topLine.height = 0.5;
    self.autoresizingMask = UIViewAutoresizingNone;
    [[NSNotificationCenter defaultCenter]addObserverForName:CartTradeTimeOut object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _allSelectBtn.hidden = YES;
    }];
    
}

- (void)setTotleCount:(CGFloat)totleCount
{
    _totleCount = totleCount;
    _allCountLabel.text = [NSString stringWithFormat:@"总计 ¥ %.1f",totleCount];
    
    //默认让全选按钮显示出来
    _allSelectBtn.hidden = NO;
    
}
- (IBAction)gotoAccount:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cartBottomView:didClickAccountButton:)]) {
        [self.delegate cartBottomView:self didClickAccountButton:_gotoAccountBtn];
    }
    
    
}
- (IBAction)SelectAll:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cartBottomView:didClickAllSelectButton:)]) {
        [self.delegate cartBottomView:self didClickAllSelectButton:_allSelectBtn];
    }
}


@end
