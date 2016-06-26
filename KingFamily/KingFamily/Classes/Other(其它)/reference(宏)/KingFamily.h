//
//  KingFamily.h
//  KingFamily
//
//  Created by 张强 on 16/4/15.
//  Copyright © 2016年 King. All rights reserved.
//

#ifndef KingFamily_h
#define KingFamily_h

//屏幕相关
#define Screen_Bounds           [UIScreen mainScreen].bounds
#define Screen_Size             [UIScreen mainScreen].bounds.size
#define Screen_Width            [UIScreen mainScreen].bounds.size.width
#define Screen_Height           [UIScreen mainScreen].bounds.size.height
#define kScreenSize             Screen_Size
//rgb颜色
#define KFColor(r,g,b)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

//随机颜色
#define KFRandomColor           KFColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

//导航条／tabBar的主题颜色
#define Bar_TintColor           KFColor(207,52,41)

//字体大小
#define kFont12                 [UIFont systemFontOfSize:12]
#define kFont14                 [UIFont systemFontOfSize:14]
#define kFont16                 [UIFont systemFontOfSize:16]
#define kFont18                 [UIFont systemFontOfSize:18]
#define kFont20                 [UIFont systemFontOfSize:20]
#define kFont22                 [UIFont systemFontOfSize:22]
#define kFont24                 [UIFont systemFontOfSize:24]

//导航条文字颜色
#define Navi_TitleColor         [UIColor whiteColor]

#define RefreshTableView        @"refreshTableView"
#define RouteNavigationCancel   @"routeNavigationCancel"

//FMDB相关
#define FMDBFileName            @"fmdb.sqlite"
#define FMDBNoneCartTable       @"noneCart_table"
#define FMDBHomeChildVCTable    @"homeChild_table"

//时间相关
#define Second_Day      86400
#define Second_Hour     3600
#define Second_Minute   60

#define CartTradeTimeOut        @"cartTradeTimeOut"
#define CartCellAdd             @"cartCellAdd"
#define CartCellMinus           @"cartCellMinus"
#define CartCellPickButtonClick @"cartCellPickButtonClick"
#define ForumChanged            @"forumChanged"


#define KFSmallMargin           10
#define KFSmallSmallMargin      5
#define KFTagButtonColor        KFColor(66, 139, 239)
#define KFTagH                  25



#import "UIView+Frame.h"
#import "UIImage+Render.h"
#import "UIImage+Resize.h"
#import "Singleton.h"
#import "NSString+Hash.h"   //加密


//弱指针处理
#define KFWeakSelf                          __weak typeof(self) weakSelf = self

#endif
