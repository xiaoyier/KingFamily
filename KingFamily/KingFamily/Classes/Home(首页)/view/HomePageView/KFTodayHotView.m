//
//  KFTodayHotView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFTodayHotView.h"
#import "KFTodayHotCell.h"
#import "KFHotItem.h"


#define CellMargin 5.0f

@interface KFTodayHotView () <UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation KFTodayHotView


static NSString * const todayHotCellReuseIdentifier = @"todayHot";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = CellMargin;
    layout.minimumLineSpacing = CellMargin;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = (self.width - CellMargin * 4 ) / 4;
    CGFloat itemHeight = self.height;
    layout.sectionInset = UIEdgeInsetsMake(0, CellMargin, 0, CellMargin);
    layout.itemSize = CGSizeMake( itemWidth , itemHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    _collectionView = collectionView;
    [self addSubview:collectionView];
    collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册cell
//    [collectionView registerClass:[KFTodayHotCell class] forCellWithReuseIdentifier:todayHotCellReuseIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"KFTodayHotCell" bundle:nil] forCellWithReuseIdentifier:todayHotCellReuseIdentifier];
}

- (void)setHotItems:(NSArray *)hotItems
{
    _hotItems = hotItems;
    
    if (hotItems.count == 0) {
        self.frame = CGRectZero;
        return;
    }
    
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KFTodayHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:todayHotCellReuseIdentifier forIndexPath:indexPath];
    
    KFHotItem *item = self.hotItems[indexPath.row];
    cell.item = item;
    
    return cell;
}
@end
