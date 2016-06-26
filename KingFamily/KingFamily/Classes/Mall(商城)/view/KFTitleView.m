//
//  KFTitleView.m
//  商品
//
//  Created by XUYAN on 16/5/6.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFTitleView.h"

@interface KFTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
@implementation KFTitleView
-(instancetype)init{
    if (self = [super init]) {
        
        
    }
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

+(instancetype)titleView{

    return [[self alloc] init];
}

-(void)setBrandItem:(KFBrandItem *)brandItem{
    _brandItem = brandItem;
    self.title.text = brandItem.title;
}

@end
