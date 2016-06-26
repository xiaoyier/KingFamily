
#import <Foundation/Foundation.h>
#import "CardDataModel.h"
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>


@interface PlayCardDataTool : NSObject

#pragma mark 如果已经检索过了，把检索过的数据传过来，如果没有检索，则检索附近的小吃店
+ (void)getCardDatasWithUserLocation:(BMKUserLocation *)userLocation
                         poiInfoList:(NSArray *)poiInfoList
                             Success:(void (^)(NSArray *))successBlock
                              failed:(void (^)())failedBlock;


@end
