//
//  KFHotCityCell.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHotCityCell.h"
#import "KFHomeSearchButton.h"

#define buttonMargin 10
@interface KFHotCityCell ()

@property (nonatomic,strong) NSMutableArray *buttons;

@end

@implementation KFHotCityCell

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
}


- (void)setHotCities:(NSArray *)hotCities
{
    _hotCities = hotCities;
    
    //创建button
    NSInteger count = hotCities.count;
    
    for (NSInteger i = 0 ; i < count; i ++) {
        
        KFHomeSearchButton *button = [KFHomeSearchButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:hotCities[i] forState:UIControlStateNormal];
        button.width += buttonMargin * 2;
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.buttons.count;
    for (NSInteger i = 0; i < count; i ++) {
        
        UIButton *currentButton = self.buttons[i];
        
        if (i == 0) {
            currentButton.X = buttonMargin;
            currentButton.Y = buttonMargin;
        }
        else{
            UIButton *previousButton = self.buttons[i - 1];
            CGFloat leftWidth = self.width - CGRectGetMaxX(previousButton.frame) - buttonMargin;
            
            if (currentButton.width > leftWidth) {
                currentButton.X = buttonMargin;
                currentButton.Y = CGRectGetMaxY(previousButton.frame) + buttonMargin;
            }else{
                currentButton.X = CGRectGetMaxX(previousButton.frame) + buttonMargin;
                currentButton.Y = previousButton.Y;
            }
            
        }
    }
    
    UIButton *lastButton = self.buttons.lastObject;
    self.height = CGRectGetMaxY(lastButton.frame) + buttonMargin ;
    
}

@end
