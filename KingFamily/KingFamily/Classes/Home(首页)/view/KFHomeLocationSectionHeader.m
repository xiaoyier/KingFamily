//
//  KFHomeLocationSectionHeader.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeLocationSectionHeader.h"

@interface KFHomeLocationSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KFHomeLocationSectionHeader

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}


@end
