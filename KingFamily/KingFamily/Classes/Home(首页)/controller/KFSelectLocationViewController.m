//
//  KFSelectLocationViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSelectLocationViewController.h"
#import "KFHomeLocationHeaderView.h"
#import "KFHomeLocationSectionHeader.h"
#import "KFCurrentCityCell.h"
#import "KFHotCityCell.h"
#import "KFLocationViewController.h"

@interface KFSelectLocationViewController ()
@property (nonatomic,strong) NSArray *cityGroups;



@end

@implementation KFSelectLocationViewController

static NSString  * const  cellID = @"cell";
static NSString  * const  currentCityCellID = @"currentCity";
static NSString  * const  hotCityCellID = @"hotCity";
static NSString  * const  sectionHeaderID = @"sectionHeaderID";

#pragma mark 懒加载
- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ProvinceList.plist" ofType:nil];
        _cityGroups = [NSArray arrayWithContentsOfFile:filePath];
    }
    
    return _cityGroups;
}

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark 初始化设置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条相关
    [self setupNavigation];
    
    //设置tableView相关
    [self setupTableView];
    
}

- (void)setupNavigation
{
    self.navigationItem.title = @"选择地区";
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSFontAttributeName] = kFont22;
    textAttr[NSForegroundColorAttributeName] = Navi_TitleColor;
    [self.navigationController.navigationBar setTitleTextAttributes:textAttr];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"locationIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(getLocation)];
}

- (void)setupTableView
{
    self.tableView.backgroundColor = KFColor(235, 235, 235);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    
    KFHomeLocationHeaderView *header = [KFHomeLocationHeaderView headerView];
    self.tableView.tableHeaderView = header;
    header.width = Screen_Width;
    header.height = 40;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KFCurrentCityCell" bundle:nil] forCellReuseIdentifier:currentCityCellID];
    [self.tableView registerClass:[KFHotCityCell class] forCellReuseIdentifier:hotCityCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KFHomeLocationSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:sectionHeaderID];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if (subView.tag == 101 ) {
            [subView removeFromSuperview];
        }
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cityGroups.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section > 1 ? [self.cityGroups[section - 2] count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:currentCityCellID];
        KFCurrentCityCell *currentCityCell = (KFCurrentCityCell *)cell;
        currentCityCell.title = @"广东";
        return currentCityCell;
    
    }else if (indexPath.section == 1){
        KFHotCityCell *hotCityCell = (KFHotCityCell *)[tableView dequeueReusableCellWithIdentifier:hotCityCellID];
        hotCityCell.hotCities = @[@"深圳",@"杭州",@"上海",@"乌鲁木齐"];
        hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return hotCityCell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.textLabel.text = self.cityGroups[indexPath.section - 2][indexPath.row][@"name"];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KFHomeLocationSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderID];
    NSString *title = @"";
    if (section == 0) {
        title = @"当前定位地区";
    }else if (section == 1){
        title = @"热门城市";
    }else{
        title = self.cityGroups[section - 2][0][@"letter"];
        title = [title substringToIndex:1];
    }
    sectionHeader.title = title;
    
    UIView *backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor = KFColor(220, 220, 220);
    sectionHeader.backgroundView = backGroundView;
    
    return sectionHeader;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSInteger count = self.cityGroups.count;
    NSMutableArray * indexTitles  = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        NSString *title = self.cityGroups[i][0][@"letter"];
        title = [title substringToIndex:1];
        [indexTitles addObject:title];
    }
    
    [indexTitles insertObject:@"$" atIndex:0];
    [indexTitles insertObject:@"#" atIndex:0];
    return indexTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? 20 : 0.001;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
#warning 选中前两个section需要处理，当前城市直接传定位得到的城市（保存为属性）,热门城市传第一个城市（简单起见）
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section > 1) {
        
        if (_selectCityBlock != nil) {
            _selectCityBlock(cell.textLabel.text);
        }
        if (cell.textLabel.text != _currentCity) {
            [[NSNotificationCenter defaultCenter]postNotificationName:RefreshTableView object:nil];
        }

        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 事件监听
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getLocation{
    
    KFLocationViewController *locationVC = [[KFLocationViewController alloc]init];
    
    [self.navigationController pushViewController:locationVC animated:YES];
    
}


@end
