//
//  UIImage+Render.h
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)

/**
 *  将传进来的图片返回未渲染的图片
 *
 *  @param image 图片
 *
 *  @return 未渲染的图片
 */
+ (instancetype)imageWithRenderImage:(UIImage *)image;

/**
 *  传进来图片名称，返回未渲染的图片
 *
 *  @param imageName 图片名字
 *
 *  @return 未渲染的图片
 */
- (instancetype)imageWithRenderImageNamed:(NSString *)imageName;

+ (instancetype)imageWithRenderImageNamed:(NSString *)imageName;

@end
