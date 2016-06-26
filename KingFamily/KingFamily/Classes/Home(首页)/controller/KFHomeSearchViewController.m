//
//  KFHomeSearchViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFHomeSearchViewController.h"
#import "KFHomeSearchCell.h"
#import "KFSearchSectionHeaderView.h"
#import "KFSearchSectionFooterView.h"

@interface KFHomeSearchViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSArray *headerTitles;
@property (nonatomic,strong) NSArray *cellTitles;

@end

@implementation KFHomeSearchViewController

static NSString * const searchCell = @"searchCell";
static NSString * const searchHeader = @"searchHeader";
static NSString * const searchFooter = @"searchFooter";

- (NSArray *)headerTitles
{
    if (!_headerTitles) {
        _headerTitles = @[@"热门搜索",@"历史搜索"];
    }
    return _headerTitles;
}

- (NSArray *)cellTitles
{
    if (!_cellTitles) {
        _cellTitles = @[@[@"牛排",@"胶原蛋白",@"葡萄籽",@"意大利方便面",@"咸鸭蛋",@"卡乐比",@"红烧大鸡腿",@"哇哈哈",@"八宝粥",@"大鸡蛋"],@[@"美国大米",@"一起来看流星雨"]];
    }
    
    return _cellTitles;
}

- (instancetype)init{
    //设定布局方式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(Screen_Width, 100);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:NSClassFromString(@"KFHomeSearchCell") forCellWithReuseIdentifier:searchCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KFSearchSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:searchHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KFSearchSectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:searchFooter];
    
}


#pragma mark UICollectionView代理

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KFHomeSearchCell *cell = (KFHomeSearchCell *)[collectionView dequeueReusableCellWithReuseIdentifier:searchCell forIndexPath:indexPath];
    NSArray *titles = self.cellTitles[indexPath.section];
    cell.buttonTitles = titles;
    cell.contentView.backgroundColor = KFColor(245, 245, 245);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = searchFooter;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseID = searchHeader;
    }
    
    UICollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        KFSearchSectionHeaderView *headerView = (KFSearchSectionHeaderView *)reuseView;
        headerView.title = self.headerTitles[indexPath.section];
        return headerView;
    }
    else{
        if (indexPath.section == 1) {
            KFSearchSectionFooterView *footerView = (KFSearchSectionFooterView *)reuseView;
            return footerView;
        }

    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return section == 1 ? CGSizeMake(Screen_Width, 50) : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(Screen_Width, 60);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? CGSizeMake(Screen_Width, 150) : CGSizeMake(Screen_Width, 70);
}

- (void)dealloc
{
    self.collectionView = nil;
}


@end
