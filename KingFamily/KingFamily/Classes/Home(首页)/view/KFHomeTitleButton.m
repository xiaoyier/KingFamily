//
//  KFHomeTitleButton.m
//  KingFamily
//
//  Created by Sycamore on 16/4/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeTitleButton.h"

@implementation KFHomeTitleButton

- (void)layoutSubviews
{
    //记住，这句代码很重要，没有这句代码，就不显示了！！！谨记
    [super layoutSubviews];
    //将图片和文字的x值互换，但是该方法每次变动都会调用两次，所以需要进行判断
    if (self.titleLabel.X > self.imageView.X ) {
        self.titleLabel.X = self.imageView.X;

        self.imageView.X = CGRectGetMaxX(self.titleLabel.frame) + 3.0f;
        
        //这个系数刚刚好
        self.imageView.Y = self.titleLabel.height * 0.15;


    }
}


//重写setHilight
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
