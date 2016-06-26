//
//  KFHomePageBaseViewCoontroller.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomePageBaseViewCoontroller.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "NSDictionary+PropertyName.h"
#import "HomePageModel.h"
#import "KFHomePageItem.h"
#import "KFBanberView.h"
#import "KFFunctionListView.h"
#import "KFActivityCell.h"
#import "KFBrandRecommendView.h"
#import "KFTodayHotView.h"
#import "NSString+ArrayIndex.h"
#import "KFNowDetailItem.h"
#import "KFNowDetailView.h"
#import "KFSectionHeaderView.h"
#import "KFSectionFooterView.h"
#import <MJRefresh/MJRefresh.h>
#import <FMDB/FMDB.h>
#import "FMDBHelper.h"




#define Screen_Factor Screen_Width * 0.5 / 376.0


@interface KFHomePageBaseViewCoontroller ()<UICollectionViewDelegateFlowLayout,KFFunctionListViewDelegate>

//@property (nonatomic,strong) NSArray        *bannerList;             //顶部滚动视图
@property (nonatomic,strong) NSMutableArray *bannerImageList;        //顶部滚动时图所有图片
//@property (nonatomic,strong) NSArray        *functionList;           //一行按钮部分
@property (nonatomic,strong) NSMutableArray *functionImageList;      //按钮所有图片
@property (nonatomic,strong) NSArray        *gegeRecommendList;      //格格推荐
@property (nonatomic,strong) NSArray        *welfareList;            //福利团
@property (nonatomic,strong) NSArray        *brandRecommendList;     //品牌推荐
@property (nonatomic,strong) NSArray        *todayHotList;           //今日最热
@property (nonatomic,strong) NSMutableArray *nowDetailList;          //今日热卖
@property (nonatomic,strong) NSArray        *activityList;           //活动部分
@property (nonatomic,strong) NSMutableArray *allModelArray;          //存放所有模型的数组

@end

@implementation KFHomePageBaseViewCoontroller
static NSString * const nomalCellReuseIdentifier            = @"nomal";
static NSString * const bannerCellReuseIdentifier           = @"banner";
static NSString * const functionCellReuseIdentifier         = @"function";
static NSString * const activityCellResueIdentifier         = @"activity";
static NSString * const brandRecommendReuseIdentifier       = @"brandRecommend";
static NSString * const todayHotReuseIdentifier             = @"todayHot";
static NSString * const nowDetailReuseIdentifier            = @"nowDetail";
static NSString * const sectionHeaderReuseIdentifier        = @"sectionHeader";
static NSString * const sectionFooterReuseIdentifier        = @"sectionFooter";


static NSInteger scrollIndex  = 1;
//从plist里加载今日热卖数据
- (NSMutableArray *)nowDetailList
{
    if (!_nowDetailList) {
        _nowDetailList = [NSMutableArray array];
        NSString *FilePath = [[NSBundle mainBundle]pathForResource:@"homeNowList.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:FilePath];
        for (NSArray *nowDetail in array) {
            NSArray *nowDetailItem = [NSArray array];
            nowDetailItem = [KFNowDetailItem mj_objectArrayWithKeyValuesArray:nowDetail];
            
            [_nowDetailList addObject:nowDetailItem];
        }
    }
    return _nowDetailList;
}

-  (NSMutableArray *)bannerImageList
{
    if (!_bannerImageList) {
        _bannerImageList = [NSMutableArray array];
    }
    return _bannerImageList;
}

- (NSMutableArray *)functionImageList
{
    if (!_functionImageList) {
        _functionImageList = [NSMutableArray array];
    }
    return _functionImageList;
}

- (NSMutableArray *)allModelArray
{
    if (!_allModelArray) {
        _allModelArray = [NSMutableArray array];
    }
    return _allModelArray;
}

//创建collectionView,重写init方法
- (instancetype)init
{
    //设定布局方式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0;
    
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //监听网络状态
    [self setupNetwork];
    
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = KFColor(240, 240, 240);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:nomalCellReuseIdentifier];
    [self.collectionView registerClass:[KFBanberView class] forCellWithReuseIdentifier:bannerCellReuseIdentifier];
    [self.collectionView registerClass:[KFFunctionListView class] forCellWithReuseIdentifier:functionCellReuseIdentifier];
    [self.collectionView registerClass:[KFActivityCell class] forCellWithReuseIdentifier:activityCellResueIdentifier];
    [self.collectionView registerClass:[KFBrandRecommendView class] forCellWithReuseIdentifier:brandRecommendReuseIdentifier];
    [self.collectionView registerClass:[KFTodayHotView class] forCellWithReuseIdentifier:todayHotReuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KFNowDetailView" bundle:nil] forCellWithReuseIdentifier:nowDetailReuseIdentifier];
    
    //注册首尾view
    [self.collectionView registerClass:[KFSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderReuseIdentifier];
    [self.collectionView registerClass:[KFSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterReuseIdentifier];;
    

    //设置刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(POST)];
    [self.collectionView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:RefreshTableView object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if(self.collectionView.superview){
            [self reloadData];
        }
    }];
}

//监听网络状态的改变
- (void)setupNetwork
{
    //获得单例网络状态管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //监听网络状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                UIImage *loadFailedImage = [UIImage imageNamed:@"loadfail"];
                UIImageView *imgView = [[UIImageView alloc]initWithImage:loadFailedImage];
                imgView.center = self.view.center;
                [self.view addSubview:imgView];
                
                return ;
            }
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G | 4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
                
            default:
                break;
        }
    }];
    
    //开启监听网络状态，开启后就会一直坚挺
    [manager startMonitoring];

}

//获取首页列表网络数据
- (void)POST
{
    //请求是在异步完成的
    NSString *URLString = @"http://app.gegejia.com/yangege/appNative/resource/homeList";
    NSDictionary *parameters = @{@"os":@"1",
                                 @"params": @"{\"accountId\":\"0\",\"province\":\"440000\",\"type\":\"124569bc\",\"city\":\"0\"}",
                                 @"remark": @"isVestUpdate36",
                                 @"sign":@"24FCBDA07B1ABEAD",
                                 @"version":@"2.5"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //发送请求，获取首页数据
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //将解析出来的字符串转成字典先～～～，谁写的后台啊，弄成一个字符串！！！
        NSString *param = [(NSDictionary *)responseObject objectForKey:@"params"];
        NSData *newData = [param dataUsingEncoding:NSUTF8StringEncoding];
        
        //将得到的数据，写成结构清晰的字典
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
        //      NSLog(@"%@",params);
        KFHomePageItem *item = [KFHomePageItem itemWithDic:params];
        
        // 获取控制器需要的模型数据
        if (self.allModelArray != item.allModelArray) {
            
            [self getModelsFromItem:item];
            self.allModelArray = item.allModelArray;
        }
        
        
        //从本地plist里读取本日最热数据（没办法，服务器每天改参数，太不要脸了）
        //默认只加载一组数据
        if (self.nowDetailList.count > 0) {
            KFHomaPagaObject *object = [KFHomaPagaObject objectWithTitle:@"今日最热" array:_nowDetailList[0] singleItem:NO];
            [self.allModelArray addObject:object];
            //            for (KFNowDetailItem *item in _nowDetailList[1]) {
            //                [object.array addObject:item];
            //            }
            //            [self.allModelArray replaceObjectAtIndex:self.allModelArray.count - 1 withObject:object];
            
        }
        else{
            [self.allModelArray addObject:[NSNull null]];
        }
        
        //        NSInteger count = self.allModelArray.count;
        //        for (int i = 0; i < count; i ++) {
        //            NSLog(@"%@",self.allModelArray[i]);
        //        }
        
        
        //网络请求是异步发出的，但是接收到相应后数据处理在主线程进行
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
        
        //这里只是获取了20个数据
        //        NSString *nowList = [NSString stringWithArray:item.nowList index:0];
        //        NSString *nowListParam = [NSString stringWithFormat:@"{\"type\":\"2\",\"nowList\":%@,\"accountId\":\"0\"}",nowList];
        //        //成功获取数据后，再次发送请求
        //        NSString *nowListURLString = @"http://app.gegejia.com/yangege/appNative/resource/homeDetail";
        //        NSDictionary *nowListParams = @{@"os":@"1",
        //                                        @"params":nowListParam,
        //                                        @"remark": @"isVestUpdate36",
        //                                        @"sign":@"437857A4AB314B7C",
        //                                        @"version":@"2.5",
        //                                        };
        //        [manager POST:nowListURLString parameters:nowListParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        //            //请求成功，解析服务器返回的数据
        //            NSString *nowListParamsString = [responseObject objectForKey:@"params"];
        //            NSData *nowListData = [nowListParamsString dataUsingEncoding:NSUTF8StringEncoding];
        //            NSDictionary *nowListDic = [NSJSONSerialization JSONObjectWithData:nowListData options:NSJSONReadingMutableLeaves error:nil];
        //            [nowListDic writeToFile:@"/Users/Sycamore/Desktop/homePagePlist/homePage8.plist" atomically:YES];
        //
        //            //字典数组转模型数组
        //            //8 -nowDetailList -----数组模型-----nowDetailView
        //            NSArray *nowDetail = [nowListDic objectForKey:@"nowDetailList"];
        //            _nowDetailList = [KFNowDetailItem  mj_objectArrayWithKeyValuesArray:nowDetail];
        //            if (_nowDetailList.count > 0) {
        //                KFHomaPagaObject *object = [KFHomaPagaObject objectWithTitle:@"今日最热" array:_nowDetailList singleItem:NO];
        //                [self.allModelArray addObject:object];
        //            }
        //            else{
        //                [self.allModelArray addObject:[NSNull null]];
        //            }
        //
        //            [self.collectionView reloadData];
        //
        //        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"%@---------%@",task.response.MIMEType,error);
        //        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@-------%@",task.response.MIMEType,error);
    }];
    
    
}

- (void)getModelsFromItem:(KFHomePageItem *)item
{
    //1 banner-----数组模型------滚动广告板
    self.bannerImageList = [NSMutableArray array];
    for (KFBannerItem *bannerItem in item.bannerList) {
        [self.bannerImageList addObject:bannerItem.image];
    }
    
    
    
    //2 functionList-----数组模型-------按钮部分
    //取出图片
    for (KFFunctionItem *functionitem in item.functionList) {
        [self.functionImageList addObject:functionitem.image];
    }
    
    
    
    //3 activityList----数组模型-------activityCell
    
    KFActivityItem *activityItem = item.activityList.count > 0 ? item.activityList[0] : nil;
    _activityList = activityItem.content;
    
    
    // 4 gegenowRecommend----字典模型,activityCell
    _gegeRecommendList = item.nowRecommendList.content;
    
    // 5 welfareList-----字典模型,activityCell
    _welfareList = item.welfareList.content;
    
    // 6 brandRecommend------字典模型，brandRecommendCell
    _brandRecommendList = item.brandRecommendList.content;
    
    
    // 7 hotList------数组模型---------todayHotView
    _todayHotList = item.hotList;
    
    
}

#pragma mark  处理数据缓存

- (void)resolveFMDBData
{
    
    //如果没有数据，直接返回
    if (_todayHotList.count == 0) {
        return;
    }
    
//    //先删除表格
//    NSString *dropTable = [NSString stringWithFormat:@"drop table if exists %@",FMDBNoneCartTable];
//    [FMDBHelper createTable:dropTable];
    
    NSString *createTable = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key,image text not null , title text not null,  price real not null,leftTime integer not null,buyCount integer not null)",FMDBNoneCartTable];
    //创建表格
    [FMDBHelper createTable:createTable];
    
    //先清空表格
    [FMDBHelper remove:FMDBNoneCartTable];
    
    //插入数据
    for (NSInteger i = 0; i < _todayHotList.count; i ++) {
        KFHotItem *hotItem = _todayHotList[i];
        NSDictionary *keyValues = @{
                                    @"image" : hotItem.image,
                                    @"title" : hotItem.title,
                                    @"price" : hotItem.price,
                                    @"leftTime" : @"120",
                                    @"buyCount" : @"1"
                                    };
        [FMDBHelper insert:FMDBNoneCartTable keyValues:keyValues replace:YES];
    }
    
}



#pragma mark <UICollectionViewDataSource>

//多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.allModelArray.count;
    
}


//多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //返回每组有多少模型
    id object = self.allModelArray[section];
    
    //如果是空模型，返回0
    if ([object isKindOfClass:[NSNull class]]) {
        return 0;
    }
    //如果不为空，根据是否显示单行返回数据
    else{
        KFHomaPagaObject *homePageItem = (KFHomaPagaObject *)object;
        if (homePageItem.SingleItem == YES) {
            return 1;
        }
        else return homePageItem.array.count;
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionCount = self.allModelArray.count;
    //第一组，显示广告滚动板
    if (indexPath.section == 0) {
        KFBanberView *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCellReuseIdentifier forIndexPath:indexPath];
        bannerCell.bannerImageList = self.bannerImageList;
        return bannerCell;
    }
    
    //第二组 显示按钮框
    else if (indexPath.section == 1)
    {
        KFFunctionListView *functionCell = [collectionView dequeueReusableCellWithReuseIdentifier:functionCellReuseIdentifier forIndexPath:indexPath ];
        functionCell.functionImageList = _functionImageList;
        
        //设置代理，监听按钮的点击
        functionCell.delegate = self;
        return functionCell;
    }
    
    //第3-5组，图片展示
    else if (indexPath.section > 1 && indexPath.section < sectionCount - 3 ){
        KFActivityCell *activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellResueIdentifier forIndexPath:indexPath];
        KFHomaPagaObject *homePageItem = self.allModelArray[indexPath.section];
        KFContentItem *contentItem = homePageItem.array[indexPath.row];
        activityCell.contentItem = contentItem;
        return activityCell;
        
    }
    //第6组 品牌推荐
    else if (indexPath.section == sectionCount - 3)
    {
        //显示品牌推荐
        KFBrandRecommendView *brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:brandRecommendReuseIdentifier forIndexPath:indexPath];
        brandCell.contentItems = _brandRecommendList;
        return brandCell;
    }
    
    //第7组，今日火热
    else if (indexPath.section == sectionCount - 2)
    {
        KFTodayHotView *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:todayHotReuseIdentifier forIndexPath:indexPath];
        hotCell.hotItems = [self.allModelArray[indexPath.section] array];
        return hotCell;
    }
    
    //第8组
    else{
        KFNowDetailView *nowDetailCell = [collectionView dequeueReusableCellWithReuseIdentifier:nowDetailReuseIdentifier forIndexPath:indexPath];
        KFHomaPagaObject *homeItem = self.allModelArray[indexPath.section];
        nowDetailCell.nowDetailItem = homeItem.array[indexPath.row];
        return nowDetailCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = sectionHeaderReuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        reuseId = sectionFooterReuseIdentifier;
    }
    //获得可重用的view
    UICollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId forIndexPath:indexPath];
    
    //判断是sectionHeader还是footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //转成自定义的headerView
        KFSectionHeaderView *HeaderView = (KFSectionHeaderView *)reuseView;
        KFHomaPagaObject *homeItem = self.allModelArray[indexPath.section];
        HeaderView.title = homeItem.title;
        if (indexPath.section == self.allModelArray.count - 1) {
            HeaderView.subTitle = @"每天早10晚8点上新";
        }
        return HeaderView;
        
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (indexPath.section == self.allModelArray.count - 1) {
            KFSectionFooterView *FooterView = (KFSectionFooterView *)reuseView;
            FooterView.title = @"已显示全部内容";
            return FooterView;
        }
        else return nil;
    }
    else return nil;
}


- (void)reloadData{
    [self.bannerImageList removeAllObjects];
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark ----- UICollectionViewDelegateFlowLayout(UICollectionViewDelegate的子协议)

//确定每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionCount = self.allModelArray.count;
    //第一个section，广告板
    if (indexPath.section == 0) {
        return CGSizeMake(Screen_Width, 150);
    }
    
    //第二个section,按钮框
    else if(indexPath.section == 1)
    {
        return CGSizeMake(Screen_Width, 80);
    }
    
    //3～5section 各种图片展示
    else if(indexPath.section > 1 && indexPath.section < sectionCount - 3){
        
        KFHomaPagaObject *homeItem = self.allModelArray[indexPath.section];
        KFContentItem *item = homeItem.array[indexPath.row];
        CGFloat width = [item.width floatValue] * Screen_Factor ;
        CGFloat height = [item.height floatValue] * Screen_Factor;
        
        CGSize size = CGSizeMake(width ,height);
        return size;
    }
    //6 section 品牌推荐
    else if (indexPath.section == sectionCount - 3)
    {
        if ([self.allModelArray[sectionCount - 3] isKindOfClass:[NSNull class]]) {
            return CGSizeZero;
        }
        else return CGSizeMake(Screen_Width, 200);
    }
    //7 section 今日火热
    else if (indexPath.section == sectionCount - 2)
    {
        if ([self.allModelArray[sectionCount - 2] isKindOfClass:[NSNull class]]) {
            return CGSizeZero;
        }
        else return CGSizeMake(Screen_Width, 150);
    }
    
    //8 今日热卖
    else{
        if ([self.allModelArray[sectionCount - 1] isKindOfClass:[NSNull class]]) {
            return CGSizeZero;
        }
        else{
            return CGSizeMake(Screen_Width, 200) ;
        }
    }
    
}


//确定header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    id object = self.allModelArray[section];
    if ([object isKindOfClass:[NSNull class]]) {
        return CGSizeZero;
    }
    else{
        KFHomaPagaObject *homeItem = (KFHomaPagaObject *)object;
        if (homeItem.title == nil) {
            return CGSizeZero;
        }
        else{
            if (section < self.allModelArray.count - 1) {
                return CGSizeMake(Screen_Width, 50);
            }
            else return CGSizeMake(Screen_Width, 65);
        }
        
    }
}

//确定foote的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.allModelArray.count - 1) {
        return CGSizeMake(Screen_Width, 30);
    }
    else return CGSizeZero;
}


//确定section内部的item的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //section里每个item之间的行间距
    return section < 3 ?  0 : 10 ;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //设置section之间的间距
    if (_activityList.count > 0) {
        if (section >= 2 && section < self.allModelArray.count - 1) {
            return   UIEdgeInsetsMake(0, 0, 10, 0);
        }    else return UIEdgeInsetsZero;
    }
    else{
        if (section >= 1 && section < self.allModelArray.count - 1) {
            return   UIEdgeInsetsMake(0, 0, 10, 0);
        }else return UIEdgeInsetsZero;
    }
    
}


#pragma mark ----------KFFunctionListViewDelegate (待处理)

- (void)functionListView:(KFFunctionListView *)cell didClickButton:(UIButton *)button
{
    //模拟添加数据到数据库
    [self resolveFMDBData];
    
    //思路：根据button的tag号跳转到不同的控制器去，待实现
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = KFRandomColor;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------------UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //第一次刷新容错处理
    if (self.allModelArray.count == 0) return;
    
    
    CGFloat offsetY = scrollView.contentOffset.y + Screen_Height;
    //    NSLog(@"%f-------%@",offsetY,NSStringFromCGSize(scrollView.contentSize));
    
    if (offsetY >= scrollView.contentSize.height) {
        
        //下拉刷新
        if (scrollIndex < 8) {
            KFHomaPagaObject *object = self.allModelArray[self.allModelArray.count - 1];
            for (KFNowDetailItem *item in _nowDetailList[scrollIndex]) {
                [object.array addObject:item];
            }
            [self.allModelArray replaceObjectAtIndex:self.allModelArray.count - 1 withObject:object];
            
            [self.collectionView reloadData];
            NSLog(@"%ld",scrollIndex);
            scrollIndex ++;
            
        }
    }
}


@end
