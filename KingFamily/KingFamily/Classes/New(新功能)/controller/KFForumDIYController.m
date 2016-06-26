//
//  KFForumDIYController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFForumDIYController.h"
#import "KFForumCell.h"
#import "KFTabBarController.h"
#import "KFHomeViewController.h"
#import "JXMovableCellTableView.h"

@interface KFForumDIYController ()<JXMovableCellTableViewDataSource,JXMovableCellTableViewDelegate>

@property (nonatomic,strong) NSArray *homeChilds;     //首页控制器的子控制器
@property (nonatomic,strong) NSArray *lastHomeChilds; //保存数组
@end

@implementation KFForumDIYController

static NSString * const  reuseID = @"forumCell";

#pragma mark 懒加载
- (NSArray *)homeChilds
{
    if (!_homeChilds) {
        _homeChilds = [NSMutableArray array];
        KFTabBarController *tabBarVC = (KFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
        UINavigationController *homeNavi = tabBarVC.childViewControllers[0];
        
        //取得根控制器
        UIViewController *homeVC = homeNavi.viewControllers[0];
        
        
        //保存
        _homeChilds = homeVC.childViewControllers;

    }
    
    return _homeChilds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"版块设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(success)];
    
    [self setupTableView];
    
    _lastHomeChilds = self.homeChilds;
    
}


//设置tableView相关
- (void)setupTableView
{
    JXMovableCellTableView *tableView = [[JXMovableCellTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    self.tableView = tableView;
    
    //注册cell
    [tableView registerNib:[UINib nibWithNibName:@"KFForumCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    tableView.gestureMinimumPressDuration = 0.5;
    tableView.drawMovalbeCellBlock = ^(UIView *movableCell){
        movableCell.layer.shadowColor = [UIColor grayColor].CGColor;
        movableCell.layer.masksToBounds = NO;
        movableCell.layer.cornerRadius = 0;
        movableCell.layer.shadowOffset = CGSizeMake(-2, -2);
        movableCell.layer.shadowOpacity = 0.8;
        movableCell.layer.shadowRadius = 5;
        movableCell.layer.opacity = 0.8;
        
        //加个动画
        CAKeyframeAnimation *shake = [CAKeyframeAnimation animation];
        shake.keyPath = @"transform.rotation.z";
        CGFloat shakeRadius = M_PI / 180 * 0.5;   //震动0.5度
        shake.values = @[@(shakeRadius),@0, @(-shakeRadius),@0];
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        shake.timingFunction = timingFunction;
        shake.repeatCount = MAXFLOAT;
        shake.duration = 0.15;
        
        [movableCell.layer addAnimation:shake forKey:@"shake"];
    };
    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    
    //设置footer
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width * 0.5, 44)];
    footer.centerX = self.tableView.centerX;
    footer.text = @"长按可拖动项目重新排序";
    footer.textColor = [UIColor darkGrayColor];
    tableView.tableFooterView = footer;

}

#pragma mark - JXMovableCellTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.homeChilds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KFForumCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    UIViewController *subVC = self.homeChilds[indexPath.row];
    cell.title = subVC.title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  获取tableView的数据源数组
 */
- (NSArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView
{
    return self.homeChilds.copy;
}

/**
 *  返回移动之后调换后的数据源
 */
- (void)tableView:(JXMovableCellTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray
{
    self.homeChilds = newDataSourceArray.mutableCopy;
    
    
}

/**
 *  将要开始移动indexPath位置的cell
 */
- (void)tableView:(JXMovableCellTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/**
 *  完成一次从fromIndexPath cell到toIndexPath cell的移动
 */
- (void)tableView:(JXMovableCellTableView *)tableView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}
/**
 *  结束移动cell在indexPath
 */
- (void)tableView:(JXMovableCellTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark 事件监听
- (void)cancel
{
    //取消重新排序
    self.homeChilds = _lastHomeChilds;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)success
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.homeChilds != _lastHomeChilds) {
        
        //发送通知，告知home控制器改变子控制器的顺序
        NSDictionary *userInfo = @{
                                   @"homeChilds" : self.homeChilds
                                   };
        [[NSNotificationCenter defaultCenter]postNotificationName:ForumChanged object:nil userInfo:userInfo];
        
    }
    
}
@end
