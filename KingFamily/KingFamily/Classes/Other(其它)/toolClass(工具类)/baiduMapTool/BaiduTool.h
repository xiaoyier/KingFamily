//
//  BaiduTool.h
//
//  Created by Sycamore on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^ResultBlock) (NSArray <BMKPoiInfo *> *poiInfoList, NSString *error);

@interface BaiduTool : NSObject
single_interface(BaiduTool)


/**
 *  自定义方法,根据中心和关键字进行检索
 *
 *  @param center      中心
 *  @param keyword     关键字
 *  @param resultBlock 回调代码块
 */
- (void)poiSearchWithCenter:(CLLocationCoordinate2D)center keyword:(NSString *)keyword resultBlock:(ResultBlock)resultBlock;


/**
 *  根据传入的中心,标题和子标题创建大头针
 *
 *  @param center   中心
 *  @param title    标题
 *  @param subTitle 子标题
 */
- (BMKPointAnnotation *)addAnnotationWithCenter:(CLLocationCoordinate2D)center title:(NSString *)title subTitle:(NSString *)subTitle mapView:(BMKMapView *)mapView;


//开始导航
- (void)beginNavigationWithStartCoordinate:(CLLocationCoordinate2D)start endCoordinate:(CLLocationCoordinate2D) end;

@end
