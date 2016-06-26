//
//  KFPhotoHomeViewLayout.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoHomeViewLayout.h"

@implementation KFPhotoHomeViewLayout

- (void)prepareLayout
{
    CGFloat margin = 12.0;
    
    //设置item尺寸
    CGFloat columCount = 3;
    CGFloat itemWH = (Screen_Width- (columCount + 1) * margin) / columCount;
    self.itemSize = CGSizeMake(itemWH, itemWH);
    
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
    
    
    self.collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
}

@end
