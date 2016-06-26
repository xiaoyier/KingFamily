//
//  KFSecondSectionView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSecondSectionView.h"
#import "KFCollectionCellButtonItem.h"
#import "KFSecondSecitonCell.h"

#define colums      4

@interface KFSecondSectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,weak) UICollectionView * collectionView;

@end

@implementation KFSecondSectionView



static NSString * const cellID = @"cell";
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.autoresizingMask = UIViewAutoresizingNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.25;
    layout.minimumLineSpacing = 0.5;
    _layout = layout;
    
    
#warning TODO..........
    CGFloat lineWidth = 0.25;
    _layout.itemSize = CGSizeMake(Screen_Width / colums - 0.25, (180 - lineWidth) * 0.5);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 180) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.scrollEnabled = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"KFSecondSecitonCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    return self;
}


- (void)setItems:(NSArray *)items
{
    _items = items;
    
    
    //刷新表格
    [_collectionView reloadData];
    
}


#pragma mark  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    KFSecondSecitonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.item = _items[indexPath.row];
    return cell;
}


//选中collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //告知控制器
    if ([self.delegate respondsToSelector:@selector(secondSectionView:didSelectCell:)]) {
        [self.delegate secondSectionView:self didSelectCell:indexPath.row];
    }
}



@end
