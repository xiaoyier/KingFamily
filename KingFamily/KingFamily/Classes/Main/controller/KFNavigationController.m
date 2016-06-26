//
//  KFNavigationController.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFNavigationController.h"

@interface KFNavigationController ()

@end

@implementation KFNavigationController

//第一次使用这个类的时候会调用此方法，在此方法里面进行一些全局的设置
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[KFNavigationController class]]];
    
    //设置导航条模糊效果为NO
    bar.translucent = NO;
    
    //导航条的translucent属性为Yes,即默认为透明的，此时内部view的原点从（0，0）开始，当设置导航条为不透明的时候，原点默认从（0，64）开始，此时添加子空间就不要加这64了，
    //如果想设置透明情况下原点从（0，64）开始，需要设置这个属性：self.edgesForExtendedLayout = UIRectEdgeNone;
    //如果想要不透明情况下原点坐标从（0，0）开始，需要设置：self.extendedLayoutIncludesOpaqueBars = YES

    
    
    //设置导航条的背景色
    bar.barTintColor = Bar_TintColor;
    
    //设置title的文字属性
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = Navi_TitleColor;
    titleAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:titleAttr];
    
    //设置导航条上文字和图片的主题颜色
    bar.tintColor = Navi_TitleColor;
    
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    
#pragma mark ------------------已解决
    //设置阴影线，干掉shadowimage必须先设置backgroundimage，不然设置无效
    [bar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = [[UIImage alloc]init];
    
    //由application管理，在xcode7.0后会报错,7.2不会报错
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
