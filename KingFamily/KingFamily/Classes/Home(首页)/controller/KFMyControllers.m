//
//  KFMyControllers.m
//  KingFamily
//
//  Created by Sycamore on 16/6/25.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFMyControllers.h"
#import "home.h"
#import "FMDBHelper.h"
#import "KFHomePageBaseViewCoontroller.h"

static NSMutableArray *_myContrs;

@implementation KFMyControllers

+(void)initialize{
    _myContrs = [NSMutableArray array];
    
   
    
    //首页
    KFHomePageViewController *homePage = [[KFHomePageViewController alloc]init];
    homePage.title = @"首页";
    [_myContrs addObject:homePage];
    
    //休闲零食
    KFLeisureFoodViewController *leisureFood = [[KFLeisureFoodViewController alloc]init];
    leisureFood.title = @"休闲零食";
    [_myContrs addObject:leisureFood];
    
    //格格厨房
    KFKichenViewController *kichen = [[KFKichenViewController alloc]init];
    kichen.title = @"格格厨房";
    [_myContrs addObject:kichen];
    
    //保健滋补
    KFHealthFoodViewController *health = [[KFHealthFoodViewController alloc]init];
    health.title = @"保健滋补";
    [_myContrs addObject:health];
    
    //母婴辅食
    KFBabyFoodViewController *baby = [[KFBabyFoodViewController alloc]init];
    baby.title = @"母婴辅食";
    [_myContrs addObject:baby];
    
    //水果生鲜
    KFFruitViewController *fruit = [[KFFruitViewController alloc]init];
    fruit.title = @"水果生鲜";
    [_myContrs addObject:fruit];
    
    //最后疯抢
    KFLastPurchaseViewController *last = [[KFLastPurchaseViewController alloc]init];
    last.title = @"最后疯抢";
    [_myContrs addObject:last];
    
    //即将开抢
    KFWillPurchaseViewController *will = [[KFWillPurchaseViewController alloc]init];
    will.title = @"即将开抢";
    [_myContrs addObject:will];
    
    
    //加载进数据库
    NSString *createTable = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key not null , className text not null,title text not null)",FMDBHomeChildVCTable];
    
    //创建数据库
    [FMDBHelper createTable:createTable];
    
    //如果数据库已经有数据了，直接返回
    NSArray *list = [FMDBHelper query:FMDBHomeChildVCTable];
    NSLog(@"%@",list);
    if (list.count > 0) {
        return;
    }
    
    //插入数据
    for (NSInteger i = 0; i < _myContrs.count; i++) {
        KFHomePageBaseViewCoontroller *vc = _myContrs[i];
        NSString *subClass = NSStringFromClass([vc class]);
        NSString *title = [_myContrs[i] title];
        NSDictionary *keyValues = @{
                                    @"className" : subClass,
                                    @"title" : title
                                    };
        [FMDBHelper insert:FMDBHomeChildVCTable keyValues:keyValues replace:YES];
    }
    
    
}
+(NSArray *)myContrs{

    _myContrs = [self getControllersFromDB];

    return _myContrs;
}

+(void)setMyContrs:(NSArray *)myControllers{
    
    //删除旧数据
    [FMDBHelper remove:FMDBHomeChildVCTable];
    
    //插入数据
    for (NSInteger i = 0; i < myControllers.count; i++) {
        KFHomePageBaseViewCoontroller *vc = myControllers[i];
        NSString *className = NSStringFromClass([vc class]);
        NSString *title = [myControllers[i] title];
        NSDictionary *keyValues = @{
                                    @"className" : className,
                                    @"title" : title
                                    };
        [FMDBHelper insert:FMDBHomeChildVCTable keyValues:keyValues replace:YES];
    }
    
    
    _myContrs = [self getControllersFromDB];
    

}


+ (NSMutableArray *)getControllersFromDB
{
    
    NSMutableArray *result = [NSMutableArray array];
    
    //从数据库中读取数据
    NSArray *controllers = [FMDBHelper query:FMDBHomeChildVCTable];
    NSLog(@"%@",controllers);
    NSInteger count = controllers.count;
    for (NSInteger i = 0; i < count; i++) {
        //创建对象
        Class subClass = NSClassFromString(controllers[i][@"className"]);
        KFHomePageBaseViewCoontroller *vc = [[subClass alloc]init];
        vc.title = controllers[i][@"title"];
        [result addObject:vc];
    }
    
    return result;

}
@end
