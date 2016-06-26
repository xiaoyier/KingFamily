//
//  KFSearchNavigationController.m
//  KingFamily
//
//  Created by Sycamore on 16/6/15.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFSearchNavigationController.h"
#import "KFSearchNaviBar.h"

@interface KFSearchNavigationController ()

@end

@implementation KFSearchNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KFSearchNaviBar *searchNaviBar = [[KFSearchNaviBar alloc]init];
    searchNaviBar.frame = CGRectMake(0, -20, Screen_Width, 64);
    
    [self.navigationBar addSubview:searchNaviBar];
//    self.navigationBarHidden = YES;
    
    
    searchNaviBar.cancelBlock = ^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    };
}



@end
