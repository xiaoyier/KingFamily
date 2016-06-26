//
//  UIImage+Resize.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

/**
 *  拉伸图片
 *
 *  @param image 传入图片
 *  @param rect  要拉伸的尺寸
 *
 *  @return 返回拉伸后的图片
 */
+ (instancetype)resizeImage:(UIImage *)image Size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizeImage;
}


//计算图片尺寸
+ (CGRect)calculateImageFrame:(UIImage *)image
{
    CGFloat imageW = Screen_Width;
    CGFloat imageH = imageW / image.size.width * image.size.height;
    if (imageH > Screen_Height){
        imageH = Screen_Height;
    }
    
    CGFloat imageX = 0;
    CGFloat imageY = (Screen_Height - imageH) * 0.5;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


@end
