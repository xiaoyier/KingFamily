//
//  KFBrandFoodCell.m
//  商品
//
//  Created by XUYAN on 16/5/5.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFBrandFoodCell.h"
#import "UIButton+WebCache.h"
@interface KFBrandFoodCell()
@property (weak, nonatomic) IBOutlet UIButton *btnL;
@property (weak, nonatomic) IBOutlet UIButton *btnR;

@end

@implementation KFBrandFoodCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setImageItem:(KFBrandImageItem *)imageItem{
    _imageItem = imageItem;

    [self.btnL sd_setBackgroundImageWithURL:[NSURL URLWithString:imageItem.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"food"]];
   
}


-(void)setImageItem1:(KFBrandImageItem *)imageItem1{
    _imageItem1 = imageItem1;
    
    [self.btnR sd_setBackgroundImageWithURL:[NSURL URLWithString:imageItem1.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"food"]];
    
}


@end
