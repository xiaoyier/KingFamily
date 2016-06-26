//
//  KFPhotoHomeViewController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoHomeViewController.h"
#import "KFShopItem.h"
#import "KFPhotoHomeCell.h"
#import "KFPhotoHomeViewLayout.h"
#import "KFTransitionAnimator.h"
#import "KFHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "KFPhotoBrowserController.h"
#import "UIImage+Resize.h"

@interface KFPhotoHomeViewController () <presentProtocol>

@property (nonatomic,copy) NSMutableArray *shopItems;
@property (nonatomic,strong) KFTransitionAnimator *animator;
@end

@implementation KFPhotoHomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)shopItems
{
    if (!_shopItems) {
        _shopItems = [NSMutableArray array];
    }
    return _shopItems;
}

//重写init方法
- (instancetype)init
{
    KFPhotoHomeViewLayout *layout = [[KFPhotoHomeViewLayout alloc]init];
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"美图看看";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"KFphotoHomeCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置动画协议类（控制器减负）
    KFTransitionAnimator *animator = [[KFTransitionAnimator alloc]init];
    _animator = animator;
    
    //加载数据
    [self loadDataWithOffset:0];
}


- (void)loadDataWithOffset:(NSInteger)offset
{
    [[KFHttpTool sharedKFHttpTool]loadDataWithOffset:offset completionBlock:^(NSArray *result, NSError *error) {
        if (error != nil) {
            NSLog(@"获取数据发生错误");
            return ;
        }
        
        //字典数组转模型数组
        NSArray *resultArr = [KFShopItem mj_objectArrayWithKeyValuesArray:result];
        [self.shopItems addObjectsFromArray:resultArr];
        
        //刷新视图
        [self.collectionView reloadData];
        
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.shopItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KFPhotoHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = self.shopItems[indexPath.row];
    
    
    //如果是最后一个cell,那就加载更多
    if (indexPath.row == self.shopItems.count - 1) {
        [self loadDataWithOffset:self.shopItems.count];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//选中某一行
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到图片浏览控制器
    KFPhotoBrowserController *browser = [[KFPhotoBrowserController alloc]init];
    browser.shopItems = self.shopItems;
    browser.indexPath = indexPath;
    
    //创建一个动画协议类（定义一个类，用来动画的代理，面向协议开发，把控制器的事情交给代理类去做）
    //谨记，一定要强指针指向改协议对象，不然方法过后就销毁了
    _animator.indexPath = indexPath;
    _animator.presentDelegate = self;
    _animator.dismissDelegate = browser;
    
    browser.modalPresentationStyle = UIModalPresentationCustom;
    browser.transitioningDelegate = _animator;
    
    
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark 事件监听
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark presentProtocol
- (UIImageView *)getImageViewWithIndex:(NSIndexPath *)indexPath
{
    //获得选取的cell
    KFPhotoHomeCell *cell = (KFPhotoHomeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = cell.imgView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}


- (CGRect)getStartRectWithIndex:(NSIndexPath *)indexPath
{
    KFPhotoHomeCell *cell = (KFPhotoHomeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) {
        return CGRectZero;
    }
    
    CGRect frame = [self.collectionView convertRect:cell.frame toCoordinateSpace:[UIApplication sharedApplication].keyWindow];
    
    return frame;
}

- (CGRect)getEndRectWithIndex:(NSIndexPath *)indexPath
{
    KFPhotoHomeCell *cell = (KFPhotoHomeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = cell.imgView.image;
    
    return [UIImage calculateImageFrame:image];
}


@end
