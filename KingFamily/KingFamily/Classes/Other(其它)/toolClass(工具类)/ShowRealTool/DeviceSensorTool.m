

#import "DeviceSensorTool.h"
#import <CoreMotion/CoreMotion.h>
@implementation DeviceSensorDataModel

@end


@interface DeviceSensorTool()<CLLocationManagerDelegate>

/**
 *  用于获取位置信息和设备朝向的位置管理器
 */
@property (nonatomic, strong) CLLocationManager *locationM;
/**
 *  用于获取传感器信息的管理器
 */
@property (nonatomic, strong) CMMotionManager *motionM;


@end

@implementation DeviceSensorTool

single_implementation(DeviceSensorTool)

-(CMMotionManager *)motionM
{
    if (!_motionM) {
        _motionM = [[CMMotionManager alloc] init];
        _motionM.deviceMotionUpdateInterval = 0.05;
    }
    return _motionM;
}

-(CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.headingFilter = 0.5;
        _locationM.distanceFilter = 10;
        if([_locationM respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationM requestAlwaysAuthorization]; // 永久授权
        }
        _locationM.delegate = self;
        [_locationM setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    return _locationM;
}

-(DeviceSensorDataModel *)deviceSensorData
{
    if (!_deviceSensorData) {
        _deviceSensorData = [[DeviceSensorDataModel alloc] init];
    }
    
    // 修改属性参数,供外界访问
    _deviceSensorData.devSenSlopeZ = self.motionM.deviceMotion.gravity.z;
    
    return _deviceSensorData;
}



-(void)run
{
    [self stop];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationM startUpdatingLocation];
    }

    // 磁力计传感器(获取设备朝向)
    if ([CLLocationManager headingAvailable]) {
        [self.locationM startUpdatingHeading];
    }

    // 陀螺仪传感器(可以获取设备在空间内的持握方式)
    if ([self.motionM isDeviceMotionAvailable]) {
        [self.motionM startDeviceMotionUpdates];
    }
}

-(void)stop
{
    [self.locationM stopUpdatingLocation];
    [self.locationM stopUpdatingHeading];
    [self.motionM stopDeviceMotionUpdates];
    self.locationM = nil;
    self.motionM = nil;
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 修改属性参数,供外界访问
    CLLocation *anyL = [locations lastObject];
    self.deviceSensorData.devSenCurrentLoc = anyL;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // 修改属性参数,供外界访问
    self.deviceSensorData.devSenAngleFromNorth = newHeading.trueHeading;
}



@end
