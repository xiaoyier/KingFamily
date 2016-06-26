//
//  KFTagButton.m
//
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFTagButton.h"

@implementation KFTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = KFTagButtonColor;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.layer.cornerRadius = 5.0f;
    [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    self.width += KFSmallSmallMargin * 3;
    self.height = KFTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.X = KFSmallSmallMargin;
    self.imageView.X = CGRectGetMaxX(self.titleLabel.frame) + KFSmallSmallMargin;
}


//使用这个方法的时候需要注意，这个方法会调用多次
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width += BSSmallSmallMargin * 3;
//    [super setFrame:frame];
//    
//    NSLog(@"%@",NSStringFromCGRect(frame));
//    
//}
@end
