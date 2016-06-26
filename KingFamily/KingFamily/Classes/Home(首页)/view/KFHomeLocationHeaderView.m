//
//  KFHomeLocationHeaderView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeLocationHeaderView.h"

@implementation KFHomeLocationHeaderView

+ (instancetype)headerView{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
