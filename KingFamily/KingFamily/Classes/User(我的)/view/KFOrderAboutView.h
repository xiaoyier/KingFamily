//
//  KFOrderAboutView.h
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KFOrderAboutView;
@protocol KFOrderAboutViewDelegate <NSObject>

@optional
- (void)orderAboutView:(KFOrderAboutView *)order didSelectCell:(NSInteger)index;

@end

@interface KFOrderAboutView : UITableViewCell


@property (nonatomic,strong) NSArray *items;

@property (nonatomic,weak)id<KFOrderAboutViewDelegate>delegate;

@end
