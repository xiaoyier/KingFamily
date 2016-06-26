//
//  KFHomeViewController.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeViewController.h"
#import "HomeNaviTitleView.h"
#import "KFNavigationController.h"
#import "home.h"
#import <Masonry.h>
#import "KFSearchNavigationController.h"
#import "KFHomeSearchViewController.h"
#import "KFSelectLocationViewController.h"
#import "KFHomePageBaseViewCoontroller.h"
#import "KFMyControllers.h"
#import "KFTabBarController.h"



#define TitleMenu_Height                       45
#define MenuIndicator_Height                   2.5f
#define SelButton_Scale                        1.20f
#define TitleButton_Margin                     20
@interface KFHomeViewController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *titleMenu;                   //菜单条
@property (nonatomic,weak) UIScrollView *contentView;                 //内容视图
@property (nonatomic,strong) NSMutableArray *buttonArray;             //菜单按钮数组
@property (nonatomic,strong) NSMutableArray *buttonWidths;            //菜单按钮的宽度数组
@property (nonatomic,strong) UIButton *selectedButton;                //选中的按钮
@property (nonatomic,strong) NSMutableArray *indicatorWidths;         //滑动指示条宽度数组
@property (nonatomic,weak) UIView *indicatorView;                     //滑动指示条
@end

@implementation KFHomeViewController

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)buttonWidths
{
    if (!_buttonWidths) {
        _buttonWidths = [NSMutableArray array];
    }
    return _buttonWidths;
}

- (NSMutableArray *)indicatorWidths
{
    if (!_indicatorWidths) {
        _indicatorWidths = [NSMutableArray array];
    }
    return _indicatorWidths;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    

    //设置导航条相关
    [self setUpNavigationBarAbout];
    
    //添加菜单栏
    [self addTitleMenu];
    
    //添加滚动视图
    [self setupContentView];
    
    //添加子控制器
    [self addAllChildControllers];
    
    //填充菜单栏里面的内容
    [self addAllButtonsInTitleMenu];
    
    self.automaticallyAdjustsScrollViewInsets = YES;

    
    
    //监听版块发生变化的通知
    [[NSNotificationCenter defaultCenter]addObserverForName:ForumChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSArray *childVCs = note.userInfo[@"homeChilds"];        
       
        [KFMyControllers setMyContrs:childVCs];

        //刷新页面
        [UIApplication sharedApplication].keyWindow.rootViewController = [[KFTabBarController alloc]init];
    }];
    
}


//监听按钮的点击
- (void)clickButton:(UIButton *)button
{
    //1 选中当前按钮,更改按钮的状态
    [self selectButton:button];
    
    //2 添加子控制器的view到scrollView上面来
    NSInteger index = button.tag;
    [self addViewFromChildViewControllerWithIndex:index];
    
    
    //3 添加完成后，让scrollView偏移
    [_contentView setContentOffset:CGPointMake(index * Screen_Width, 0)];
    
}

//选中当前按钮
- (void)selectButton:(UIButton *)button
{
    //之前选中的按钮恢复状态
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectedButton.transform = CGAffineTransformIdentity;
    
    //当前选中状态颜色变化
    [button setTitleColor:Bar_TintColor forState:UIControlStateNormal];
    
    //产生形变，变大
    button.transform = CGAffineTransformMakeScale(SelButton_Scale, SelButton_Scale);
    
    //让选中的按钮居中
    [self setSelectedButtonInCenter:button];
    
    //记录新的选中按钮
    _selectedButton = button;
    
    
}

//让选中的按钮居中
- (void)setSelectedButtonInCenter:(UIButton *)button
{
    //计算需要让菜单偏移的距离
    CGFloat titleMenuNeedOffset = button.centerX - Screen_Width * 0.5;
    
    //不需要居中显示的按钮，就不偏移
    if (titleMenuNeedOffset < 0) {
        titleMenuNeedOffset = 0;
    }
    
    //计算最大的偏移量
    CGFloat MaxOffset = _titleMenu.contentSize.width - Screen_Width;
    
    //大于最大偏移量，不必居中显示
    if (titleMenuNeedOffset > MaxOffset) {
        titleMenuNeedOffset = MaxOffset;
    }
    
    //让titleMenu产生偏移
    [_titleMenu setContentOffset:CGPointMake(titleMenuNeedOffset, 0) animated:YES];
    
    //让指示条滑动
    if (_indicatorView) {
        [UIView animateWithDuration:0.15 animations:^{
            
            NSInteger index = button.tag;
            //获取指示条的宽度
            CGFloat indicatorWidth = [_indicatorWidths[index] floatValue] * SelButton_Scale;
            CGFloat indicatorY = TitleMenu_Height - MenuIndicator_Height;
            CGFloat indicatorheight = MenuIndicator_Height;
            CGFloat indicatorCenterX = button.centerX;
            
            //文字不缩放的时候，指示条的X比较好确定，采用这个效果比较好
            //获取指示条的centerX
            //        if (index > 0) {
            //            //获得之前按钮的总宽度
            //            CGFloat totleButtonWidth = 0.0;
            //            for (NSInteger i = 0; i < index; i ++) {
            //                totleButtonWidth += [_buttonWidths[i] floatValue];
            //            }
            //            indicatorX = totleButtonWidth  + TitleButton_Margin;
            //        }
            //        else{
            //            indicatorX = TitleButton_Margin;
            //        }
            
            //        _indicatorView.frame = CGRectMake(indicatorX,_indicatorView.Y,indicatorWidth,_indicatorView.height);
            
            
            //文字缩放的时候，指示条也跟着缩放，这样算效果比较好
            _indicatorView.centerX = indicatorCenterX;
            _indicatorView.Y = indicatorY;
            _indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, indicatorheight);
            
        } completion:^(BOOL finished) {
           
        }];
    }
    
}

//添加子控制器的view
- (void)addViewFromChildViewControllerWithIndex:(NSInteger)index
{
    //获取对应的控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    //判断是否还要继续添加到scrollView上面去，如果添加过了，就不要再添加了
    if (childVc.view.superview) {
        return ;
    }
    
    //如果没有添加过的话，再添加
    childVc.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, _contentView.height);
    [_contentView addSubview:childVc.view];
    
}

//添加菜单栏里的子空间
- (void)addAllButtonsInTitleMenu
{
    NSInteger count = self.childViewControllers.count;
    for (NSInteger index = 0; index < count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        NSString *title = self.childViewControllers[index].title;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:self.childViewControllers[index].title forState:UIControlStateNormal];
        //设置button的字体
        button.titleLabel.font = kFont16;
        //根据文字计算按钮的宽度
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
        //计算文字所占的尺寸
        CGSize size = [title sizeWithAttributes:dic];
        //计算按钮的宽度
        CGFloat buttonWidth = size.width + TitleButton_Margin * 2;
    
        //计算文字的位置和尺寸
        CGFloat buttonX = [self getXFromButtonWidths:self.buttonWidths];
        button.frame = CGRectMake(buttonX, 3.0f, buttonWidth, _titleMenu.height - MenuIndicator_Height);
        
        //将每个按钮的宽度用数组保存起来
        [self.buttonWidths addObject:[NSNumber numberWithFloat:buttonWidth]];
        
        //将文字的宽度保存起来，作为指示条的宽度
        [self.indicatorWidths addObject:[NSNumber numberWithInt:size.width]];
        
        //给按钮添加监听
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleMenu addSubview:button];
        [self.buttonArray addObject:button];
        
        
        //默认选中第一个按钮
        if (index == 0) {
            
            [self clickButton:button];
        }
        
    }
    // 添加滑动指示条
    [self addIndicatorViewInTitleMenu];

    
    //设置滚动范围
    _titleMenu.contentSize = CGSizeMake([self getXFromButtonWidths:self.buttonWidths], 0);
    _contentView.contentSize = CGSizeMake(count * Screen_Width, 0);
}

//给titleView添加滑动条
- (void)addIndicatorViewInTitleMenu
{
    UIView *indicatorView = [[UIView alloc]init];
    
//    CGFloat indicatorX = TitleButton_Margin;
    
    indicatorView.backgroundColor = Bar_TintColor;
    
//    indicatorView.frame = CGRectMake(indicatorX, TitleMenu_Height - MenuIndicator_Height, [_indicatorWidths[0] floatValue], MenuIndicator_Height);
    UIButton * button = _buttonArray[0];
    indicatorView.centerX = button.centerX;
    indicatorView.Y = TitleMenu_Height - MenuIndicator_Height;
    indicatorView.bounds = CGRectMake(0 , 0 ,  [_indicatorWidths[0] floatValue] * SelButton_Scale ,MenuIndicator_Height);
    
    [_titleMenu addSubview:indicatorView];
    
    _indicatorView = indicatorView;
}

//计算每个按钮的x坐标
- (CGFloat)getXFromButtonWidths:(NSArray *)array
{
    NSInteger count = array.count;
    CGFloat X = 0;
    
    //如果数组里面有值
    if (count >= 1) {
        for (NSInteger index = 0; index < count; index ++) {
            X += [array[index] floatValue];
        }
    }
    return X;
}

//添加所有的子控制器
- (void)addAllChildControllers
{
    
    NSArray *childs = [KFMyControllers myContrs];
    NSLog(@"%@",childs);
    for (UIViewController *vc in childs) {
        [self addChildViewController:vc];
    }
//    //首页
//    KFHomePageViewController *homePage = [[KFHomePageViewController alloc]init];
//    homePage.title = @"首页";
//    [self addChildViewController:homePage];
//    
//    //休闲零食
//    KFLeisureFoodViewController *leisureFood = [[KFLeisureFoodViewController alloc]init];
//    leisureFood.title = @"休闲零食";
//    [self addChildViewController:leisureFood];
//    
//    //格格厨房
//    KFKichenViewController *kichen = [[KFKichenViewController alloc]init];
//    kichen.title = @"格格厨房";
//    [self addChildViewController:kichen];
//    
//    //保健滋补
//    KFHealthFoodViewController *health = [[KFHealthFoodViewController alloc]init];
//    health.title = @"保健滋补";
//    [self addChildViewController:health];
//    
//    //母婴辅食
//    KFBabyFoodViewController *baby = [[KFBabyFoodViewController alloc]init];
//    baby.title = @"母婴辅食";
//    [self addChildViewController:baby];
//    
//    //水果生鲜
//    KFFruitViewController *fruit = [[KFFruitViewController alloc]init];
//    fruit.title = @"水果生鲜";
//    [self addChildViewController:fruit];
//    
//    //最后疯抢
//    KFLastPurchaseViewController *last = [[KFLastPurchaseViewController alloc]init];
//    last.title = @"最后疯抢";
//    [self addChildViewController:last];
//    
//    //即将开抢
//    KFWillPurchaseViewController *will = [[KFWillPurchaseViewController alloc]init];
//    will.title = @"即将开抢";
//    [self addChildViewController:will];
}

//设置滚动视图
- (void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    CGFloat y = CGRectGetMaxY(_titleMenu.frame);
    //注意，设置导航条不透明后，原点默认从（0，64）算起的
    contentView.frame = CGRectMake(0, y, Screen_Width , Screen_Height - y - 64);
    [self.view addSubview:contentView];
//    contentView.backgroundColor = KFColor(220, 220, 220);
    contentView.delegate = self;
    _contentView = contentView;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.bounces = NO;
    contentView.pagingEnabled = YES;
    _contentView.scrollsToTop = NO;
}

//设置菜单栏
- (void)addTitleMenu
{
    UIScrollView *titleMenu = [[UIScrollView alloc]init];
    titleMenu.showsHorizontalScrollIndicator = NO;
    titleMenu.frame = CGRectMake(0, 0, Screen_Width, TitleMenu_Height);
    [self.view addSubview:titleMenu];
    titleMenu.backgroundColor =  KFColor(250, 250, 250);
    _titleMenu = titleMenu;
    _titleMenu.scrollsToTop = NO;
}

//设置导航条内容相关
- (void)setUpNavigationBarAbout
{
    //添加右侧搜素按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithRenderImageNamed:@"navItemSearch"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToSearchController)];

    //添加中间的titleView
    HomeNaviTitleView *titleView = [HomeNaviTitleView homeNaviTitleView];
  
#pragma mark -------------跳转到定位城市控制器，到时候需要跳到自定义的控制器
    __weak typeof(titleView) weakTitleView = titleView;
    titleView.operation = ^{
        
        KFSelectLocationViewController *vc = [[KFSelectLocationViewController alloc]init];
        vc.selectCityBlock = ^(NSString *title){
            weakTitleView.cityTitle = title;
            
        };
        vc.currentCity = weakTitleView.cityTitle;
        KFNavigationController *newNavi = [[KFNavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:newNavi animated:YES completion:nil];
        
    };
    
    self.navigationItem.titleView = titleView;
}


#pragma mark --------------点击搜索按钮，调转到搜索控制器界面
- (void)pushToSearchController
{
    KFHomeSearchViewController *searchVC = [[KFHomeSearchViewController alloc]init];
    KFSearchNavigationController *searchNV = [[KFSearchNavigationController alloc]initWithRootViewController:searchVC];
    
    [self presentViewController:searchNV animated:NO completion:nil];
}

#pragma mark ---------------UIScrollViewDelegate

//滚动完成后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滚动完成后，获取当前页码
    NSInteger index = _contentView.contentOffset.x / Screen_Width;
    //将当前子控制器的view添加上来
    [self addViewFromChildViewControllerWithIndex:index];
    
    //选中对应的菜单栏
    [self selectButton:self.buttonArray[index]];
}

//滚动过程中，让文字产生渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取相关左右两个button的索引
    NSInteger indexLeft = _contentView.contentOffset.x / Screen_Width;
    NSInteger indexRight = indexLeft + 1;
    
    //获取左右两个button
    UIButton *leftButton = self.buttonArray[indexLeft];
    UIButton *rightButton;
    if (indexRight < self.buttonArray.count) {
        rightButton = self.buttonArray[indexRight];
    }
    
    //获取形变范围,在0-1范围内
    CGFloat scaleR = _contentView.contentOffset.x / Screen_Width - indexLeft;
    CGFloat scaleL = 1 - scaleR;
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * 0.2 + 1, scaleL * 0.2 + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * 0.2 + 1, scaleR * 0.2 + 1);
    
    //字体颜色改变
    UIColor *leftColor = KFColor(207 * scaleL, 52 * scaleL, 41 * scaleL);
    UIColor *rightColor = KFColor(207 * scaleR, 52 * scaleR, 41 * scaleR);
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}



@end
