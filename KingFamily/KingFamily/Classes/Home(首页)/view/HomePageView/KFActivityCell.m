//
//  KFActivityCell.m
//  KingFamily
//
//  Created by Sycamore on 16/4/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFActivityCell.h"
#import <Masonry.h>
#import <SDWebImageManager.h>
#import "KFContentItem.h"
#import <UIImageView+WebCache.h>

@interface KFActivityCell ()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation KFActivityCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectZero;
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
    }
    
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    
    if (self) {
        //初始化设置
        [self initialSetup];
        
    }
    return self;
}

- (void)initialSetup
{
    
//    NSLog(@"%@", NSStringFromCGRect(imageView.frame));
    
}

- (void)setContentItem:(KFContentItem *)contentItem
{
    _contentItem = contentItem;
    
    self.imageView.frame = self.bounds;
    //下载图片
    [_imageView sd_setImageWithURL:[NSURL URLWithString:contentItem.image] placeholderImage:[UIImage imageNamed:@"home_default_goods"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

@end
