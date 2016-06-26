

#import "LocCacuTool.h"

@implementation LocCacuTool


+(double)angleWithBeginPoint:(CLLocationCoordinate2D)beginP andEndPoint:(CLLocationCoordinate2D)endP
{
    double yC = endP.latitude - beginP.latitude;
    double xC = endP.longitude - beginP.longitude;
    double sourceAngle = 0;
    
    if(xC * yC > 0.0) // 第一三象限
    {
        sourceAngle = atan(ABS(xC)/ABS(yC)) / M_PI * 180;
    }else
    {
        sourceAngle =  atan(ABS(yC)/ABS(xC)) / M_PI * 180;
    }
    
    if(xC >= 0) {
        sourceAngle = yC >= 0 ? sourceAngle : 90 + sourceAngle; // 第一,四象限
    }else
    {
        sourceAngle = yC >= 0 ? 270 + sourceAngle : 180 + sourceAngle; // 第二, 三象限
    }
    return sourceAngle;
}

+ (double)distanceWithPointA:(CLLocationCoordinate2D)pointA andPointB:(CLLocationCoordinate2D)pointB
{
    NSDate *timeStamp = [NSDate date];
    CLLocation *beginL = [[CLLocation alloc]initWithCoordinate:pointA altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:timeStamp];
    CLLocation *endL = [[CLLocation alloc]initWithCoordinate:pointB altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:timeStamp];
//    CLLocation *beginL = [[CLLocation alloc] initWithLatitude:pointA.latitude longitude:pointA.longitude];
//    CLLocation *endL = [[CLLocation alloc] initWithLatitude:pointB.latitude longitude:pointB.longitude];
    return [beginL distanceFromLocation:endL];
}


@end
