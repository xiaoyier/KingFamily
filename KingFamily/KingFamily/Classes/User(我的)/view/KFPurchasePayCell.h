//
//  KFPurchasePayCell.h
//  KingFamily
//
//  Created by Sycamore on 16/6/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFPurchasePayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong) NSDictionary *payInfo;

@end
