//
//  KFCategoryVC.m
//  商品
//
//  Created by XUYAN on 16/4/18.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFCategoryVC.h"
#import "KFCategoryClassCell.h"
#import "KFCategoryGoodsCell.h"
#import "KFCategoryItem.h"
#import "KFCategoryGoodItem.h"
#import "KFDetailedCategoryVC.h"

#import "MJExtension.h"
#import "AFNetworking/AFNetworking.h"
#import "MJExtension/MJExtension.h"
#import "MJRefresh/MJRefresh.h"
#import "MJDIYHeader.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define KFColor(r , g, b) [UIColor colorWithRed: (r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

@interface KFCategoryVC ()
@property (nonatomic, strong) NSMutableArray *wineArr;
@property (nonatomic, strong) NSMutableArray *actArr;
@property (nonatomic, strong) NSMutableArray *firstArr;
@end

@implementation KFCategoryVC

-(NSMutableArray *)wineArr{
    if (!_wineArr) {
        _wineArr = [KFCategoryItem mj_objectArrayWithFilename:@"wine.plist"];
    }
    
    return _wineArr;
}



static NSString *const ID = @"cell";
static NSString *const ID2 = @"cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

    self.view.backgroundColor = KFColor(245, 245, 245);
    [self.tableView registerNib:[UINib nibWithNibName:@"KFCategoryClassCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KFCategoryGoodsCell" bundle:nil] forCellReuseIdentifier:ID2];
    self.tableView.contentInset = UIEdgeInsetsMake( 44, 0, 64, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bouncesZoom = 0.5;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupRefresh];
    [self notice];
    
    
}

#pragma mark -------------------
#pragma mark 通知
-(void)notice{

    [[NSNotificationCenter defaultCenter] addObserverForName:@"category" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@",note.userInfo);
        KFDetailedCategoryVC *detailVC = [[KFDetailedCategoryVC alloc] init];
        detailVC.view.backgroundColor = [UIColor blackColor];
        [self.navigationController pushViewController:detailVC animated:YES];
    
        }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push:) name:@"category" object:nil];
    
}
//-(void)push:(NSNotification *)note{
//    NSDictionary *dic = note.userInfo;
//    NSLog(@"%@",dic);
//}

-(void)dealloc{
    NSLog(@"sile");
}
#pragma mark -------------------
#pragma mark 下拉刷新
//添加下拉刷新----自定义MJRefresh类
-(void)setupRefresh{
    //下拉刷新
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //刷新后隐藏
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
}




#pragma mark -------------------
#pragma mark 请求数据
-(void)loadData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    NSDictionary *dic = @{
                          @"os" : @"1",
                          @"params":@"{\"accountId\":\"884110\"}",
                          @"remark":@"isVestUpdate35",
                          @"sign":@"8D72AB11CF75ED8E",
                          @"version":@"2.5"
                          };
    
    [manger GET:@"http://app.gegejia.com/yangege/appNative/mall/home" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jasonStr = responseObject[@"params"];
        NSDictionary *dic = [self dictionaryWithJsonString:jasonStr];
       
        NSMutableArray *firstArr = [KFCategoryItem mj_objectArrayWithKeyValuesArray: dic[@"firstCategoryList"]];
        self.firstArr = firstArr;
        
        NSMutableArray *actArr = [KFCategoryGoodItem mj_objectArrayWithKeyValuesArray:dic[@"activityList"]];
        self.actArr = actArr;
        [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];

}

/**
 *  字符串类型的jason返回字典类型的jason数据
 *
 *  @param jsonString
 *
 *  @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



#pragma mark -------------------
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //注意!!!数据是8个,cell是4个,所以要 / 2 !!!!!!
//        return self.firstArr.count / 2;
        return 4;
    }else  return self.actArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KFCategoryClassCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        KFCategoryItem *categoryItem = self.firstArr[indexPath.row * 2];
        KFCategoryItem *categoryItem1 = self.firstArr[indexPath.row * 2 + 1];

        cell.CategoryItem  = categoryItem;
        cell.categoryItem1 = categoryItem1;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        KFCategoryGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
        cell.goodItem = self.actArr[indexPath.row];
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = KFRandomColor;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    return 60;
    }else return 150;
}


@end
