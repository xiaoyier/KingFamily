//
//  KFRegisterViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFRegisterViewController.h"
#import "KFLoginButton.h"
#import "KFPasswordButton.h"
#import "KFThirdLoginButton.h"
#import "ZQLoginTool.h"
#import "SVProgressHUD.h"
#import <UMengSocialCOM/UMSocial.h>


@interface KFRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet KFPasswordButton *getYanzhengma;

@property (weak, nonatomic) IBOutlet KFPasswordButton *hiddenPwd;


@property (nonatomic,weak) NSTimer *timeDownTimer;
@property (nonatomic,assign) NSInteger time;
@end

@implementation KFRegisterViewController

- (NSTimer *)timeDownTimer
{
    if (!_timeDownTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _timeDownTimer = timer;
    }
    return _timeDownTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
}

- (void)timeDown
{
    _time--;
    NSString *title = [NSString stringWithFormat:@"00:%02ld",_time];
    [_getYanzhengma setTitle:title forState:UIControlStateSelected];
    [_getYanzhengma setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    if (_time == -1) {
        //结束定时器
        [self.timeDownTimer invalidate];
        self.timeDownTimer = nil;
        _getYanzhengma.selected = NO;
    }
}

#pragma mark   事件监听
- (IBAction)rigisterNow:(KFLoginButton *)sender {
    
    [[ZQLoginTool sharedZQLoginTool] registerWithAccountName:_accountTF.text accountPassword:_pwdTF.text success:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"账号注册成功"];
        
        
        //延迟1.5秒后返回上一个控制器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
        
    } failure:^{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"账号或者密码格式不符合要求，请重新输入！" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (IBAction)getYanzhengma:(KFPasswordButton *)sender {
    
    if (_accountTF.text.length != 11) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入合法的手机号码"];
        return;
    }
    
    sender.selected = YES;
    
    //开启定时器事件
    _time = 10;
    [self.timeDownTimer fire];
}
- (IBAction)hiddenPwd:(KFPasswordButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        _pwdTF.secureTextEntry = NO;
    }else{
        _pwdTF.secureTextEntry = YES;
    }
}
- (IBAction)loginWithQQ:(KFThirdLoginButton *)sender {
    
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
- (IBAction)loginWithWechat:(KFThirdLoginButton *)sender {
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


@end
