//
//  KFPhotoHomeCell.h
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KFShopItem;
@interface KFPhotoHomeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) KFShopItem *item;

@end
