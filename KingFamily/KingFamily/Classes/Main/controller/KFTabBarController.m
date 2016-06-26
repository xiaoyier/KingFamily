//
//  KFTabBarController.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFTabBarController.h"
#import "KFNavigationController.h"
#import "KFHomeViewController.h"
#import "KFMallVC.h"
#import "KFCartViewController.h"
#import "KFUserController.h"
#import "FMDBHelper.h"
#import "KFTabBar.h"
#import "KFPublishViewController.h"


@interface KFTabBarController ()

@end

@implementation KFTabBarController

- (void)viewDidLoad {

    //hahha
    [super viewDidLoad];
    
    //添加所有的子控制器
    [self addAllChildViewControllers];
    
    //创建自定义tabBar
    KFTabBar *diyTabBar = [[KFTabBar alloc]init];
    diyTabBar.operation =  ^{
        
        //发布
        KFPublishViewController *publish = [[KFPublishViewController alloc]init];
        //        publish.view.backgroundColor = [UIColor whiteColor];
        
        //不让其有动画，注意，设置不动画的时候，会对transitionDelegate的动画方法产生影响，导致不生效
        [self presentViewController:publish animated:NO completion:nil];
    };
    //只读属性可以使用KVC进行赋值,用自定义的tabBar覆盖掉系统tabBar的时候，不用设置frame
    
    //注意：更换系统的tabBar,tabBar上的barButton还是会加上来的，一般是在viewWillAppear的时候加上来，这是系统做的事情
    [self setValue:diyTabBar forKey:@"tabBar"];
    
#pragma mark ------------------------已解决
    
    //设置tabBar不透明
    self.tabBar.translucent = NO;
    //设置tabBar主题颜色(选中的文字颜色)
    self.tabBar.tintColor = Bar_TintColor;
    
    //去掉阴影线，记住，干掉导航条和tabBar的shadowImage,必须先设置backgroundImage,不然设置无效
    self.tabBar.backgroundImage = [[UIImage alloc]init];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
    //tabBar上加一条线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -0.5, Screen_Width, 0.5)];
    line.backgroundColor = Bar_TintColor;
    [self.tabBar addSubview:line];
    
}


//添加所有的子控制器
- (void)addAllChildViewControllers
{
    //创建并添加首页控制器
    KFHomeViewController *home = [[KFHomeViewController alloc]init];
    [self addOneChildViewControllerWithController:home
                                            title:@"首页"
                                        imageName:@"home_normal"
                                selectedImageName:@"home_selected"];
    
    //创建并添加商城控制器
    KFMallVC *mall = [[KFMallVC alloc]init];
    [self addOneChildViewControllerWithController:mall
                                            title:@"商城"
                                        imageName:@"mall_normal"
                                selectedImageName:@"mall_selected"];
    
    //创建并添加购物车控制器
    KFCartViewController *cart = [[KFCartViewController alloc]init];
    [self addOneChildViewControllerWithController:cart
                                            title:@"购物车"
                                        imageName:@"cart_normal"
                                selectedImageName:@"cart_selected"];
    
    NSArray *lists = [FMDBHelper query:FMDBNoneCartTable];
    cart.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",lists.count];
    
    //创建并添加我的控制器
    KFUserController *user = [[KFUserController alloc]init];
    [self addOneChildViewControllerWithController:user
                                            title:@"我的"
                                        imageName:@"user_normal"
                                selectedImageName:@"user_selected"];
    
    
}

//添加单个子控制器
- (void)addOneChildViewControllerWithController:(UIViewController *)viewController
                                          title:(NSString *)title
                                      imageName:(NSString *)imageName
                              selectedImageName:(NSString *)selectedImageName
{
    UIImage *nomalImage = [UIImage imageWithRenderImageNamed:imageName];
    UIImage *selectedImage = [UIImage imageWithRenderImageNamed:selectedImageName];
    
    //设置tabBar的内容
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    viewController.tabBarItem.image = nomalImage;
    viewController.tabBarItem.selectedImage = selectedImage;
    
    //添加子控制器
    KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:navi];
}
@end
