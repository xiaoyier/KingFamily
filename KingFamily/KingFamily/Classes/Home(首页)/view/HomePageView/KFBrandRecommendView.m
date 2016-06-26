//
//  KFBrandRecommendView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFBrandRecommendView.h"
#import "KFContentItem.h"
#import "KFBrandRecommendCell.h"
#import "KFBrandCollectionView.h"
#import <SDWebImageManager.h>

#define ColumCount            4
#define RowCount              3

@interface KFBrandRecommendView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,weak) KFBrandCollectionView *collectionView;
@end

@implementation KFBrandRecommendView

static NSString * const cellReuseIdentifier = @"cell";

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化设置
        [self initialSetup];
    }
    return self;
}

//初始化设置
- (void)initialSetup
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.5f;
    layout.minimumLineSpacing = 0.5f;
    CGFloat itemWidth = self.width / ColumCount - 0.5f;
    CGFloat itemHeight = self.height / RowCount - 0.5f;
    layout.itemSize = CGSizeMake( itemWidth , itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
    
    KFBrandCollectionView *collectionView = [[KFBrandCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    _collectionView = collectionView;
    [self.contentView addSubview:collectionView];
    _collectionView.backgroundColor = KFColor(200, 200, 200);
    
    //注册cell
    [collectionView registerClass:[KFBrandRecommendCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    
    
}


- (void)setContentItems:(NSArray *)contentItems
{
    _contentItems = contentItems;
    if (contentItems.count == 0) {
        self.frame = CGRectZero;
        return;
    }
    
    for (KFContentItem *item in contentItems) {
        [self.images addObject:item.image];
    }
    
    [_collectionView reloadData];
    [_collectionView setNeedsDisplay];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KFBrandRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:_images[indexPath.row]] options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.image = image;
        
    }];

    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end
