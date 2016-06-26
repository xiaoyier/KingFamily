//
//  KFCartCountDownHeader.h
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFCartCountDownHeader : UIView

//最大剩余支付时间
@property (nonatomic,assign) NSInteger maxLeftTime;

+ (instancetype)countDownHeader;

@end
