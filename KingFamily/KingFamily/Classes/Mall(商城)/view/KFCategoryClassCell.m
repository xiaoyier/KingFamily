//
//  KFCategoryClassCell.m
//  商品
//
//  Created by XUYAN on 16/4/18.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFCategoryClassCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "KFDetailedCategoryVC.h"
@interface KFCategoryClassCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet UIView *leftV;
@property (weak, nonatomic) IBOutlet UIView *rightV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *nameR;
@property (weak, nonatomic) IBOutlet UILabel *desc1L;
@property (weak, nonatomic) IBOutlet UILabel *desc2L;
@property (weak, nonatomic) IBOutlet UILabel *desc1R;
@property (weak, nonatomic) IBOutlet UILabel *desc2R;

@end

@implementation KFCategoryClassCell

- (void)awakeFromNib {
    UITapGestureRecognizer *panL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panL)];
    [self.leftV addGestureRecognizer:panL];
    
    UITapGestureRecognizer *panR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panR)];
    [self.rightV addGestureRecognizer:panR];
    
}

-(void)panL{
    NSLog(@"l");
    NSDictionary *userInfo = @{@"num":@1};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"category" object:self userInfo:userInfo];
}

-(void)panR{
    NSDictionary *userInfo = @{@"num":@2};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"category" object:self userInfo:userInfo];

}


-(void)setCategoryItem:(KFCategoryItem *)CategoryItem{
    _CategoryItem = CategoryItem;
    [self.leftImageV sd_setImageWithURL:[NSURL URLWithString:CategoryItem.image] placeholderImage:[UIImage imageNamed:@"food"]];
    self.nameL.text = CategoryItem.name;
    self.desc1L.text = CategoryItem.desc1;
    self.desc2L.text = CategoryItem.desc2;
}
-(void)setCategoryItem1:(KFCategoryItem *)categoryItem1{
    _categoryItem1 = categoryItem1;
    [self.rightImageV sd_setImageWithURL:[NSURL URLWithString:categoryItem1.image] placeholderImage:[UIImage imageNamed:@"food"]];
    self.nameR.text = categoryItem1.name;
    self.desc1R.text = categoryItem1.desc1;
    self.desc2R.text = categoryItem1.desc2;
    
}
@end
