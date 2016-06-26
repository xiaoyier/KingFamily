//
//  KFSelectLocationViewController.h
//  KingFamily
//
//  Created by Sycamore on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFSelectLocationViewController : UITableViewController

@property (nonatomic,copy) void(^selectCityBlock)(NSString * title);
@property (nonatomic,copy) NSString *currentCity;
@end
