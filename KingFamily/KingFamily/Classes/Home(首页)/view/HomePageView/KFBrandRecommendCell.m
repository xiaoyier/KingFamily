//
//  KFBrandRecommendCell.m
//  KingFamily
//
//  Created by Sycamore on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFBrandRecommendCell.h"

@interface KFBrandRecommendCell ()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation KFBrandRecommendCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialSetup];
    }
    return self;
}

//初始化设置
- (void)initialSetup
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:imageView];
    imageView.backgroundColor = [UIColor clearColor];
    _imageView = imageView;
//    imageView.layer.borderWidth = 1;
//    imageView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}


//重写这个方法，能让cell变得小一点，出现一个黑线
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= 1;
//    frame.size.width -= 1;
//    
//    [super setFrame:frame];
//}

@end
