//
//  KFUserController.m
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//


#import "KFUserController.h"
#import "ZQLoginTool.h"
#import "KFLoginViewController.h"
#import "KFRegisterViewController.h"
#import <MJExtension/MJExtension.h>
#import "KFCollectionCellButtonItem.h"
#import "KFOrderAboutView.h"
#import "KFSecondSectionView.h"
#import <UMengSocialCOM/UMSocial.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "SVProgressHUD.h"
#import "KFFirstSectionHeader.h"
#import "KFUserSettingController.h"


#define topImageH  200

@interface KFUserController () <UITableViewDataSource,UITableViewDelegate,KFOrderAboutViewDelegate,KFSecondSectionDelegate,QRCodeReaderDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;


@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic,weak) UIButton *regBtn;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConst;

@property (nonatomic,strong) NSMutableArray *items;
@end

@implementation KFUserController


static NSString * const firstCellID = @"firstCell";
static NSString * const secondCellID = @"secondCell";


#pragma mark 懒加载
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
        NSArray *itemList = @[
                   //第一组
                   @[
                       @{@"imageName" : @"user_topay" , @"title" : @"待付款"},
                       @{@"imageName" : @"userPendingSend", @"title" : @"待发货"},
                       @{@"imageName" : @"user_rec", @"title" : @"待收货"},
                       @{@"imageName" : @"user_done", @"title" : @"待评价"},
                       @{@"imageName" : @"userRefund", @"title" : @"退款/退货"}
                    ],
                   //第二组
                   @[
                       @{@"imageName" : @"user_signin" , @"title" : @"签到" , @"detailTitle" : @"领取今日奖励"},
                       @{@"imageName" : @"user_fav", @"title" : @"收藏"},
                       @{@"imageName" : @"user_invite", @"title" : @"分享"},
                       @{@"imageName" : @"user_share", @"title" : @"积分"},
                       @{@"imageName" : @"user_newbie", @"title" : @"新人专享"},
                       @{@"imageName" : @"user_contact", @"title" : @"客服与帮助"},
                       @{@"imageName" : @"user_about", @"title" : @"关于格格家"},
                       @{@"imageName" : @"user_order", @"title" : @"二维码"},
                    ]
                   ];
        
        //字典转模型
        NSArray *items1 = [KFCollectionCellButtonItem mj_objectArrayWithKeyValuesArray:itemList[0]];
        NSArray *items2 = [KFCollectionCellButtonItem mj_objectArrayWithKeyValuesArray:itemList[1]];
        [_items addObject:items1];
        [_items addObject:items2];
    }
    return _items;
}

#pragma mark －初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置界面
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //查询当前的登录状态
    BOOL isLoginSuccess = [ZQLoginTool sharedZQLoginTool].isLoginSuccess;
    if (isLoginSuccess) {
        _loginBtn.hidden = YES;
        _loginButton.hidden = YES;
        _registerButton.hidden = YES;
        _regBtn.hidden = YES;
        _userName.hidden = NO;
        _userIcon.hidden = NO;
    }else{
        _loginButton.hidden = NO;
        _loginBtn.hidden = NO;
        _registerButton.hidden = NO;
        _regBtn.hidden = NO;
        _userName.hidden = YES;
        _userIcon.hidden = YES;
    }
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    _tableView.backgroundColor = KFColor(245, 245, 245);
    
    //注册cell
    [_tableView registerClass:[KFOrderAboutView class] forCellReuseIdentifier:firstCellID];
    [_tableView registerClass:[KFSecondSectionView class] forCellReuseIdentifier:secondCellID];
    
    
    _userIcon.layer.cornerRadius = _userIcon.width * 0.5;
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.borderWidth = 1;
    _userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 1;
    
    _registerButton.layer.cornerRadius = 5;
    _registerButton.layer.borderWidth = 1;
    _registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(Screen_Width * 0.5 - 140, topImageH * 0.5 - 15, 100, 30);
    loginBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn = loginBtn;
    
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(Screen_Width * 0.5 + 40, topImageH * 0.5 - 15, 100, 30);
    regBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:regBtn];
    [regBtn addTarget:self action:@selector(gotoRegister:) forControlEvents:UIControlEventTouchUpInside];
    _regBtn = regBtn;
    
    
    [self setNavigationBar];
    
}


-(void)setNavigationBar
{
    self.title = @"我的";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingrightBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - 事件监听
-(void)settingrightBarButtonItemClick
{
    //跳转到设置控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"KFUserSettingController" bundle:nil];
    KFUserSettingController *setting = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:setting animated:YES];
    
}

- (IBAction)gotoRegister:(UIButton *)sender {
    
    _topView.userInteractionEnabled = YES;
    KFRegisterViewController *registerVC = [[KFRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)gotoLogin:(UIButton *)sender {
    
    KFLoginViewController *login = [[KFLoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
    
}


#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat down =  -_tableView.contentOffset.y - topImageH;
    
    //顶部View的实际高度
    CGFloat realH = topImageH  + down ;
    
        //顶部view的拉伸
        _topViewHeightConst.constant = realH;

}

//结束滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        [_tableView setContentOffset:CGPointMake(0, -topImageH) animated:YES];
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        KFOrderAboutView *orderCell = [tableView dequeueReusableCellWithIdentifier:firstCellID];
        
        orderCell.items = self.items[0];
        
        orderCell.delegate = self;
        
        return orderCell;
    }else{
        
        KFSecondSectionView *secondCell = [tableView dequeueReusableCellWithIdentifier:secondCellID];
        
        secondCell.items = self.items[1];
        
        secondCell.delegate = self;
        
        return secondCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        KFFirstSectionHeader *header = [KFFirstSectionHeader header];
        __weak typeof(self) weakSelf = self;
        header.touchHandeler = ^{
            
            if ([ZQLoginTool sharedZQLoginTool].isLoginSuccess) {
                //跳转到购物车
                weakSelf.tabBarController.selectedIndex = 2;
            }else{
                
                //跳转到登录界面
                KFLoginViewController *login = [[KFLoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];

            }
        };
        
        return header;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 60 : 180;
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 40 : 0.0001 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



- (void)orderAboutView:(KFOrderAboutView *)order didSelectCell:(NSInteger)index
{
    //首先看登录状态
    if ([ZQLoginTool sharedZQLoginTool].isLoginSuccess) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"该功能还未完成，尽请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        
        
        //跳转到登录界面
        KFLoginViewController *login = [[KFLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)secondSectionView:(KFSecondSectionView *)second didSelectCell:(NSInteger)index
{
    //如果是分享，实现分享功能
    if (index == 2) {
        
        //集成友盟分享
        [self UMengShare];
    }
    else if (index == 7)
    {
        //集成二维码
        [self scanQRCode];
    }
    
    else{
        
        //尽请期待
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"该功能还未完成，尽请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];

    }
}


//分享
- (void)UMengShare
{
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    
    [UMSocialData defaultData].extConfig.title = @"KingFamily真是太好了";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"实现友盟社会化分享，这个真是太棒了！"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:nil
                                       delegate:nil];
}


//扫描二维码
- (void)scanQRCode
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }

}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSString *str;
        if ([result containsString:@"http"]) {
            str = [NSString stringWithFormat:@"是否跳转到%@",result];
        }else{
            str = result;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


# pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *result = alertView.message;
        if ([result containsString:@"http"]) {
            
            //执行跳转
            NSString *subStr = [result substringFromIndex:5];
            NSURL *url = [NSURL URLWithString:subStr];
            
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }else{
            
            //执行取消
            [self alertView:alertView clickedButtonAtIndex:0];
        }
    }
}


@end
