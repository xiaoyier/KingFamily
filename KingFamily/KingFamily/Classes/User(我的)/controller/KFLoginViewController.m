//
//  KFLoginViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//


//（实现QQ,微信，微博三种第三方登陆方式，或者使用自己注册账号）
#import "KFLoginViewController.h"
#import "KFRegisterViewController.h"
#import "KFThirdLoginButton.h"
#import "KFLoginButton.h"
#import "ZQLoginTool.h"
#import "SVProgressHUD.h"
#import <UMengSocialCOM/UMSocial.h>

@interface KFLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@end

@implementation KFLoginViewController

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条内容
    [self setupNavi];
    
}


- (void)setupNavi
{
    self.navigationItem.title = @"登录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"快速注册" style:UIBarButtonItemStylePlain target:self action:@selector(fastRigister)];
}


#pragma mark 事件监听
- (void)fastRigister
{
    KFRegisterViewController *rigister = [[KFRegisterViewController alloc]init];
    [self.navigationController pushViewController:rigister animated:YES];
}
- (IBAction)forgetPassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"哈哈" message:@"忘记密码就别想登陆了！！！" delegate:nil cancelButtonTitle:@"不开心😔" otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)logInNow:(KFLoginButton *)sender {
    
    [[ZQLoginTool sharedZQLoginTool]loginWithAccountName:_accountTF.text accountPassword:_passwordTF.text success:^{
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
        
    } failure:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"账号或密码不正确"];
        
        //清空输入框的内容
        _accountTF.text = nil;
        _passwordTF.text = nil;
    }];
}
- (IBAction)loginInWithQQ:(KFThirdLoginButton *)sender {
    
    //集成QQ登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //  获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //记录
            [ZQLoginTool sharedZQLoginTool].isLoginSuccess = YES;
            
        }});
}
- (IBAction)logInWithWechat:(KFThirdLoginButton *)sender {
    
    //集成微信登录
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //  获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //记录
            [ZQLoginTool sharedZQLoginTool].isLoginSuccess = YES;
            
        }});

}
- (IBAction)loginWithSina:(KFThirdLoginButton *)sender {
    
    // 1.创建UMSocialSnsPlatform对象
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    // 2.第三方登录
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //记录
            [ZQLoginTool sharedZQLoginTool].isLoginSuccess = YES;
            
            
        }});
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([ZQLoginTool sharedZQLoginTool].isLoginSuccess == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //退出键盘
    [self.view endEditing:YES];
}

@end
