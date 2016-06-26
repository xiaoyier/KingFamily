//
//  KFCategoryGoodsCell.m
//  商品
//
//  Created by XUYAN on 16/4/18.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFCategoryGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@interface KFCategoryGoodsCell()
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;

@end
@implementation KFCategoryGoodsCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setGoodItem:(KFCategoryGoodItem *)goodItem{
    _goodItem = goodItem;
    
    [_goodBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:goodItem.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_default_goods"]];
    
}
@end
