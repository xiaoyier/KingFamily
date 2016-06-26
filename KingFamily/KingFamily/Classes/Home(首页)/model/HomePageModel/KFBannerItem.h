//
//  KFBannerItem.h
//  KingFamily
//
//  Created by Sycamore on 16/4/19.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFBannerItem : NSObject

//滚动广告板模型
@property (nonatomic,copy) NSString *bannerID;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *commonActivitiesName;
@property (nonatomic,copy) NSString *umname;
@end
