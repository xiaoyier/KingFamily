
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface DeviceSensorDataModel : NSObject
/**
 *  当前位置信息
 */
@property (nonatomic, strong) CLLocation *devSenCurrentLoc;
/**
 *  手机相对于正北方向的夹角（0.0 - 359.9）
 */
@property (nonatomic, assign) float devSenAngleFromNorth;
/**
 *  设备当前的倾斜度（-1.0 到 0 到 1.0）
 */
@property (nonatomic, assign) float devSenSlopeZ;

@end



@interface DeviceSensorTool : NSObject

single_interface(DeviceSensorTool)

/**
 *  供外界访问的传感器各项信息
 */
@property (nonatomic, strong) DeviceSensorDataModel *deviceSensorData;

/**
 *  开始检测获取设备信息
 */
- (void)run;
/**
 *  停止检测设备信息
 */
- (void)stop;




@end
