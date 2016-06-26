//
//  CardView.h
//  随便走
//
//  Created by num:369 on 15/6/16.
//  Copyright (c) 2015年 jf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDataModel.h"
#import "DeviceSensorTool.h"


@interface CardView : UIView

+ (instancetype)cardView;

// 接收卡牌数据模型, 用于更新卡牌内容
@property (nonatomic, strong) CardDataModel *cardDataM;

// 接受传感器数据模型, 用于更新本视图的位置
@property (nonatomic, strong) DeviceSensorDataModel *devSenDataM;


//选定后跳转到导航界面
@property (nonatomic,copy) void(^selectBlock)(CardDataModel *cardDataM);

@end
