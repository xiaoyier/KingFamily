//
//  KFCartViewController.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCartViewController.h"
#import "KFNavigationController.h"
#import "KFNoneCartView.h"
#import "FMDBHelper.h"
#import "KFCartCell.h"
#import "KFCartTradeItem.h"
#import <MJExtension/MJExtension.h>
#import "KFCartBottomView.h"
#import "KFCartCountDownHeader.h"
#import "KFCartSectionHeader.h"
#import "KFLoginViewController.h"
#import "ZQLoginTool.h"
#import "KFPurchaseViewController.h"


@interface KFCartViewController () <UITableViewDataSource,UITableViewDelegate,KFCartBottomViewDelegate>

@property (nonatomic,strong) NSMutableArray*cartList;
@property (nonatomic,weak) UIButton *editButton;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) KFNoneCartView *noneCartView;
@property (nonatomic,weak) KFCartBottomView *bottomView;
@property (nonatomic,weak) NSTimer *timeDownTimer;
@property (nonatomic,assign) NSInteger maxLeftTime;
@property (nonatomic,assign) CGFloat totleCount ;            //记录总价

@property (nonatomic,assign) BOOL isSetted;    //记录最大超时时间是否已经被设置

@end

static NSString * const cartCellID = @"cartCell";

@implementation KFCartViewController

- (NSMutableArray *)cartList
{
    if (!_cartList) {
        _cartList = [NSMutableArray array];
    }
    return _cartList;
}

- (NSTimer *)timeDownTimer
{
    if (!_timeDownTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(minusTheTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _timeDownTimer = timer;
    }
    return _timeDownTimer;
}


#pragma mark 初始化设置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setupNavi];
    
    //设置tableView
    [self setupTableView];
    
    //设置底部View
    [self setupCartBottomView];
    
    [self setupNoneCartView];
    
    
    //监听加减号按钮传过来的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cellAddButtonDidClick:) name:CartCellAdd object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cellMinusButtonDidClick:) name:CartCellMinus object:nil];
    
    //监听cell 选中按钮的点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cellPickButtonDidClick:) name:CartCellPickButtonClick object:nil];
    
    
}

//每次页面即将展示的以后，刷新页面展示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadCartData];
    
    
    //校正，提升用户体验
    if (_editButton.selected == YES) {
        [self edit:_editButton];
    }
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _bottomView.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
}


- (void)setupNavi
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"购物车";
    
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _editButton = editButton;
    [editButton sizeToFit];   //一定要自适应尺寸
    //向右下偏移一点
    editButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, -5, -5);
    [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];

}


- (void)setupNoneCartView
{
    KFNoneCartView *noneCartView = [KFNoneCartView noneCartView];
    noneCartView.frame = self.view.bounds;
    [self.view addSubview:noneCartView];
    noneCartView.guangBtnClick = ^{
        
        self.tabBarController.selectedIndex = 0;
    };
    
    _noneCartView = noneCartView;
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView ;
    _tableView.rowHeight = 87;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = KFColor(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + 49 + 44, 0);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"KFCartCell" bundle:nil] forCellReuseIdentifier:cartCellID ];
}

- (void)setupCartBottomView
{
    KFCartBottomView *bottomView = [KFCartBottomView cartBottomView];
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
    bottomView.totleCount = 0;
    bottomView.delegate = self;
    
}


#pragma mark 加载数据库里的数据（考虑到加载多次，因此在viewWillAppear里调用）
- (void)loadCartData
{

    NSArray *lists = [FMDBHelper query:FMDBNoneCartTable];
   //根据购物车里是否有数据判断是否隐藏
    if (lists.count == 0) {
        _noneCartView.hidden = NO;
        
    }else{
        _noneCartView.hidden = YES;
        
        //字典模型转数据模型
        self.cartList = [KFCartTradeItem mj_objectArrayWithKeyValuesArray:lists];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.cartList.count];
        
        
        //计算总价
        _totleCount = 0;
        for (int i = 0; i < self.cartList.count; i++) {
            KFCartTradeItem *item = self.cartList[i];
            CGFloat price = [item.price floatValue] * item.buyCount;
            _totleCount += price;
        }
        _bottomView.totleCount = _totleCount;
        [self.tableView reloadData];

        
        //计算倒计时
        KFCartTradeItem *item = self.cartList[0];
        if (_isSetted == NO) {
            _maxLeftTime = item.leftTime;
            [self.timeDownTimer fire];   //开启倒计时时间

            _isSetted = YES;
        }
        
    }
    
}

//定时器事件
- (void)minusTheTime
{
    _maxLeftTime --;
    
    //每个cell的时间也需要减小
    for (KFCartTradeItem *item in self.cartList) {
        item.leftTime --;
    }
    
    //结束定时器事件
    if (_maxLeftTime == 0) {
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:CartTradeTimeOut object:nil];

        [self.timeDownTimer invalidate];
        self.timeDownTimer = nil;
        
    }
}

#pragma  CartCell按钮点击的通知

- (void)cellAddButtonDidClick:(NSNotification *)noti
{
    KFCartCell *cell = noti.object;
    
    //更新总价
    _totleCount += [cell.tradeItem.price floatValue];
    _bottomView.totleCount = _totleCount;
  
    if (cell.tradeItem.buyCount > 0) {
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        KFCartTradeItem *item = self.cartList[indexPath.row];
        
        item.isClicked = NO;
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)cellMinusButtonDidClick:(NSNotification *)noti
{
    KFCartCell *cell = noti.object;
    
    //更新总价
    _totleCount -= [cell.tradeItem.price floatValue];
    _bottomView.totleCount = _totleCount;
    
    //如果减到0，移除
    if (cell.tradeItem.buyCount == 0) {

        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        KFCartTradeItem *item = self.cartList[indexPath.row];

        item.isClicked = YES;
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)cellPickButtonDidClick:(NSNotification *)noti
{
    KFCartCell *cell = noti.object;
    
    //如果取消
    if (cell.tradeItem.isClicked == YES) {
        
        //从总价中减去该商品
        CGFloat thisPrice = [cell.tradeItem.price floatValue] * cell.tradeItem.buyCount;
        _totleCount -= thisPrice;
        _bottomView.totleCount = _totleCount;
    }else{
        //从总价中加上该商品
        CGFloat thisPrice = [cell.tradeItem.price floatValue] * cell.tradeItem.buyCount;
        _totleCount += thisPrice;
        _bottomView.totleCount = _totleCount;
    }
}


#pragma mark tableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 0 : self.cartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        KFCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:cartCellID];
        cartCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cartCell.tradeItem = self.cartList[indexPath.row];
        return cartCell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        KFCartCountDownHeader *countHeader = [KFCartCountDownHeader countDownHeader];

        countHeader.maxLeftTime = _maxLeftTime;
        return countHeader;
    }
    else{
        KFCartSectionHeader *sectionHeader = [KFCartSectionHeader sectionHeader];
        sectionHeader.gotoPick = ^{
            self.tabBarController.selectedIndex = 0;
        };
        return sectionHeader;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footer = [[UIView alloc]initWithFrame:CGRectZero];
        footer.backgroundColor = _tableView.backgroundColor;
        
        UIButton *adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [adBtn setTitle:@"100%正品保证，格格家特卖全场满88包邮" forState:UIControlStateNormal];
        [adBtn setImage:[UIImage imageNamed:@"cmSelectAccount"] forState:UIControlStateNormal];
        [adBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        adBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        adBtn.userInteractionEnabled = NO;
        [adBtn sizeToFit];
        adBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        adBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [footer addSubview:adBtn];
        return footer;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 25 : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? 10 : 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //跳转到对应的商品详情控制器
    UIViewController *goodsDetail = [[UIViewController alloc]init];
    goodsDetail.navigationItem.title = @"商品详情";
    goodsDetail.view.backgroundColor = KFRandomColor;
    
    [self.navigationController pushViewController:goodsDetail animated:YES];
}


#pragma mark 实现cell的右滑删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //刷新总价
        KFCartTradeItem *item = self.cartList[indexPath.row];
        if (item.buyCount > 0) {
            CGFloat thisPrice = [item.price floatValue] * item.buyCount;
            _totleCount -= thisPrice;
            _bottomView.totleCount = _totleCount;
        }
        
        //移除数据
        [self.cartList removeObjectAtIndex:indexPath.row];
        
        //移出数据库
        NSString *where = [NSString stringWithFormat:@"title='%@'",item.title];
        [FMDBHelper remove:FMDBNoneCartTable where:where];
        
        //刷新表格
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新badgeValue
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.cartList.count];
        
        
        
    }];
    
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"插入" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[rowAction1,rowAction2];
}



#pragma mark KFCartBottomViewDelegate
- (void)cartBottomView:(KFCartBottomView *)bottomView didClickAccountButton:(UIButton *)accountButton
{
    //如果是去结算
    if ([accountButton.currentTitle  isEqual: @"去结算"]) {
        //如果倒计时已经完成
        if (_maxLeftTime <= 0) {
            _maxLeftTime = 10;   //重新进入倒计时
            
            for (KFCartTradeItem *item in self.cartList) {
                item.leftTime = 10;
            }
            
            [self.tableView reloadData];
            [self.timeDownTimer fire];
            
            
            bottomView.totleCount = _totleCount;
            
        }
        //如果还在倒计时
        else{
            BOOL isLoginSuccess = [ZQLoginTool sharedZQLoginTool].isLoginSuccess;
            
            if (isLoginSuccess) {
                //如果已经登陆，跳到订单界面
                KFPurchaseViewController *purchase = [[KFPurchaseViewController alloc]init];
                purchase.totleCount = _totleCount;
                purchase.cartList = self.cartList;
                purchase.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:purchase animated:YES];
                
            }
            else{
               //如果没有登陆，跳到登陆界面
                KFLoginViewController *login = [[KFLoginViewController alloc]init];
                
                //隐藏底部tabBar
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }
            
            
        }
    }
    //如果是删除商品
    else{
        
        //如果倒计时已经完成
        if (_maxLeftTime <= 0) {
            _maxLeftTime = 120;   //重新进入倒计时
            
            for (KFCartTradeItem *item in self.cartList) {
                item.leftTime = 120;
            }
            
            [self.tableView reloadData];
            [self.timeDownTimer fire];
            
            bottomView.totleCount = _totleCount;
            
        }
        //如果还在倒计时
        else{
            
            //将选中的商品删除，更新总价
            NSEnumerator *enumerator = [self.cartList reverseObjectEnumerator];   //逆序遍历，防止崩溃
            for (KFCartTradeItem *item in enumerator) {
                if (item.isClicked == NO) {
                    
                    //总价减少
                    _totleCount -= [item.price floatValue] * item.buyCount;
                    
                    //从数据库里面移除数据
                    NSString *where = [NSString stringWithFormat:@"title='%@'",item.title];
                    [FMDBHelper remove:FMDBNoneCartTable where:where];

                    
                    //删除数据(注意逆序遍历)
                    [self.cartList removeObject:item];
                    
                    
                }
            }
            
            [_tableView reloadData];
            //更新总价显示
            _bottomView.totleCount = _totleCount;
            
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.cartList.count];
            
        }
        
    }
    
}

- (void)cartBottomView:(KFCartBottomView *)bottomView didClickAllSelectButton:(UIButton *)allSelectButton
{
    allSelectButton.selected = !allSelectButton.selected;
    
    
    if (allSelectButton.selected == NO) {
        
        for (KFCartTradeItem *item in self.cartList) {
            item.isClicked = YES;
            [_tableView reloadData];
            
        }
        //重新计算总价
        _totleCount = 0;
        bottomView.totleCount = _totleCount;
    }
    else{
        for (KFCartTradeItem *item in self.cartList) {
            item.isClicked = NO;
            [_tableView reloadData];
            if (item.buyCount == 0) {
                item.buyCount = 1;
            }
            _totleCount += [item.price floatValue] * item.buyCount;
            
        }
        bottomView.totleCount = _totleCount;
    }
    
}


#pragma mark 事件监听
- (void)edit:(UIButton *)button
{
    button.selected = !button.selected;
    
    [UIView animateWithDuration:0.35 animations:^{
        _bottomView.Y += 44;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            NSString *buttonTitle = button.selected ? @"删除商品" : @"去结算";
            [_bottomView.gotoAccountBtn setTitle:buttonTitle forState:UIControlStateNormal];
            _bottomView.Y -= 44;
        }completion:^(BOOL finished) {
            //取消全选
            [self cartBottomView:_bottomView didClickAllSelectButton:_bottomView.allSelectBtn];
        }];
    }];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
