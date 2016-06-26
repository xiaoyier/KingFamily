//
//  KFPublishButton.m
//
//  Created by Sycamore on 16/5/24.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFPublishButton.h"

@implementation KFPublishButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.Y = KFSmallMargin;
    //注意,center是相对父控件来计算的！
    self.imageView.centerX = [self convertPoint:self.center fromView:self.superview].x;
    
    
    //自动计算宽和高
    [self.titleLabel sizeToFit];
    
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.Y = CGRectGetMaxY(self.imageView.frame) + KFSmallSmallMargin ;
    
    
}
@end
