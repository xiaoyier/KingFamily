//
//  KFCartCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCartCell.h"
#import "KFCartTradeItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FMDBHelper.h"

@interface KFCartCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeName;
@property (weak, nonatomic) IBOutlet UILabel *tradePrice;
@property (weak, nonatomic) IBOutlet UILabel *tradeCount;
@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
@property (weak, nonatomic) IBOutlet UIView *addOrMinusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickBtnWidthCoonstraint;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation KFCartCell

- (void)setFrame:(CGRect)frame
{
    frame.size.height = 80;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    
}


- (void)setTradeItem:(KFCartTradeItem *)tradeItem
{
    _tradeItem = tradeItem;
    
    [_tradeImageView sd_setImageWithURL:[NSURL URLWithString:tradeItem.image] placeholderImage:[UIImage imageNamed:@"home_default_hot"]];
    _tradeName.text = tradeItem.title;
    _tradePrice.text = [NSString stringWithFormat:@"￥ %@",tradeItem.price];
    _tradeCount.text = [NSString stringWithFormat:@"X %ld",(long)tradeItem.buyCount];
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)tradeItem.buyCount];
    
    
    //设置选中按钮的状态
    if (tradeItem.buyCount == 0) {
        tradeItem.isClicked = YES;
    }
    _pickBtn.selected = !tradeItem.isClicked;          //如果没点击就是选中，如果点击了就是没选中
    _minusButton.enabled = _tradeItem.buyCount > 0;
    
    _pickBtn.hidden = tradeItem.leftTime <= 0;
    _pickBtnWidthCoonstraint.constant = tradeItem.leftTime > 0? 35 : 0;
    _addOrMinusView.hidden = tradeItem.leftTime <= 0;
    

    [[NSNotificationCenter defaultCenter]addObserverForName:CartTradeTimeOut object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        _pickBtn.hidden = YES;
        _pickBtnWidthCoonstraint.constant = 0;
        _addOrMinusView.hidden = YES;
    }];
}

//增加商品购买数量
- (IBAction)add:(UIButton *)sender {
    
    _tradeItem.buyCount ++;
    self.tradeCount.text = [NSString stringWithFormat:@"X %ld",(long)_tradeItem.buyCount];
    _countLabel.text = [NSString stringWithFormat:@"%ld",_tradeItem.buyCount];
    
    NSString *where = [NSString stringWithFormat:@"title = '%@'",_tradeItem.title];
    NSString *buyCountStr = [NSString stringWithFormat:@"%ld",_tradeItem.buyCount];
    [FMDBHelper update:FMDBNoneCartTable keyValues:@{@"buyCount" : buyCountStr} where:where];

    
    //判断减号按钮是否可以点击
    _minusButton.enabled = YES;
    
    //按钮点击  发布通知
    [[NSNotificationCenter defaultCenter]postNotificationName:CartCellAdd object:self];
    
}

//减少商品购买数量
- (IBAction)minus:(UIButton *)sender {
    
    _tradeItem.buyCount --;
    self.tradeCount.text = [NSString stringWithFormat:@"X %ld",_tradeItem.buyCount];
    _countLabel.text = [NSString stringWithFormat:@"%ld",_tradeItem.buyCount];

    NSString *where = [NSString stringWithFormat:@"title = '%@'",_tradeItem.title];
    NSString *buyCountStr = [NSString stringWithFormat:@"%ld",_tradeItem.buyCount];
    [FMDBHelper update:FMDBNoneCartTable keyValues:@{@"buyCount" : buyCountStr} where:where];
    
    //判断减号按钮是否可以点击
    _minusButton.enabled = _tradeItem.buyCount > 0;
    
    //按钮点击  发布通知
    [[NSNotificationCenter defaultCenter]postNotificationName:CartCellMinus object:self];
    
}

//点击选中按钮
- (IBAction)pickButtonClick:(UIButton *)sender {
    
    _pickBtn.selected = !_pickBtn.selected;
    _tradeItem.isClicked = !_tradeItem.isClicked;
    
    //告知控制器，从总价中移除
    [[NSNotificationCenter defaultCenter]postNotificationName:CartCellPickButtonClick object:self];
}

@end
