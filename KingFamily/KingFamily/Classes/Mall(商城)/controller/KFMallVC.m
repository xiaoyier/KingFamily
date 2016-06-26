
//
//  KFMallVC.m
//  商品
//
//  Created by XUYAN on 16/4/18.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFMallVC.h"
#import "KFCategoryVC.h"
#import "KFBrandVC.h"
@interface KFMallVC ()

@end

@implementation KFMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVC];
    
    self.navigationItem.title = @"商城";
}

-(void)setupChildVC{
    KFCategoryVC *categoryVC = [[KFCategoryVC alloc] init];
    categoryVC.title = @"分类";
    
    KFBrandVC *brandVc = [[KFBrandVC alloc]init];
    brandVc.title = @"品牌";

    [self addChildViewController:categoryVC];
    [self addChildViewController:brandVc];
    

}




@end
