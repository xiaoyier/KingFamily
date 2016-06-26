//
//  KFCollectionCellButtonItem.h
//  KingFamily
//
//  Created by iOS小工匠 on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFCollectionCellButtonItem : NSObject
// 图片
@property(nonatomic, strong)NSString *imageName;
// 标题
@property(nonatomic, strong)NSString *title;
// 子标题
@property(nonatomic, strong)NSString *detailTitle;

+(instancetype)collectionCellButtonItemWithImageName:(NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle;
@end
