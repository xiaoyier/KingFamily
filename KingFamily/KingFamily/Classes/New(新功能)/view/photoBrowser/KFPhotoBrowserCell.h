//
//  KFPhotoBrowserCell.h
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KFShopItem;
@interface KFPhotoBrowserCell : UICollectionViewCell

@property (nonatomic,strong) KFShopItem *item;
@property (nonatomic,weak) UIImageView *imgView;

@end
