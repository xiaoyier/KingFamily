//
//  KFPurchaseViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//


//（地址信息，商品信息，付款方式（微信，支付宝，银联）,如果支付失败，将订单加到我的－待付款）
#import "KFPurchaseViewController.h"
#import "KFCartBottomView.h"
#import "KFCartCell.h"
#import "KFPurchasePayCell.h"
#import "KFCartTradeItem.h"
#import "SVProgressHUD.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface KFPurchaseViewController () <UITableViewDataSource,UITableViewDelegate,KFCartBottomViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) KFCartBottomView *bottomView;
@property (nonatomic,strong)NSArray *groupTitles;
@property (nonatomic,strong) NSArray *payList;

@property (nonatomic,copy) NSString *selectedPayWay;
@end

@implementation KFPurchaseViewController

static NSString  * const payCellID = @"payCell";
static NSString  * const cartCellID = @"cartCell";
static NSString  * const AddressCellID = @"addressCell";

- (NSArray *)groupTitles
{
    if (!_groupTitles) {
        _groupTitles = @[@"地址信息",@"商品信息",@"付款方式"];
    }
    return _groupTitles;
}

- (NSArray *)payList
{
    if (!_payList) {
        _payList = @[
                     @{@"img" : @"pay_ali",@"name" : @"支付宝"},
                     @{@"img" : @"pay_wx",@"name" : @"微信"},
                     @{@"img" : @"pay_up",@"name" : @"银联"}
                     ];
    }
    return _payList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"完成订单";
    
    [self setupTableView];
    
    [self setupBottomView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _bottomView.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.backgroundColor = KFColor(245, 245, 245);
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + 44, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"KFCartCell" bundle:nil] forCellReuseIdentifier:cartCellID];
    [tableView registerNib:[UINib nibWithNibName:@"KFPurchasePayCell" bundle:nil] forCellReuseIdentifier:payCellID];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddressCellID];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    
    //默认选中支付宝支付
    [self tableView:tableView didSelectRowAtIndexPath:indexPath ];
}


- (void)setupBottomView
{
    KFCartBottomView *bottomView = [KFCartBottomView cartBottomView];
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
    bottomView.totleCount = _totleCount;
    bottomView.allSelectBtn.hidden = YES;
    bottomView.delegate = self;
    
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _cartList.count;
    }{
        return self.payList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:AddressCellID];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        addressCell.contentView.backgroundColor = [UIColor orangeColor];
        addressCell.textLabel.text = @"新增收货地址";
        return addressCell;
    }else if (indexPath.section == 1){
        
        KFCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:cartCellID];
        cartCell.selectionStyle = UITableViewCellSelectionStyleNone;
        KFCartTradeItem *item = self.cartList[indexPath.row];
        item.leftTime = 0;
        cartCell.tradeItem = item;
        
        return cartCell;
        
    }else{
        KFPurchasePayCell *payCell = [tableView dequeueReusableCellWithIdentifier:payCellID];
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        payCell.payInfo = self.payList[indexPath.row];
        
        return payCell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectZero];
    header.backgroundColor = KFColor(230, 230, 230);
    UILabel *title = [[UILabel alloc]init];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor blackColor];
    if (section == 1) {
        title.text = @"全部订单";
    }else if (section == 2){
        title.text = @"选择支付方式";
    }
    [title sizeToFit];
    title.X = 10;
    title.centerY = 17.5;
    [header addSubview:title];
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return section == 0 ? 10 : 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? 0 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return 87;
    }else{
        return 50;
    }
}


//cell的选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中第一行，直接跳转
    if (indexPath.section == 0) {
        
        UIViewController *addressVc = [[UIViewController alloc]init];
        addressVc.view.backgroundColor = KFRandomColor;
        addressVc.navigationItem.title = @"新增地址";
        [self.navigationController pushViewController:addressVc animated:YES];
    }
    
    //选中支付组
    else if (indexPath.section == 2){
        
        KFPurchasePayCell *payCell = [tableView cellForRowAtIndexPath:indexPath];
        payCell.selectBtn.selected = YES;
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前正选中的按钮(无效)
//    NSIndexPath *seletedIndexPath = [tableView indexPathForSelectedRow];
//    if (seletedIndexPath.section != indexPath.section) {
//        return;
//    }
    if (indexPath.section == 2) {
        KFPurchasePayCell *payCell = [tableView cellForRowAtIndexPath:indexPath];
        payCell.selectBtn.selected = NO;
    }
}


//点击去结算
- (void)cartBottomView:(KFCartBottomView *)bottomView didClickAccountButton:(UIButton *)accountButton
{
    //取得选中的cell
    for (NSInteger i = 0; i < 3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
        
        KFPurchasePayCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.selectBtn.selected == YES) {
            
            //记录当前选中的支付方式
            _selectedPayWay = self.payList[i][@"name"];
        }
    }
    
    
    if (_selectedPayWay == nil) {
        //什么都没选，提示选择支付方式
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
    }
    //如果选中了支付宝,就采用支付宝支付
    else if ([_selectedPayWay  isEqual: @"支付宝"]){
        
        //跳转到支付宝之行支付
        [self aliPay];
        
    }else if ([_selectedPayWay  isEqual: @"微信"]){
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"微信支付尚不可用，请选择支付宝支付"];
    }else{
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"银联支付尚不可用，请选择支付宝支付"];
    }
}


//集成支付宝支付
- (void)aliPay
{
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088402263917341f"; // 商家ID
    NSString *seller = @"18588630902"; // 收款账号
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMooaWQLs7T4RTBF"
    "iTKTD1NEp5PN+plDqzhWqz3dotKXRBd4HHcIdYOGu+LolieEJpwymYastbP2omEL"
    "pMtf+mr7+O4p9jAh3dHCPcacRoeCcrn56OhiKk6bGsKTUO2/b1tyVNpRIUYZ9O3a"
    "Xu0epRM8I7NFOpHGSf6fjNTNVkmjAgMBAAECgYAev2bIQL9klx5u6SSk/JkoIRkb"
    "8ghbp18zgnspPby2KyvAJhSuRisZhjStnpK4D/GPcGLJiRtZ8/leqVa3WDHOLq8a"
    "py0qXfQ7R2LFFoQCvW5+oizLzvGqNKtj+wsyID2j87Qeui3zp0b7XaWB9yS1Sexc"
    "PowetTt+1zqDpwVWgQJBAObrrbRSZUB7fNHparPDV4Uthu4K+BIce1aGkdDxUR+l"
    "eaMkSSwKp/txDQ0nthif0r5fhBF7SgSlr5lOBuc5OYUCQQDgHQmlhBzHHx2T7Hz0"
    "Mf/gEErcuqbeS6NwZy23tfoE4TJQa60hebQsn8ChouJ2B2XrcDMH+bNhovipjJlD"
    "KQsHAkEAyg5U2yDxyd+D06U7oXn+3eB9XVMpx6c2YPq1Iq/VPSys54x7nlbgr8o3"
    "Eli6JIfMfpnTVPydQr27jhhRQAe5hQJBAK+HzsBmgyuqQT5UoWGZr7FM0XWkc4H0"
    "eCRXi8UxsIsV3pSCYW2wpt+0l+mBbCHJlZgbnryGZGr6fAw/5OJnSQ0CQQCr974t"
    "x7uDRt5mx9MhXuh1SB18ID7ibnzZOmSDRPnYTAJSRZ0YVAfNpkjsjw508MGRSsrY"
    "UwLmuDHefePlKChH"; // 私钥
    /*============================================================================*/
    /*============================================================================*/
    
    /*
     *  ----------生成订单信息及签名
     */
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = @"88888888888"; //订单ID（由商家自行制定）
    order.subject = @"所购全部商品"; //商品标题
    order.body = @"您购买的所有商品都包括在其中"; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%f",_totleCount]; //商品价格
    order.notifyURL =  @"http://www.baidu.com"; //回调URL, 用于异步通知服务器支付结果的
    
    order.service = @"mobile.securitypay.pay";  // 固定写法
    order.paymentType = @"1"; // 默认类型, 商品购买
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m"; // 订单过期时间
    order.showURL = @"m.alipay.com";
    
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"kingFamily";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   orderSpec, signedString, @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
    

}

@end
