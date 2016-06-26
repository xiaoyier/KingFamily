//
//  KFPhotoBrowserController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFPhotoBrowserController.h"
#import "KFPhotoBrowserLayout.h"
#import "KFPhotoBrowserCell.h"
#import "KFPhotoManager.h"
#import "SVProgressHUD.h"

@interface KFPhotoBrowserController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isSetting;

@end

@implementation KFPhotoBrowserController
static NSString  *const cellID = @"cell";
static NSString * const albumTitle = @"KingFamily";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        KFPhotoBrowserLayout *layout = [[KFPhotoBrowserLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view insertSubview:collectionView atIndex:0];
        _collectionView = collectionView;
        
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    self.view.bounds = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.view.width += 15;
    self.collectionView.frame = self.view.bounds;
    
    
    //注册cell
    [self.collectionView registerClass:[KFPhotoBrowserCell class] forCellWithReuseIdentifier:cellID];
    
    //滚到对应的item
    [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shopItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KFPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.item = self.shopItems[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancel:nil];
}



#pragma mark 事件监听
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    
    KFPhotoBrowserCell *cell = self.collectionView.visibleCells.firstObject ;
    
    UIImage *currentImage = cell.imgView.image;
    
    [KFPhotoManager saveImageToPhotoAlbumWithAlbumTitle:albumTitle image:currentImage completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            //提示保存成功
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
        else{
            //提示保存失败
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
        
    } deniedAuthorizationSatatusHandler:^{
        //提示用户去进行授权
        [SVProgressHUD showErrorWithStatus:@"请前往设置－>KingFamily－>打开允许\"KingFamily访问\"相册"];
    }];

}


#pragma mark dismissProtocol
- (UIImageView *)getImageView
{
    KFPhotoBrowserCell *cell = self.collectionView.visibleCells.firstObject ;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = cell.imgView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = cell.imgView.frame;
    imageView.clipsToBounds = YES;
    
    return imageView;
}


- (NSIndexPath *)getIndexpath
{
    KFPhotoBrowserCell *cell = self.collectionView.visibleCells.firstObject;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    return indexPath;
}


@end
