//
//  KFOrderAboutCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFOrderAboutCell.h"
#import "KFThirdLoginButton.h"
#import "KFCollectionCellButtonItem.h"

@interface KFOrderAboutCell()
@property (weak, nonatomic) IBOutlet KFThirdLoginButton *button;

@end

@implementation KFOrderAboutCell

- (void)awakeFromNib {
    // Initialization code
    
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)setItem:(KFCollectionCellButtonItem *)item
{
    _item = item;
    
    [_button setTitle:item.title forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
}

@end
