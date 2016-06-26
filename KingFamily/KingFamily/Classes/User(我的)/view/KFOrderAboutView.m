//
//  KFOrderAboutView.m
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFOrderAboutView.h"
#import "KFCollectionCellButtonItem.h"
#import "KFOrderAboutCell.h"

@interface KFOrderAboutView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation KFOrderAboutView


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
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 60) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    _collectionView = collectionView;

    [collectionView registerNib:[UINib nibWithNibName:@"KFOrderAboutCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    return self;
}


- (void)setItems:(NSArray *)items
{
    _items = items;
    
    NSLog(@"%f",self.height);
    _layout.itemSize = CGSizeMake(Screen_Width / items.count, 60);
    
    [_collectionView reloadData];
    
}


#pragma mark  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    KFOrderAboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.item = _items[indexPath.row];
    
    return cell;
}


//选中collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //告知控制器
    if ([self.delegate respondsToSelector:@selector(orderAboutView:didSelectCell:)]) {
        [self.delegate orderAboutView:self didSelectCell:indexPath.row];
    }
}

@end
