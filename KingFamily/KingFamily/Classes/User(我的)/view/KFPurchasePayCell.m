//
//  KFPurchasePayCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPurchasePayCell.h"

@interface KFPurchasePayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *payWay;

@end

@implementation KFPurchasePayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setPayInfo:(NSDictionary *)payInfo
{
    _payInfo = payInfo;
    
    _iconView.image = [UIImage imageNamed:payInfo[@"img"]];
    _payWay.text = payInfo[@"name"];
}

@end
