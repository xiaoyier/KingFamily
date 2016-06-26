//
//  KFForumCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/25.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFForumCell.h"

@interface KFForumCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation KFForumCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}
@end
