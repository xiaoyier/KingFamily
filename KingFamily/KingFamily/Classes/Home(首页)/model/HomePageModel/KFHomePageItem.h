//
//  KFHomePageItem.h
//  KingFamily
//
//  Created by Sycamore on 16/4/19.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KFNowRecommendItem,KFWelfareItem,KFActivityItem,KFBrandRecommend;
@interface KFHomePageItem : NSObject

@property (nonatomic,strong) NSArray *bannerList;
@property (nonatomic,strong) NSArray *nowList;
@property (nonatomic,strong) NSArray *activityList;
@property (nonatomic,strong) NSArray *hotList;
@property (nonatomic,strong) NSArray *functionList;
@property (nonatomic,strong) KFNowRecommendItem *nowRecommendList;
@property (nonatomic,strong) KFWelfareItem *welfareList;
@property (nonatomic,strong) KFBrandRecommend *brandRecommendList;
@property (nonatomic,copy)   NSString *status;
@property (nonatomic,strong) NSMutableArray *allModelArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)itemWithDic:(NSDictionary *)dic;

@end
