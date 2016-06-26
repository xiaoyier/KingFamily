//
//  KFSearchSectionHeaderView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSearchSectionHeaderView.h"

@interface KFSearchSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;


@end

@implementation KFSearchSectionHeaderView

- (void)awakeFromNib {
    // Initialization code
    
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _headerTitle.text = title;
}

@end
