//
//  KFPhotoBrowserController.h
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFTransitionAnimator.h"

@interface KFPhotoBrowserController : UIViewController  <dismissProtocol>

@property (nonatomic,strong) NSArray *shopItems;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
