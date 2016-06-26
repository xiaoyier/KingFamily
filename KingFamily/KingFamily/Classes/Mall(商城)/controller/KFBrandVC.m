//
//  KFBrandVC.m
//  商品
//
//  Created by XUYAN on 16/4/18.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFBrandVC.h"
#import "KFBrandFoodCell.h"
#import "KFTitleView.h"
#import "UIView+Frame.h"
#import "KFBrandItem.h"
#import "KFBrandImageItem.h"
#import "NSDictionary+jasonStringToJasonDic.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh/MJRefresh.h"
#import "MJDIYHeader.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface KFBrandVC ()
@property (nonatomic, strong) NSMutableArray *brandArr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *titleArr;


@end

@implementation KFBrandVC
static NSString *const ID = @"cell";
-(NSMutableArray *)brandArr{
    if (!_brandArr) {
        _brandArr = [NSMutableArray array];
    }
    return _brandArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"KFBrandFoodCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0,  44, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
    [self setupRefresh];
    
}

//添加下拉刷新----自定义MJRefresh类
-(void)setupRefresh{
    //下拉刷新
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //刷新后隐藏
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark -------------------
#pragma mark 加载数据
-(void)loadData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    NSDictionary *dic = @{
                          @"os" : @"1",
                          @"params":@"{\"appCustomActivitiesId\":\"1007\",\"accountId\":\"884110\"}",
                          @"remark":@"isVestUpdate35",
                          @"sign":@"366A621B6BD479D7",
                          @"version":@"2.5"
                          };
    
    [manger GET:@"http://app.gegejia.com/yangege/appNative/resource/appCustomActivitiesDetail" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jasonStr = responseObject[@"params"];
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:jasonStr];
        
        NSArray *arr = dic[@"activitiesList"];
        NSMutableArray *detailArr = [NSMutableArray array];
        NSDictionary *itemDic0 = [NSDictionary dictionary];
        
        for (NSDictionary *itemDic in arr) {
            detailArr = itemDic[@"detail"];
            itemDic0 = [detailArr firstObject];
            [self.brandArr addObject:itemDic0];
        }
        
        
        
        [KFBrandItem mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"content":[KFBrandImageItem class]};
        }];
        self.titleArr = [KFBrandItem mj_objectArrayWithKeyValuesArray:self.brandArr];
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    //取出每组的item.调用数组属性,看看数组里有多少个
    KFBrandItem *brandItem = self.titleArr[section];
    return brandItem.content.count / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KFBrandFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    KFBrandItem *brandItem = self.titleArr[indexPath.section];
    KFBrandImageItem *imageItem = brandItem.content[indexPath.row * 2];
    cell.imageItem = imageItem;
    
    KFBrandImageItem *imageItem1 = brandItem.content[indexPath.row * 2 + 1];
    cell.imageItem1 = imageItem1;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = KFRandomColor;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark -------------------
#pragma mark 处理头部尾部标题高度
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    KFTitleView *titleView = [[KFTitleView alloc] init];
    KFBrandItem *brandItem = self.titleArr[section];
    titleView.brandItem = brandItem;
    
    return titleView;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}



@end
