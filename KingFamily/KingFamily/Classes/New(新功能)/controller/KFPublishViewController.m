//
//  KFPublishViewController.m
//  
//
//  Created by Sycamore on 16/4/27.
//  Copyright © 2016年 Sycamore. All rights reserved.
//



#import "KFPublishViewController.h"
#import "KFPublishButton.h"
#import <pop/POP.h>
#import "KFPostWordViewController.h"
#import "KFNavigationController.h"
#import "KFPhotoHomeViewController.h"
#import "KFForumDIYController.h"
#import "SVProgressHUD.h"

@interface KFPublishViewController ()

@property (nonatomic,strong) NSArray *buttonTitles;  //按钮标题
@property (nonatomic,strong) NSArray *buttonImages;  //按钮图片
@property (nonatomic,strong) NSArray *springBeginTimes;  //动画开始时间
@property (nonatomic,strong) NSMutableArray *buttons;   //存放button
@property (nonatomic,weak) UIImageView *sloganView;

@end

@implementation KFPublishViewController

static NSInteger const BSSpringFactor = 10;

//关于modal:A -B ,那么A控制器的view必须存在窗口上，modal完成后，A的view会从窗口上移除，讲B的View添加到窗口上，此时如果想让B dismiss掉，就不能再通过B modal出C了，因为B dismiss后，B的view会从窗口上移除，A的view添加到窗口上，此时要拿到A,通过A modal出C

#pragma mark 懒加载
- (NSArray *)springBeginTimes
{
    if (!_springBeginTimes) {
        CGFloat timtIntervel = 0.1;
        
        _springBeginTimes = @[@(2 * timtIntervel),
                              @(1 * timtIntervel),
                              @(3 * timtIntervel),
                              @(4 * timtIntervel),
                              @(0 * timtIntervel),
                              @(5 * timtIntervel),
                              @(6 * timtIntervel)];
    }
    return _springBeginTimes;
}

- (NSArray *)buttonTitles
{
    if (!_buttonTitles) {
        _buttonTitles = @[@"看视频",@"美图看看",@"选你喜欢",@"听音乐",@"版块DIY",@"离线"];
    }
    
    return _buttonTitles;
}


- (NSArray *)buttonImages
{
    if (!_buttonImages) {
        _buttonImages = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    }
    return _buttonImages;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //防止动画期间点了某个按钮
    self.view.userInteractionEnabled = NO;
    [self setupButtons];
    
    [self setupSlogan];
    
}


//创建button
- (void)setupButtons{
    
    //设置按钮宽高
    NSInteger buttonCount = self.buttonTitles.count;
    NSInteger column = 3;
    NSInteger rows = (buttonCount + column - 1)/column;
    CGFloat buttonW = Screen_Width / column;
    CGFloat buttonH = buttonW * 0.85;
    
    for (int i = 0; i < buttonCount; i++) {
        
        KFPublishButton *button = [KFPublishButton buttonWithType:UIButtonTypeCustom];
        button.width = -Screen_Width;
        CGFloat buttonX = (i % column) * buttonW;
        CGFloat buttonY = (Screen_Height - buttonH * rows) * 0.5 + (i / column) * buttonH;
        
        UIImage *image = [UIImage imageNamed:self.buttonImages[i]];
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.buttons addObject:button];
        
        //设置动画，采用pop(一款强大的动画引擎)
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        spring.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - Screen_Height, buttonW, buttonH)];
        spring.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        spring.springBounciness = BSSpringFactor;
        spring.springSpeed = BSSpringFactor;
        spring.beginTime = CACurrentMediaTime() + [self.springBeginTimes[i] doubleValue];
        
        [button pop_addAnimation:spring forKey:@"button"];
        
    }
    
}

//创建slogan
- (void)setupSlogan
{
    UIImage *sloganImage = [UIImage imageNamed:@"app_slogan"];
    UIImageView *sloganView = [[UIImageView alloc]initWithImage:sloganImage];
    sloganView.X  = -Screen_Height;         //注意，当一个控件最开始显示位置有问题的时候，可以给一个屏幕外的位置
    CGFloat centerX = Screen_Width * 0.5;
    CGFloat centerY = Screen_Height * 0.2;
    [self.view addSubview:sloganView];
    _sloganView = sloganView;
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    spring.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY - Screen_Height)];
    spring.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
    spring.springBounciness = BSSpringFactor;
    spring.springSpeed = BSSpringFactor;
    spring.beginTime = CACurrentMediaTime() + [self.springBeginTimes[self.springBeginTimes.count - 1]doubleValue];
    [sloganView pop_addAnimation:spring forKey:@"slogan"];
    
    //注意整个动画完成之后需要恢复事件的接收
    [spring setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark 事件监听
//按钮的点击
- (void)buttonClick:(UIButton *)button
{
  [self cancle:^{
      NSInteger index = [self.buttons indexOfObject:button];
      
      switch (index) {
          case 2:{
              KFPostWordViewController *post = [[KFPostWordViewController alloc]init];
              KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:post];
              
              [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
              break;
                    }
          case 1:{
              KFPhotoHomeViewController *photo = [[KFPhotoHomeViewController alloc]init];
              KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:photo];
              
              [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
              break;
                    }
          case 4:{
              KFForumDIYController *diy = [[KFForumDIYController alloc]init];
              KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:diy];
              
              [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
              break;
                    }
          case 0:
          case 3:
          case 5:{
              [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
              [SVProgressHUD showErrorWithStatus:@"Sorry!该部分功能还未实现..."];
              break;
          }
          default:
              break;
      }
  }];
}
- (IBAction)cancelButtonClick {
    [self cancle:nil];
}

//退出动画
- (void)cancle:(void(^)())callBack {
    
    //动画期间不允许交互
    self.view.userInteractionEnabled = NO;
    //弹回button的动画
    for (int i = 0; i < self.buttons.count; i++) {
        
        KFPublishButton *button = self.buttons[i];
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(button.centerX, button.centerY + Screen_Height)];
        animation.beginTime = CACurrentMediaTime() + [self.springBeginTimes[i] doubleValue];
        [button pop_addAnimation:animation forKey:nil];
    }
    
    //弹回slogan的动画
    POPBasicAnimation *animation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation2.toValue = [NSValue valueWithCGPoint:CGPointMake(_sloganView.centerX, _sloganView.centerY + Screen_Height)];
    animation2.beginTime = CACurrentMediaTime() + [self.springBeginTimes[self.springBeginTimes.count - 1] doubleValue];
    [animation2 setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        
        //有回调的话就回调
        if (callBack != nil) {
            callBack();
        }
    
        
    }];
    
    [_sloganView pop_addAnimation:animation2 forKey:nil];
    
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancle:nil];
}



@end
