//
//  KFLocationViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFLocationViewController.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
#import <Masonry/Masonry.h>
#import <CoreLocation/CoreLocation.h>
#import "BaiduTool.h"
#import "KFShowRealViewController.h"
#import "KFNavigationController.h"



@interface KFLocationViewController ()<UISearchBarDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,weak) UIView *cover;
@property (nonatomic,strong)BMKLocationService  *locationService;
@property (nonatomic,strong) CLLocationManager * manager;
@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,copy) NSString *searchText;
@property (nonatomic,strong) BMKUserLocation *userLocation;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (nonatomic,strong) NSArray *pois;
@end

@implementation KFLocationViewController

- (NSMutableArray *)annotations
{
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_manager requestWhenInUseAuthorization];
        }
//        _manager.delegate = self;
    }
    
    return _manager;
}


#pragma mark 初始化设置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];

    [self setupMapView];
}

- (void)setupNavi
{
    
    UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, -20, Screen_Width, 64)];
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"搜索目的地";
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    _searchBar = searchBar;
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cover addSubview:searchBar];
    cover.tag = 101;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:button];
    
    [self.navigationController.navigationBar addSubview:cover];
    _cover = cover;

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cover.mas_right).offset(-20);
        make.top.equalTo(cover.mas_top).offset(30);
    }];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cover.mas_left).offset(10);
        make.top.equalTo(cover.mas_top).offset(30);
        make.bottom.equalTo(cover.mas_bottom).offset(-5);
        make.right.equalTo(button.mas_left).offset(-10);
    }];


}

- (void)setupMapView
{
    
    _locationService = [[BMKLocationService alloc]init];
    
    _locationService.delegate = self;
    
    
    _mapView.trafficEnabled = YES;   //显示交通状况
    _mapView.showMapScaleBar = YES;  //显示比例尺
    _mapView.zoomLevel = 14;         //显示比例
    
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(23.117055306224895, 113.2759952545166);
    
    BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = YES;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量（经度）
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    
    [_mapView updateLocationViewWithParam:displayParam];


}

//开始定位
- (void)startLocation
{
    _mapView.showsUserLocation = YES;
    _mapView.overlooking = 0;
    [self.locationService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    _mapView.zoomLevel = 17;
    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


#pragma mark 事件处理
- (IBAction)locate:(UIButton *)sender {
    
    [self startLocation];

}


- (IBAction)more:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //热力图
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"热力图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _mapView.baiduHeatMapEnabled = YES;

    }];
    
    //标准地图
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"标准地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.trafficEnabled = YES;
        _mapView.baiduHeatMapEnabled = NO;
    }];
    
    //卫星地图
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"卫星地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _mapView.mapType = BMKMapTypeSatellite;
        _mapView.trafficEnabled = YES;
        _mapView.baiduHeatMapEnabled = NO;
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"3D地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _mapView.buildingsEnabled = YES;
        _mapView.overlooking = -45;
        _mapView.trafficEnabled = NO;
        _mapView.baiduHeatMapEnabled = NO;
    }];
    
    //隐藏交通状况
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"隐藏交通状况" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _mapView.trafficEnabled = NO;
        _mapView.baiduHeatMapEnabled = NO;
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];
    

    [self presentViewController:alert animated:YES completion:nil];
}


- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

//展示实景
- (IBAction)showReal:(UIButton *)sender {
    
    KFShowRealViewController *realVC = [[KFShowRealViewController alloc]init];
    
    realVC.userLocation = _userLocation;
    realVC.poiInfoList = _pois;
    KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:realVC];
    
    [self presentViewController:navi animated:YES completion: nil];
}


#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    _searchText = searchBar.text;
    
    //开始POI检索
    CLLocationCoordinate2D coordinate = _userLocation.location.coordinate;
    BaiduTool *baiduTool = [BaiduTool sharedBaiduTool];
    [baiduTool poiSearchWithCenter:coordinate keyword:_searchText resultBlock:^(NSArray<BMKPoiInfo *> *poiInfoList, NSString *error) {
        if (error == nil) {
            
            //获取所有兴趣点
            _pois = poiInfoList;
            
            //移除之前的大头针
            if (self.annotations.count > 0) {
                [_mapView removeAnnotations:self.annotations];
            }
            //添加大头针
            // 2.添加大头针
            [_pois enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                BMKPointAnnotation *annotation = [[BaiduTool sharedBaiduTool] addAnnotationWithCenter:obj.pt title:obj.name subTitle:obj.address mapView:_mapView];
                [self.annotations addObject:annotation];
            }];
            

            // 控制地图的显示区域
            CLLocationCoordinate2D center = coordinate;
            BMKCoordinateSpan span = {0.1,0.1};
            BMKCoordinateRegion region = (BMKCoordinateRegion){center,span};
            [_mapView setRegion:region];
            _mapView.zoomLevel = 17;

        }
    }];
}


//点击某个大头针的时候会调用此方法
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
    BMKPointAnnotation *annotation = view.annotation;
    CLLocationCoordinate2D endCoordinate = annotation.coordinate;
    CLLocationCoordinate2D startCoordinate = _userLocation.location.coordinate;
    
    
    //开始导航
    [[BaiduTool sharedBaiduTool]beginNavigationWithStartCoordinate:startCoordinate endCoordinate:endCoordinate];
}



@end
