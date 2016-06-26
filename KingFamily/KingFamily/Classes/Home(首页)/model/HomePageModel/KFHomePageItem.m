//
//  KFHomePageItem.m
//  KingFamily
//
//  Created by Sycamore on 16/4/19.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomePageItem.h"
#import <MJExtension.h>
#import "HomePageModel.h"

static NSString *const KFHomePageBannerList       = @"bannerList";
static NSString *const KFHomePageNowList          = @"nowList";
static NSString *const KFHomePageActivityList     = @"activityList";
static NSString *const KFHomePageHotList          = @"hotList";
static NSString *const KFHomePageNowRecommend     = @"nowGegeRecommend";
static NSString *const KFHomePageFunctionList     = @"functionList";
static NSString *const KFHomePageStatus           = @"status";
static NSString *const KFHomePageBrandRecommend   = @"brandRecommend";
static NSString *const KFHomePageGegeWelfare      = @"gegeWelfare";



@implementation KFHomePageItem

//由于数据结构比较复杂，用的地方也都不一样，所以抽一个模型，在里面完成各自的字典转模型

- (NSMutableArray *)allModelArray
{
    if (!_allModelArray) {
        _allModelArray = [NSMutableArray array];
    }
    return _allModelArray;
}

+ (instancetype)itemWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}


//进行所有的字典转模型工作
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    
    if (self && [dic isKindOfClass:[NSDictionary class]] ) {
        
        //1 广告板
        NSArray *bannerArray = [dic objectForKey:KFHomePageBannerList];
        self.bannerList = [KFBannerItem mj_objectArrayWithKeyValuesArray:bannerArray];
        [self addObjectWithTitle:nil array:_bannerList singleItem:YES];
        
        //2 将funcioonList字典数组转成模型数组
        NSArray *functionDicArray = [dic objectForKey:KFHomePageFunctionList];
        self.functionList = [KFFunctionItem mj_objectArrayWithKeyValuesArray:functionDicArray];
        [self addObjectWithTitle:nil array:_functionList singleItem:YES];
        
        //将activity数组里的元素都转成模型
        NSArray *activityList = [dic objectForKey:KFHomePageActivityList];
        //将数组里的所有字典转成模型,注意数组里面装着数组，数组里面是字典，需要把字典给转成模型
        [KFActivityItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"content" : @"KFContentItem",
                     };
        }];
        //3 活动列表
        self.activityList = [KFActivityItem mj_objectArrayWithKeyValuesArray:activityList];
        KFActivityItem *activityItem = (_activityList.count > 0) ? _activityList[0] : nil ;
        [self addObjectWithTitle:nil array:activityItem.content singleItem:NO];
        
        //4 格格推荐
        NSDictionary *recommendDic = [dic objectForKey:KFHomePageNowRecommend];
        [KFNowRecommendItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"content" : @"KFContentItem",
                     };
        }];
        self.nowRecommendList = [KFNowRecommendItem mj_objectWithKeyValues:recommendDic];
        [self addObjectWithTitle:_nowRecommendList.title array:_nowRecommendList.content singleItem:NO];

        //5 格格福利
        NSDictionary *welfare = [dic objectForKey:KFHomePageGegeWelfare];
        [KFWelfareItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"content" : @"KFContentItem",
                     };
            
        }];
        self.welfareList = [KFWelfareItem mj_objectWithKeyValues:welfare];
        [self addObjectWithTitle:_welfareList.title array:_welfareList.content singleItem:NO];
        
        //6 品牌推荐
        NSDictionary *brandList = [dic objectForKey:KFHomePageBrandRecommend];
        [KFBrandRecommend mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"content" : @"KFContentItem",
                     };
        }];
        self.brandRecommendList = [KFBrandRecommend mj_objectWithKeyValues:brandList];
        [self addObjectWithTitle:_brandRecommendList.title array:_brandRecommendList.content singleItem:YES];


        //7 今日最热
        NSArray *hotArray = [dic objectForKey:KFHomePageHotList];
        self.hotList = [KFHotItem mj_objectArrayWithKeyValuesArray:hotArray];
        [self addObjectWithTitle:@"今日火热" array:_hotList singleItem:YES];

        //8 今日热卖
        self.nowList = [dic objectForKey:KFHomePageNowList];
//        [self addObjectWithTitle:@"今日热卖" array:_nowList singleItem:NO];
        
        //9 状态标示
        self.status = [dic objectForKey:KFHomePageStatus];
        
        
        
    }
    return self;
}

//
//- (void)getModelsFromItem:(KFHomePageItem *)item
//{
//    //1 banner-----数组模型------滚动广告板
//    for (KFBannerItem *bannerItem in item.bannerList) {
//        [self.bannerImageList addObject:bannerItem.image];
//    }
//    if (item.bannerList.count > 0) {
//        KFHomaPagaObject *bannerObject = [KFHomaPagaObject objectWithTitle:nil array:_bannerImageList];
//        [self.allModelArray addObject:bannerObject];
//    }
//    else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    
//    
//    //2 functionList-----数组模型-------按钮部分
//    //取出图片
//    for (KFFunctionItem *functionitem in item.functionList) {
//        [self.functionImageList addObject:functionitem.image];
//    }
//    
//    if (item.functionList.count > 0) {
//        KFHomaPagaObject *functionObject = [KFHomaPagaObject objectWithTitle:nil array:_functionImageList];
//        [self.allModelArray addObject:functionObject];
//    }
//    else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    
//    //3 activityList----数组模型-------activityCell
//    if (item.activityList.count > 0) {
//        KFActivityItem *activityItem = item.activityList[0];
//        _activityList = activityItem.content;
//        
//        [self.allModelArray addObject:_activityList];
//    }   else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    
//    // 4 gegenowRecommend----字典模型,activityCell
//    if (item.nowRecommendList.content.count > 0) {
//        _gegeRecommendList = item.nowRecommendList.content;
//        [self.allModelArray addObject:_gegeRecommendList];
//    }
//    else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    
//    // 5 welfareList-----字典模型,activityCell
//    if (item.welfareList.content.count > 0) {
//        _welfareList = item.welfareList.content;
//        [self.allModelArray addObject:_welfareList];
//    }
//    else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    // 6 brandRecommend------字典模型，brandRecommendCell
//    _brandRecommendList = item.brandRecommendList.content;
//    
//    //不要把数组装进来，这些数据是要显示在一个cell里面的
//    if (item.brandRecommendList.content.count > 0) {
//        [self.allModelArray addObject:item.brandRecommendList];
//    }else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//    
//    // 7 hotList------数组模型---------todayHotView
//    _todayHotList = item.hotList;
//    if (item.hotList.count > 0) {
//        KFHomaPagaObject *hotObject = [KFHomaPagaObject objectWithTitle:@"今日最热" array:_todayHotList];
//        [self.allModelArray addObject:hotObject];
//    }else{
//        [self.allModelArray addObject:[NSNull null]];
//    }
//}

- (void)addObjectWithTitle:(NSString *) title array:(NSArray *)array singleItem:(BOOL)singleItem
{
    if (array.count == 0) {
        [self.allModelArray addObject:[NSNull null]];
    }
    else{
        KFHomaPagaObject *hotObject = [KFHomaPagaObject objectWithTitle:title array:(NSMutableArray *)array singleItem:singleItem];
        [self.allModelArray addObject:hotObject];
    }
}
@end
