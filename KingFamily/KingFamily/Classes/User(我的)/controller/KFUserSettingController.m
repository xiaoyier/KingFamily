//
//  KFUserSettingController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFUserSettingController.h"
#import "FileSize.h"
#import "SVProgressHUD.h"

@interface KFUserSettingController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation KFUserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self cacheLabelReloadData];
}

- (void)cacheLabelReloadData
{
    //获取当前缓存大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSInteger totleSize = [FileSize getFileSizeWithPath:cachePath];
    
    NSString *string = @"0.0MB";
    
    if (totleSize >= 1000 * 1000) {
        string = [NSString stringWithFormat:@"%.1fMB",totleSize / 1000.0 / 1000.0];
    }
    else if (totleSize >= 1000){
        string = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0];
    }else{
        string = [NSString stringWithFormat:@"%.1ldB",totleSize];
    }
    
    
    _cacheLabel.text = string;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //  清除缓存
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        [FileSize removeFilesAtPath:cachePath];
        
        //刷新数据显示
        [self cacheLabelReloadData];
        
        //显示清楚成功
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        
    }
    else  {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"当前版本为已是最新版本，无需更新"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
        });
    }
}

@end
