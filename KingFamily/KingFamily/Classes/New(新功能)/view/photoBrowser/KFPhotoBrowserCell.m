//
//  KFPhotoBrowserCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoBrowserCell.h"
#import "KFShopItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"
@interface KFPhotoBrowserCell ()

@end

@implementation KFPhotoBrowserCell

- (UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:imgView];
        _imgView = imgView;
    }
    return _imgView;
}

- (void)setItem:(KFShopItem *)item
{
    _item = item;
    
    //获取缓存图片
    UIImage *img = [[SDImageCache sharedImageCache]imageFromMemoryCacheForKey:item.q_pic_url];
    if (img == nil) {
        img = [UIImage imageNamed:@"empty_picture"];
    }
    
    self.imgView.frame = [UIImage calculateImageFrame:img];
    
    NSURL *url = [NSURL URLWithString:item.z_pic_url];
    
    [self.imgView sd_setImageWithURL:url placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //重新计算高清图的尺寸
        self.imgView.frame = [UIImage calculateImageFrame:image];
    }];
    
    
}


////计算图片尺寸
//- (CGRect)calculateImageFrame:(UIImage *)image
//{
//    CGFloat imageW = Screen_Width;
//    CGFloat imageH = imageW / image.size.width * image.size.height;
//    if (imageH > Screen_Height){
//        imageH = Screen_Height;
//    }
//    
//    CGFloat imageX = 0;
//    CGFloat imageY = (Screen_Height - imageH) * 0.5;
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}


@end
