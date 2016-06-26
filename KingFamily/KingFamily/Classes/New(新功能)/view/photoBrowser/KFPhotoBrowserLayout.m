//
//  KFPhotoBrowserLayout.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoBrowserLayout.h"

@implementation KFPhotoBrowserLayout


- (void)prepareLayout
{
    //注意，这里很重要！折腾了好久，设置view的宽度比屏幕宽度大的时候，两个cell之间一定要有间距
    self.minimumInteritemSpacing = 15;
    self.minimumLineSpacing = 15;
    self.itemSize = Screen_Size;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    
    
}

@end
