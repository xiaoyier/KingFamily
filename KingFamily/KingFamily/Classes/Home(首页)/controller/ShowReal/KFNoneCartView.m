//
//  KFNoneCartView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/17.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFNoneCartView.h"
#import "UIImage+GIF.h"

@interface KFNoneCartView ()
@property (weak, nonatomic) IBOutlet UIImageView *guangImageView;

@property (weak, nonatomic) IBOutlet UIButton *guangBtn;

@end

@implementation KFNoneCartView

+ (instancetype)noneCartView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFNoneCartView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    // 设置gif图片
    self.guangImageView.image = [UIImage sd_animatedGIFNamed:@"empty_shoppingCart"];
    
    // 设置按钮
    self.guangBtn.layer.borderWidth = 0.9f; // 边框宽度
    self.guangBtn.layer.borderColor = Bar_TintColor.CGColor; // 边框颜色
    self.guangBtn.layer.cornerRadius = 6.0f; // 边框圆角矩形半径
    self.guangBtn.tintColor = Bar_TintColor; //字体颜色
}


- (IBAction)guangBtnClick:(UIButton *)sender {
    
    if (_guangBtnClick != nil) {
        _guangBtnClick();
    }
    
}


@end
