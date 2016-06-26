//
//  KFThirdLoginButton.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFThirdLoginButton.h"

@implementation KFThirdLoginButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.Y = margin * 0.5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.Y = CGRectGetMaxY(self.imageView.frame) + margin * 0.5;
    
}

@end
