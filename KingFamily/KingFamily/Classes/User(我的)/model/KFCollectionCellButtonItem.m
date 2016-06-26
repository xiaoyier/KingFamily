//
//  KFCollectionCellButtonItem.m
//  KingFamily
//
//  Created by iOS小工匠 on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCollectionCellButtonItem.h"

@implementation KFCollectionCellButtonItem
+(instancetype)collectionCellButtonItemWithImageName:(NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle
{
    KFCollectionCellButtonItem *item = [[self alloc] init];
    item.imageName = imageName;
    item.title = title;
    item.detailTitle = detailTitle;
    return item;
}
@end
