//
//  UIImage+Resize.h
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (instancetype)resizeImage:(UIImage *)image Size:(CGSize)size;


//计算图片尺寸
+ (CGRect)calculateImageFrame:(UIImage *)image;

@end
