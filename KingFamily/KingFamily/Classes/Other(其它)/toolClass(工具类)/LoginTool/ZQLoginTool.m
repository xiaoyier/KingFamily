//
//  ZQLoginTool.m
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "ZQLoginTool.h"
#import "FMDBHelper.h"

@interface ZQLoginTool ()

@property (nonatomic,copy) NSString *accountMD5String;
@property (nonatomic,copy) NSString *passwordMD5String;

@end

@implementation ZQLoginTool


#define AccountTable  @"account_table"

single_implementation(ZQLoginTool)

- (BOOL)registerWithAccountName:(NSString *)accountName accountPassword:(NSString *)accountPassword success:(void (^)())success failure:(void(^)())failure
{
    
    //判断用户名和密码是否合法
    if (accountName.length != 11 || accountPassword.length < 6) {
        failure();
        
        //记录下注册失败
        _isRegisterSuccess = NO;
        return NO;
    }
    //如果用户名和密码合法
    else{
        
        //将用户名和密码采用md5加盐加密，然后保存
        NSString *serverAccountName = [NSString stringWithFormat:@"%@KF",accountName];
        NSString *serverAccountPassword = [NSString stringWithFormat:@"%@KF",accountPassword];
        _accountMD5String = [serverAccountName md5String];
        _passwordMD5String = [serverAccountPassword md5String];
        
        //上传至服务器（此处省略）
        
        //保存至数据库
        NSString *createAccountTable = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key , account text not null , password text not null)",AccountTable];
        
        //创建表格
        [FMDBHelper createTable:createAccountTable];
        
        //插入数据
        NSDictionary *keyValues = @{
                                    @"account" : _accountMD5String,
                                    @"password" : _passwordMD5String
                                    };
        [FMDBHelper insert:AccountTable keyValues:keyValues replace:YES];
        
        success();
        
        //记录下登录注册成功
        _isRegisterSuccess = YES;
        return YES;
        
    }

}


- (BOOL)loginWithAccountName:(NSString *)accountName accountPassword:(NSString *)accountPassword success:(void (^)())success failure:(void(^)())failure
{
    //判断用户名和密码是否合法
    if (accountName.length != 11 || accountPassword.length < 6) {
        failure();
        _isLoginSuccess = NO;
        return NO;
    }
    //如果用户名和密码合法
    else{
        
        //将用户名和密码采用md5加盐加密，然后保存
        NSString *serverAccountName = [[NSString stringWithFormat:@"%@KF",accountName]md5String];
        NSString *serverAccountPassword = [[NSString stringWithFormat:@"%@KF",accountPassword]md5String];
        
        
        NSString *createAccountTable = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key , account text not null , password text not null)",AccountTable];
        
        //创建表格(防止第一次登录的时候，表格还未创建)
        [FMDBHelper createTable:createAccountTable];
        
        //从数据库取出最新数据
        NSArray *accounts = [FMDBHelper query:AccountTable];
        
        if (accounts.count > 0) {
            _accountMD5String = accounts.lastObject[@"account"];
            _passwordMD5String = accounts.lastObject[@"password"];
        }

        
        //如果账号密码正确
        if ([serverAccountName isEqualToString:_accountMD5String] && [serverAccountPassword isEqualToString:_passwordMD5String]) {
            
            success();
            _isLoginSuccess = YES;
            return YES;
        }
        
        else{
            failure();
            _isLoginSuccess = NO;
            return NO;
        }
        
    }

}


@end
