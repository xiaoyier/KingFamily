//
//  KFCurrentCityCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCurrentCityCell.h"

@interface KFCurrentCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KFCurrentCityCell

- (void)awakeFromNib {
    // Initialization code
    
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}


@end
