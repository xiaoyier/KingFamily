//
//  ZQLoginTool.h
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ZQLoginTool : NSObject

single_interface(ZQLoginTool)

/** 记录是否注册成功 */
@property (nonatomic,assign) BOOL isRegisterSuccess;

/** 记录是否登录成功 */
@property (nonatomic,assign) BOOL isLoginSuccess;

/**
 *  传入用户名和密码进行注册
 *
 *  @param accountName     用户名
 *  @param accountPassword 密码
 *  @param success         成功回调
 *  @param failure         失败回调
 *
 *  @return 返回是否注册成功
 */

- (BOOL)registerWithAccountName:(NSString *)accountName accountPassword:(NSString *)accountPassword success:(void (^)())success failure:(void(^)())failure;



/**
 *  传入用户名和密码进行登录
 *
 *  @param accountName     用户名
 *  @param accountPassword 密码
 *  @param success         成功回调
 *  @param failure         失败回调
 *
 *  @return 返回是否登录成功
 */
- (BOOL)loginWithAccountName:(NSString *)accountName accountPassword:(NSString *)accountPassword success:(void (^)())success failure:(void(^)())failure;

@end
