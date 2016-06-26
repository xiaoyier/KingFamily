//
//  KFPasswordButton.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPasswordButton.h"

@implementation KFPasswordButton


- (void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 0.5;
}

@end
