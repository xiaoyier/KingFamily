//
//  KFCartCountDownHeader.m
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFCartCountDownHeader.h"

@interface KFCartCountDownHeader ()

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (nonatomic,weak) NSTimer * timer;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;



@end

@implementation KFCartCountDownHeader

- (NSTimer *)timer
{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(cutDownTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}


+ (instancetype)countDownHeader
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFCartCountDownHeader" owner:nil options:nil]lastObject];
}

- (void)setMaxLeftTime:(NSInteger)maxLeftTime
{
    
        _maxLeftTime = maxLeftTime;
        
        if (_maxLeftTime > 0) {
            _warnLabel.hidden = YES;
            [self.timer fire];
        }else{
//            //发出通知，改变cell的样式
//            [[NSNotificationCenter defaultCenter]postNotificationName:CartTradeTimeOut object:nil];
        }
    
}

- (void)cutDownTime
{
    _maxLeftTime --;
    
    if (_maxLeftTime == -1) {
        [self.timer invalidate];
        self.timer = nil;
        _warnLabel.hidden = NO;
        
//        //发出通知，改变cell的样式
//        [[NSNotificationCenter defaultCenter]postNotificationName:CartTradeTimeOut object:nil];
        
        return;
    }
    
    _countDownLabel.attributedText = [self attrStringWithLeftTime:_maxLeftTime];
}

- (NSAttributedString *)attrStringWithLeftTime:(NSInteger)leftTime
{
    NSInteger minute = leftTime / 60;
    NSInteger second = leftTime % 60;
    NSString *leftTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc ]initWithString: @"请在内提交订单，时间结束后商品可能被抢完。"];
    
    NSMutableDictionary *timeAttr = [NSMutableDictionary dictionary];
    timeAttr[NSForegroundColorAttributeName] = [UIColor redColor];
    NSAttributedString * timeStr = [[NSAttributedString alloc]initWithString:leftTimeStr attributes:timeAttr];
     [showStr insertAttributedString:timeStr atIndex:2];
    
    return showStr;
    
    
}

@end
