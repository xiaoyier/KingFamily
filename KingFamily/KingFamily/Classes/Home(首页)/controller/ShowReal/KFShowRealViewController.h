//
//  Created by sycamor on 15/6/16.
//  Copyright (c) 2015年 sycamor. All rights reserved.
//

#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface KFShowRealViewController : UIViewController

//上一个控制器传来的检索到的大头针模型数组
@property (nonatomic,strong) NSArray *poiInfoList;

@property (nonatomic,strong) BMKUserLocation *userLocation;

@end
