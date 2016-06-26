

#import <Foundation/Foundation.h>
@class PHAssetCollection;
@interface KFPhotoManager : NSObject
/**
 *  根据授权状态去保存图片到自定义的相册中（对授权状态做了判断处理）
 *
 *  @param title             指定相册的名字
 *  @param image             需要保存的图片
 *  @param completionHandler 保存完成后的回调（处理保存失败还是成功后的回调）
 *  @param deniedHandler     对于用户拒绝授权时，可以在此block中提醒用户授权
 */
+ (void)saveImageToPhotoAlbumWithAlbumTitle:(NSString *)title image:(UIImage *)image completionHandler: (void(^)(BOOL success, NSError * error))completionHandler deniedAuthorizationSatatusHandler:(void(^)())deniedHandler;


/**
 *  保存图片到指定相册（未判断授权状态）
 *
 *  @param title             相册名字
 *  @param image             需要保存的图片
 *  @param completionHandler 保存完成后的回调（处理保存失败还是成功后的回调）
 */
+ (void)saveImageToAlbumsWithTitle:(NSString *)title image:(UIImage *)image completionHandler: (void(^)(BOOL success, NSError * error))completionHandler;


/**
 *  获取指定名字的相册
 *
 *  @param title 相册名字
 *
 *  @return 返回搜索到的指定名字的相册对象
 */
+ (PHAssetCollection *)getCollectionFromAlbumTitle:(NSString *)title;


@end
