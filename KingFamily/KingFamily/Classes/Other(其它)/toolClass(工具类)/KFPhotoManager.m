

#import "KFPhotoManager.h"
#import <Photos/Photos.h>

@implementation KFPhotoManager

+ (void)saveImageToPhotoAlbumWithAlbumTitle:(NSString *)title image:(UIImage *)image completionHandler: (void(^)(BOOL success, NSError * error))completionHandler deniedAuthorizationSatatusHandler:(void(^)())deniedHandler
{
    
    //保存图片，在相册里面自己创建一个新的相册
    
    /*
     PHAssetCreationRequest   //创建asset请求
     PHAssetCollectionChangeRequest  //创建，更改，删除assetCollection请求
     PHAsset     //一个asset对象代表相册里的一张图片
     PHAssetCollection  //一个相册对象
     PHPhotoLibrary  //相簿对象
     */
    
    //解决bug,每次都要重新创建一个新的相册
    
    
    //根据授权状态来判断是否可以保存图片
    //如果授权成功
    if ([PHPhotoLibrary authorizationStatus ]== PHAuthorizationStatusAuthorized) {
        
        
        [self saveImageToAlbumsWithTitle:title image:image completionHandler:completionHandler];
        
        //如果还未授权
    }else if ([PHPhotoLibrary authorizationStatus ] == PHAuthorizationStatusNotDetermined){
        
        //先进行授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //如果授权成功
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageToAlbumsWithTitle:title image:image completionHandler:completionHandler];
            }
        }];
        
        //如果拒绝授权
    }else{
        
        //提示用户去进行授权
        deniedHandler();
    }
    
}

//保存图片到相册里面
+ (void)saveImageToAlbumsWithTitle:(NSString *)title image:(UIImage *)image completionHandler: (void(^)(BOOL success, NSError * error))completionHandler
{
    //获取相簿
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    [library performChanges:^{
        
        //获取相册
        PHAssetCollection *assetCollection = [self getCollectionFromAlbumTitle:title];
        
        PHAssetCollectionChangeRequest *collectionChangeRequest;
        
        if (assetCollection) {
            collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        }
        //如果相册没有存在
        else{
            collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        }
        //创建图片请求
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        //添加图片
        [collectionChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
        
        
    } completionHandler:completionHandler];
    
}

+ (PHAssetCollection *)getCollectionFromAlbumTitle:(NSString *)title
{
    //判断是否需要新建相册
    PHFetchResult *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //遍历相册
    for (PHAssetCollection *assetCollection in results) {
        if ([assetCollection.localizedTitle isEqualToString: title]) {
            //说明相册已经存在
            return assetCollection;
        }
    }
    return nil;
}


@end
