//
//  KFButtonListView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFFunctionListView.h"
#import <UIImageView+WebCache.h>
#import "KFFunctionItem.h"

@implementation KFFunctionListView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return  nil;
    }
    
    //初始化设置
    [self initialSetup];
    
    
    return self;
}

//创建button
- (void)initialSetup
{
    //
    self.backgroundColor = [UIColor whiteColor];
}

//传数据进来
-(void)setFunctionImageList:(NSArray *)functionImageList
{
    _functionImageList = functionImageList;
    //如果已经创建过button了，就直接返回
    if (self.subviews.count > 2) {
        return;
    }
    
    NSInteger count = functionImageList.count;
    CGFloat buttonWidth = Screen_Width / count;
    
    //创建button
    for (NSInteger index = 0; index < count; index ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index * buttonWidth, 0, buttonWidth, self.height);
        NSString *imageURL = functionImageList[index];
//        button.contentMode = UIViewContentModeScaleToFill;

        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageURL] options:kNilOptions progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            UIImage *newImage;
            //判断当前屏幕是否是6p,是的话需要拉伸图片
            if (Screen_Width == 414) {
                newImage = [UIImage resizeImage:image Size:CGSizeMake(image.size.width * 100.0, image.size.width * 100.0)];
            }
            else newImage = image;
            
            //注意，该回调是在子线程里进行的，UI的刷新需要回到主线程里面进行
            dispatch_async(dispatch_get_main_queue(), ^{
//                [button setImage:newImage forState:UIControlStateNormal];
                [button setBackgroundImage:newImage forState:UIControlStateNormal];
                
                
            });
        }];
        
        //监听button的点击
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }
}


#pragma mark------------注意button的点击还没有写
- (void)clickButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(functionListView:didClickButton:)]) {
        [self.delegate functionListView:self didClickButton:button];
    }
}

@end
