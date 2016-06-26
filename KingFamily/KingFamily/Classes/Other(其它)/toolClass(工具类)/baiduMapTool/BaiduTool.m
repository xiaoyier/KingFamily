//
//  BaiduTool.m
//
//  Created by Sycamore on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "BaiduTool.h"
#import "BNCoreServices.h"

@interface BaiduTool ()<BMKPoiSearchDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>
/** 检索对象 */
@property (nonatomic, strong) BMKPoiSearch *searcher;

/** 保存代码块属性 */
@property (nonatomic, copy) ResultBlock block;

@end

@implementation BaiduTool
single_implementation(BaiduTool)

#pragma mark - 懒加载
- (BMKPoiSearch *)searcher {
    if (_searcher == nil) {
        //初始化检索对象
        _searcher = [[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (void)poiSearchWithCenter:(CLLocationCoordinate2D)center keyword:(NSString *)keyword resultBlock:(ResultBlock)resultBlock {
    
    // 记录block
    self.block = resultBlock;
    
    // 发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    // 第几页
    option.pageIndex = 0;
    // 每一页数量
    option.pageCapacity = 20;
    // 搜索位置
    option.location = center;
    // 搜索关键字
    option.keyword = keyword;
    BOOL flag = [self.searcher poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索成功");
        
        // 1.获取兴趣点列表
        NSArray *pois = poiResultList.poiInfoList;
        
        // 2.回到block
        self.block(pois,nil);
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        self.block(nil,@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
        self.block(nil,[NSString stringWithFormat:@"起始点有歧义%zd",error]);
    }
}

- (BMKPointAnnotation *)addAnnotationWithCenter:(CLLocationCoordinate2D)center title:(NSString *)title subTitle:(NSString *)subTitle mapView:(BMKMapView *)mapView {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = center.latitude;
    coor.longitude = center.longitude;
    annotation.coordinate = coor;
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];
    
    return annotation;
}

- (void)beginNavigationWithStartCoordinate:(CLLocationCoordinate2D)start endCoordinate:(CLLocationCoordinate2D) end
{
    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = start.longitude;
    startNode.pos.y = start.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = end.longitude;
    endNode.pos.y = end.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    //发起路径规划
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}


- (void)routePlanDidFinished:(NSDictionary *)userInfo{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}


//结束导航会调用此方法
- (void)onExitNaviUI:(NSDictionary *)extraInfo
{
    //结束导航
    [[NSNotificationCenter defaultCenter]postNotificationName:RouteNavigationCancel object:nil];
}



@end
