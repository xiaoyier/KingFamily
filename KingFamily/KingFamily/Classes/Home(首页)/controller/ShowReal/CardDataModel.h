//
//  CardDataModel.h
//  随便走
//
//  Created by num:369 on 15/6/16.
//  Copyright (c) 2015年 jf. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
@interface CardDataModel : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *cardDataTitle;
/**
 *  所在位置(经纬度)
 */
@property (nonatomic, assign) CLLocationCoordinate2D cardLocationCoor;


@end
