//
//  KFPhotoHomeCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoHomeCell.h"
#import "KFShopItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface KFPhotoHomeCell ()

@end

@implementation KFPhotoHomeCell

- (void)setItem:(KFShopItem *)item
{
    _item = item;
    
    NSURL *url = [NSURL URLWithString:item.q_pic_url];
    
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_picture"]];
}


@end
