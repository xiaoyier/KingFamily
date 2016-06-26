//
//  KFDetailedCategoryVC.m
//  商品
//
//  Created by XUYAN on 16/5/29.
//  Copyright © 2016年 KingFamily. All rights reserved.
//

#import "KFDetailedCategoryVC.h"
#import "KFLeftCell.h"
#import "XBWaterflowView.h"
#import "XBWaterflowViewCell.h"

#define leftWidth      85
@interface KFDetailedCategoryVC ()<UICollectionViewDataSource,UICollectionViewDelegate,XBWaterflowViewDataSource,XBWaterflowViewDelegate>
@property (nonatomic, weak) UICollectionView *leftView;
@property (nonatomic, weak) XBWaterflowView *rightView;
@property (nonatomic,strong) NSArray *leftTitles;
@property (nonatomic,weak) UISearchBar *searchBar;

@end


@implementation KFDetailedCategoryVC

static NSString *const IDL = @"leftCell";
static NSString *const IDR = @"rightCell";


#pragma mark : -懒加载
- (NSArray *)leftTitles
{
    if (!_leftTitles) {
        _leftTitles = @[
                        @{@"title" : @"休闲零食" , @"selectedColor" : [UIColor orangeColor]},
                        @{@"title" : @"保健滋补" , @"selectedColor" : [UIColor cyanColor]},
                        @{@"title" : @"母婴健康" , @"selectedColor" : [UIColor blueColor]},
                        @{@"title" : @"水果生鲜" , @"selectedColor" : [UIColor redColor]},
                        @{@"title" : @"茶饮酒水" , @"selectedColor" : [UIColor brownColor]},
                        @{@"title" : @"粮油干货" , @"selectedColor" : [UIColor purpleColor]},
                        @{@"title" : @"手工美食" , @"selectedColor" : [UIColor greenColor]},
                        @{@"title" : @"调味素食" , @"selectedColor" : [UIColor magentaColor]}
                        ];

    }
    
    return _leftTitles;
}


-(void)viewDidLoad{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    searchBar.placeholder = @"搜索喜欢的宝贝";
    _searchBar = searchBar;
    
    self.navigationItem.titleView = searchBar;
    
    [self setupTableView];
    
}


#pragma mark -------------------
#pragma mark 创建tableview
-(void)setupTableView{
    
    CGFloat leftW = leftWidth;
    UICollectionViewFlowLayout *layoutLeft = [[UICollectionViewFlowLayout alloc] init];
    layoutLeft.itemSize = CGSizeMake(leftW, leftW);
    layoutLeft.minimumInteritemSpacing = 0;
    layoutLeft.minimumLineSpacing = 0;
    
    UICollectionView *leftView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layoutLeft];
    [leftView registerNib:[UINib nibWithNibName:@"KFLeftCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:IDL];
    leftView.showsVerticalScrollIndicator = NO;
    leftView.frame = CGRectMake(0, 0, leftW, Screen_Height);
    leftView.dataSource = self;
    leftView.delegate = self;
    leftView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 85, 0);
    leftView.backgroundColor = KFColor(245,234,245);
    self.leftView = leftView;
    [self.view addSubview:leftView];
    
    
    //默认选中第一行（延迟0.1秒执行）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:leftView didSelectItemAtIndexPath:indexPath];
        [leftView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    });
    
    
    
    //实现瀑布流
    XBWaterflowView *waterflowView = [[XBWaterflowView alloc] init];
    waterflowView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 85, 0);
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    waterflowView.frame = CGRectMake(leftW, 0, Screen_Width - leftWidth, Screen_Height);
    [self.view addSubview:waterflowView];
    _rightView = waterflowView;

    
    
//    NSInteger rightColums = 3;
//    NSInteger rightMargin = 15;
//    CGFloat rightItemW = (Screen_Width - leftWidth - rightMargin  * (rightColums + 1))/rightColums;
//    UICollectionViewFlowLayout *layoutRight = [[UICollectionViewFlowLayout alloc] init];
//    layoutRight.itemSize = CGSizeMake( rightItemW, 50);
//    layoutRight.minimumInteritemSpacing = rightMargin;
//    layoutRight.minimumLineSpacing = rightMargin;
//    layoutRight.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
//    
//    UICollectionView *rightView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layoutRight];
//    [rightView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:IDR];
//    rightView.frame = CGRectMake(leftW, 0, Screen_Width - leftWidth, Screen_Height);
//    rightView.dataSource = self;
//    rightView.delegate = self;
//    rightView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 85, 0);
//    self.rightView = rightView;
//    [self.view addSubview:rightView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.leftTitles.count ;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        KFLeftCell *leftCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDL forIndexPath:indexPath];
        leftCell.info = self.leftTitles[indexPath.row];
        return leftCell;
}


#pragma mark  UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //刷新右边的数据
    [_rightView reloadData];
    
    //滑到最顶部
    [_rightView setContentOffset:CGPointZero animated:NO];
}


#pragma mark - XBWaterflowViewDataSource
// 总共的列数(默认是两列)
- (CGFloat)numberOfColumsOnWaterflowView:(XBWaterflowView *)waterflowView {
    return 3;
}

// cell的个数
- (CGFloat)numberOfCellsOnWaterflowView:(XBWaterflowView *)waterflowView {
    return 100;
}

// 每个index位置的cell
- (XBWaterflowViewCell *)waterflowView:(XBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index {
    static NSString *reuseIdentifier = @"cell";
    XBWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[XBWaterflowViewCell alloc] initWithReusableIdentifier:reuseIdentifier];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 20, 30, 30);
        label.tag = 10;
        [cell addSubview:label];
    }
    UILabel *lb = (UILabel *)[cell viewWithTag:10];
    lb.text = [NSString stringWithFormat:@"%ld", index];
    cell.backgroundColor = KFRandomColor;
    
    return cell;
}

#pragma mark - XBWaterflowViewDelegate
// 每个index位置的高度
- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index {
    // 随机高度
    return arc4random_uniform(70) + 50;
}


// 点击cell
- (void)waterflowView:(XBWaterflowView *)waterflowView didSelectedCellAtIndex:(NSUInteger)index {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"抱歉，该功能未完善" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    
    [alert show];
}





@end
