//
//  KFCartSectionHeader.m
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCartSectionHeader.h"

@interface KFCartSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *describel;


@end

@implementation KFCartSectionHeader


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (instancetype)sectionHeader
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFCartSectionHeader" owner:nil options:nil]lastObject];
}


- (IBAction)gotoPick:(UIButton *)sender {
    if (_gotoPick != nil) {
        _gotoPick();
    }
}

@end
