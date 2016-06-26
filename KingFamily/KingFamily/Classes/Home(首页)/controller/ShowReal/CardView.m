//
//  CardView.m
//  随便走
//
//  Created by num:369 on 15/6/16.
//  Copyright (c) 2015年 jf. All rights reserved.
//

#import "CardView.h"
#import "LocCacuTool.h"
#import "DeviceSensorTool.h"

@interface CardView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end


@implementation CardView

+(instancetype)cardView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CardView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    // 设置圆角
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}


-(void)setCardDataM:(CardDataModel *)cardDataM
{
    _cardDataM = cardDataM;
    self.titleLabel.text = _cardDataM.cardDataTitle;
    
}

-(void)setDevSenDataM:(DeviceSensorDataModel *)devSenDataM
{
    _devSenDataM = devSenDataM;
    NSString *distance = [NSString stringWithFormat:@"%.fm", [LocCacuTool distanceWithPointA:_cardDataM.cardLocationCoor andPointB:self.devSenDataM.devSenCurrentLoc.coordinate]];
    // 更新距离显示
    self.distanceLabel.text = distance;
    
    // 计算X位置
        /** 算法分析:
            1, 计算当前位置与目标位置所构成的线段与正北方向所成夹角 angleCard;
            2, 计算设备朝向(与正北方向夹角)与 angleCard 的差 angleM (有符号数);
            3, 以屏幕宽度一半为分界线即 baseX = 屏幕宽度 * 0.5, 以及 确定单位角度移动距离 distanceXUnit;
            4, x = baseX + (angleM * distanceUnit)
         */
    
    float angleCard = [LocCacuTool angleWithBeginPoint:devSenDataM.devSenCurrentLoc.coordinate andEndPoint:self.cardDataM.cardLocationCoor];
    float angleM = angleCard - devSenDataM.devSenAngleFromNorth;
    float baseX = kScreenSize.width * 0.5;
    float distanceXUnit = (kScreenSize.width + self.width) / 15;
    float x = baseX + angleM * distanceXUnit;
    
    // 计算Y位置
        /** 算法分析:
         1, 获取当前设备Z轴倾斜度 devSenSlopeZ;
         2, 确定每 0.01值 变化范围内 Y 轴的移动距离 distanceYUnit;
         3, 以屏幕高度度一半为分界线即 baseY = 屏幕高度 * 0.5;
         4, y = baseY + (devSenSlopeZ * distanceYUnit)
         */
    float distanceYUnit = kScreenSize.height * 0.8 / 1;
    float baseY = kScreenSize.height ;
    float y = baseY + devSenDataM.devSenSlopeZ * distanceYUnit - [distance floatValue] / 3;
    
    
    
    if (x < - self.width * 0.5 || x > kScreenSize.width + self.width * 0.5 || y < -self.height * 0.5 || y > kScreenSize.height + self.height * 0.5) {
        self.hidden = YES;
    }else
    {
        self.hidden = NO;
    }
    
    // 设置本视图位置
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.center = CGPointMake(x, y);
    } completion:^(BOOL finished) {
        
    }];
}

//监听点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    if (_selectBlock != nil) {
        _selectBlock(self.cardDataM);
    }
    
    
}

@end
