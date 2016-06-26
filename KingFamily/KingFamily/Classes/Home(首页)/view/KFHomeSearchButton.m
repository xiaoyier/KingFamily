//
//  KFHomeSearchButton.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeSearchButton.h"

@implementation KFHomeSearchButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.layer.cornerRadius = 15;
        
    }
    
    return self;
}




- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.height = 30;
    self.width += 20;
}

@end
