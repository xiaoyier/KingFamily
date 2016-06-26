//
//  KFTodayHotCell.m
//  KingFamily
//
//  Created by Sycamore on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFTodayHotCell.h"
#import "KFHotItem.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
@interface KFTodayHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *describelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation KFTodayHotCell

- (void)awakeFromNib {
        [self initialSetup];
}

- (void)initialSetup
{
    //初始化设置
//    _imageView.layer.borderWidth = 1.0f;
//    _imageView.layer.borderColor = KFColor(220, 220, 220).CGColor;
    
    _describelLabel.textAlignment = NSTextAlignmentLeft;
    _describelLabel.numberOfLines = 0;
    _describelLabel.textColor = KFColor(50, 50, 50);
    _describelLabel.font = kFont12;
    
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = kFont16;
    _priceLabel.contentMode = UIViewContentModeTop;
}

//传模型进来

- (void)setItem:(KFHotItem *)item
{
    _item = item;
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:item.image] options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        _imageView.image = image;
        if (image.size.width < self.width) {
            _imageView.layer.borderWidth = 0.5f;
            _imageView.layer.borderColor = KFColor(200, 200, 200).CGColor;
        }
    }];
//    [_imageView sd_setImageWithURL placeholderImage:[UIImage imageNamed:@"home_default_goods"]];
    
    _describelLabel.text = item.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",item.price];
    
    
}

@end
