//
//  KFSecondSecitonCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSecondSecitonCell.h"
#import "KFThirdLoginButton.h"
#import "KFCollectionCellButtonItem.h"

@interface KFSecondSecitonCell ()

@property (weak, nonatomic) IBOutlet KFThirdLoginButton *button;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation KFSecondSecitonCell


//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width -= 1;
//    [super setFrame:frame];
//}

- (void)awakeFromNib {
    // Initialization code
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setItem:(KFCollectionCellButtonItem *)item
{
    _item = item;
    [_button setTitle:item.title forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
    
    _detailLabel.text = item.detailTitle;
}


@end
