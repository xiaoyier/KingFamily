
/**
 *  关于所有经纬度坐标计算的工具类
 */
#import <CoreLocation/CoreLocation.h>

@interface LocCacuTool : NSObject

/**
 *  计算两个坐标构成的线段与正北方向的夹角
 *
 *  @param pointA 终点坐标
 *  @param pointB 起点坐标
 *
 *  @return 夹角
 */
+ (double)angleWithBeginPoint:(CLLocationCoordinate2D)beginP andEndPoint:(CLLocationCoordinate2D)endP;

/**
 *  计算两个坐标之间的距离
 *
 *  @param pointA 终点坐标
 *  @param pointB 起点坐标
 *
 *  @return 距离
 */
+ (double)distanceWithPointA:(CLLocationCoordinate2D)pointA andPointB:(CLLocationCoordinate2D)pointB;


@end
