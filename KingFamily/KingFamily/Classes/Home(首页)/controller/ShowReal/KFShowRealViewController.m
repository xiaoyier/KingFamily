//
//  RealDisplayVC.m
//  随便走
//
//  Created by num:369 on 15/6/16.
//  Copyright (c) 2015年 jf. All rights reserved.
//

#import "KFShowRealViewController.h"
#import "DeviceSensorTool.h"
#import "PlayCardDataTool.h"
#import "CardView.h"
#import "KFCompassView.h"
#import "CardDataModel.h"
#import "BaiduTool.h"

@interface KFShowRealViewController()
/**
 *  摄像头
 */
@property (nonatomic, strong) UIImagePickerController *pickerC;
/**
 *  卡牌的数据模型数组
 */
@property (nonatomic, strong) NSArray *playCardModels;
/**
 *  卡牌视图
 */
@property (nonatomic, strong) NSMutableArray *cardViews;
/**
 *  更新牌视图的定时器
 */
@property (nonatomic, weak) NSTimer *updateCellTimer;

/** 指南针 */
@property (nonatomic,weak) KFCompassView *compassView;

@end


@implementation KFShowRealViewController

#pragma mark - 懒加载方法

-(UIImagePickerController *)pickerC
{
    if (!_pickerC) {
        _pickerC = [[UIImagePickerController alloc] init];
        _pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerC.showsCameraControls = NO;
        _pickerC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        _pickerC.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        _pickerC.cameraViewTransform = CGAffineTransformScale(_pickerC.cameraViewTransform, scale, scale);
//        [self addChildViewController:_pickerC];
        
    }
    return _pickerC;
}

-(NSTimer *)updateCellTimer
{
    if (!_updateCellTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateCell) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _updateCellTimer = timer;
    }
    return _updateCellTimer;
}

-(NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [NSMutableArray array];
    }
    return _cardViews;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航条
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.title = @"实景展示";
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    //添加指南针
    KFCompassView *compassView = [KFCompassView compassView];
    compassView.frame = CGRectMake(Screen_Width - 120, 100, 80, 80);
    _compassView.layer.anchorPoint = CGPointMake(0.5, 1);
    _compassView = compassView;
    
    [self.pickerC.view addSubview:compassView];
    // 添加摄像头背景
    [self.view addSubview:self.pickerC.view];
    
//    NSLog(@"%@----%@",_userLocation,_poiInfoList);
    //  加载数据源
    [PlayCardDataTool getCardDatasWithUserLocation:_userLocation poiInfoList:_poiInfoList Success:^(NSArray *result) {
        self.playCardModels = result;

    } failed:^{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误！" message:@"未对自身进行定位，请先定位自身位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }];

    // 启动刷新任务
    [self updateCellTimer];
    
    //为防止数据加载的问题，主动刷新一下卡牌
    [self loadCardView];
    
    
    //接收结束导航的通知
    [[NSNotificationCenter defaultCenter]addObserverForName:RouteNavigationCancel object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        //重新加载卡牌试图；
        [self loadCardView];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    // 启动传感器监听
    [[DeviceSensorTool sharedDeviceSensorTool] run];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 停止传感器监听
    [[DeviceSensorTool sharedDeviceSensorTool] stop];
}


/**
 *  重写数据源set方法,用于重新加载所有卡牌
 *
 */
-(void)setPlayCardModels:(NSArray *)playCardModels
{
    _playCardModels = playCardModels;
    [self loadCardView];
}


/**
 *  根据数据模型加载卡牌
 */
- (void)loadCardView
{
    // 移除旧的视图
    [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cardViews = nil;
    // 创建加载新的视图
    [self.playCardModels enumerateObjectsUsingBlock:^(CardDataModel *dataM, NSUInteger idx, BOOL *stop) {
        CardView *cardView = [CardView cardView];
        cardView.cardDataM = dataM;
        [self.view addSubview:cardView];
        [self.cardViews addObject:cardView];
        
        cardView.selectBlock = ^(CardDataModel *cardData){
            
            //开始导航
            [[BaiduTool sharedBaiduTool]beginNavigationWithStartCoordinate:_userLocation.location.coordinate endCoordinate:cardData.cardLocationCoor];
        };
    }];
}

/**
 *  不断更新每个卡牌的位置和内容
 */
- (void)updateCell
{
    [self.cardViews makeObjectsPerformSelector:@selector(setDevSenDataM:) withObject:[DeviceSensorTool sharedDeviceSensorTool].deviceSensorData];
    
    //角度转弧度
    CGFloat angel = [DeviceSensorTool sharedDeviceSensorTool].deviceSensorData.devSenAngleFromNorth / 180 * M_PI;
    //指南针旋转
    _compassView.transform = CGAffineTransformMakeRotation(angel);
    
}


- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
