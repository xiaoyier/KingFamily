//
//  KFNowDetailItem.h
//  KingFamily
//
//  Created by Sycamore on 16/4/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFNowDetailItem : NSObject

@property (nonatomic,copy) NSString *commonActivitiesName;
@property (nonatomic,copy) NSString *flagImage;
@property (nonatomic,copy) NSString *nowDetailID;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *leftDesc;
@property (nonatomic,copy) NSString *rightDesc;
@property (nonatomic,copy) NSString *saleId;
@property (nonatomic,copy) NSString *saleTimeType;       //2表示显示晚8点开抢  1表示不显示   晚8点开抢图片：statusNight@2x
@property (nonatomic,copy) NSString *endSecond;
@property (nonatomic,copy) NSString *umname;
@property (nonatomic,copy) NSString *type;               //1 跳转到购买控制器  2 跳转到详细介绍




/*
 commonActivitiesName = "\U7f8e\U56fdHyperbiotics";
 endSecond = 394619;
 flagImage = "http://yangege.b0.upaiyun.com/6808f18b4c96.png!nationalflag";
 id = 3731;
 image = "http://yangege.b0.upaiyun.com/activity/saleWindow/d478e209d4b.jpg!17newsell";
 isCollect = 0;
 labers =             (
 );
 leftDesc = "\U7f8e\U56fdHyperbiotics";
 rightDesc = "\U5929\U7136\U76ca\U751f\U5143";
 saleId = 4153;
 saleTimeType = 1;
 status = 1;
 type = 2;
 umname = "\U7f8e\U56fdHyperbiotics";

 */

@end
