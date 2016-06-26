//
//  KFFirstSectionHeader.m
//  KingFamily
//
//  Created by Sycamore on 16/6/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFFirstSectionHeader.h"

@implementation KFFirstSectionHeader


+ (instancetype)header
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFFirstSectionHeader" owner:nil options:nil]firstObject];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchHandeler != nil) {
        _touchHandeler();
    }
}


@end
