
#import "PlayCardDataTool.h"
#import "BaiduTool.h"


@implementation PlayCardDataTool

+ (void)getCardDatasWithUserLocation:(BMKUserLocation *)userLocation
                         poiInfoList:(NSArray *)poiInfoList
                             Success:(void (^)(NSArray *))successBlock
                              failed:(void (^)())failedBlock
{
    if (poiInfoList.count > 0) {
        
        NSMutableArray *models = [NSMutableArray array];
        for (int i = 0; i < poiInfoList.count; i++) {
            
            BMKPoiInfo *poi = poiInfoList[i];
            CardDataModel *model = [[CardDataModel alloc]init];
            model.cardDataTitle = poi.name;
            model.cardLocationCoor = poi.pt;
            [models addObject:model];
        }
        successBlock(models);
    }else{
        
        [[BaiduTool sharedBaiduTool]poiSearchWithCenter:userLocation.location.coordinate keyword:@"小吃" resultBlock:^(NSArray<BMKPoiInfo *> *poiInfoList, NSString *error) {
            if (error != nil) {
                failedBlock();
            }
            else{
                
                NSMutableArray *models = [NSMutableArray array];
                for (int i = 0; i < poiInfoList.count; i++) {
                    
                    BMKPoiInfo *poi = poiInfoList[i];
                    CardDataModel *model = [[CardDataModel alloc]init];
                    model.cardDataTitle = poi.name;
                    model.cardLocationCoor = poi.pt;
                    [models addObject:model];
                }
                
                successBlock(models);
            }
        }];
        
    }
}

@end
