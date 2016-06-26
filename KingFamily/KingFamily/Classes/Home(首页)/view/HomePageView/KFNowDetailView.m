//
//  KFNowDetailView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFNowDetailView.h"
#import "KFNowDetailItem.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


#define Second_Day      86400
#define Second_Hour     3600
#define Second_Minute   60
@interface KFNowDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *rightDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *saleTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic,weak) UIView *timeCover;
@property (nonatomic,assign) NSInteger leftSecond;    //剩余总秒数
@property (nonatomic,strong) NSTimer *timer;          //定时器
@end

@implementation KFNowDetailView

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(minusWithSecond) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)awakeFromNib {
    // Initialization code
    [self initialSetup];
    

}

- (void)initialSetup
{
    _leftDescLabel.textColor = KFColor(100, 100, 100);
    _flagView.contentMode = UIViewContentModeCenter;
    _rightDescLabel.textColor = Bar_TintColor;
    _timeLabel.textColor = [UIColor whiteColor];
    
    
    //创建timeCoverView
    UIView *timeCover = [[UIView alloc]init];
    timeCover.backgroundColor = KFColor(50, 50, 50);
    timeCover.alpha = 0.35;
    
    //注意，这里需要添加到contentView上面，不然会有bug
    [self.contentView insertSubview:timeCover belowSubview:_timeLabel];
    _timeCover = timeCover;
    
    _clockImageView.hidden = YES;
}

- (void)setNowDetailItem:(KFNowDetailItem *)nowDetailItem
{
    _nowDetailItem = nowDetailItem;
    
    if (_nowDetailItem == nil) {
        return;
    }
    
        [_imageView sd_setImageWithURL:[NSURL URLWithString:nowDetailItem.image] placeholderImage:[UIImage imageNamed:@"home_default_goods"]];
    [_flagView sd_setImageWithURL:[NSURL URLWithString:nowDetailItem.flagImage]];
    _rightDescLabel.text = nowDetailItem.rightDesc;
    _leftDescLabel.text = nowDetailItem.leftDesc;
    
    //判断是否显示开抢提示
    if ([nowDetailItem.saleTimeType isEqualToString:@"1"]) {
        _saleTypeImageView.hidden = NO;
    }
    else{
        _saleTypeImageView.hidden = YES;
    }
    
    //活动开始后剩余总秒数,一天前开始
    NSInteger endSecond = [nowDetailItem.endSecond integerValue];
    
    //获得当前时间
    NSDate *now = [NSDate date];
    
    //传一个时间进来，表示活动开始计时时间
    NSString *late = @"2016-4-26 00:08:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* result = [formatter dateFromString:late];
//    NSLog(@"%@",result);

    //实时更新时间
    NSTimeInterval leftSecond = [now timeIntervalSinceDate:result];
    _leftSecond = endSecond - leftSecond;

    
    _timeLabel.hidden = NO;
    _timeCover.hidden = NO;
    _clockImageView.hidden = NO;

    //开启定时器(必须懒加载，不然会有多个定时器同时作用)
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)minusWithSecond
{
    NSInteger day,hour,minute,second;
//    NSLog(@"%ld",_leftSecond);
    //剩余天数
    _leftSecond --;
    day = _leftSecond / Second_Day;
    //剩余小时数
    hour = _leftSecond % Second_Day / Second_Hour;
    //剩余分钟数
    minute = _leftSecond % Second_Day % Second_Hour / Second_Minute;
    //剩余秒数
    second = _leftSecond % Second_Day % Second_Hour % Second_Minute;
    //    NSLog(@"%ld---%ld----%ld----%ld",day,hour,minute,second);
    if (day != 0) {
        _timeLabel.text = [NSString stringWithFormat:@"剩%ld天%ld:%ld:%ld",day,hour,minute,second];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"剩%ld:%ld:%ld",hour,minute,second];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置约束
    [_timeCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(-2.0f);
        make.right.equalTo(self.mas_right).offset(6.0f);
        make.bottom.equalTo(_timeLabel.mas_bottom).offset(2.0f);
        make.left.equalTo(_clockImageView.mas_left).offset(-6.0f);
    }];
    
    _timeCover.layer.cornerRadius = 6.0f;
}

@end
