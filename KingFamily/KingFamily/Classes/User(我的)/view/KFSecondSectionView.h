//
//  KFSecondSectionView.h
//  KingFamily
//
//  Created by Sycamore on 16/6/22.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KFSecondSectionView;
@protocol KFSecondSectionDelegate <NSObject>

@optional
- (void)secondSectionView:(KFSecondSectionView *)second didSelectCell:(NSInteger)index;

@end


@interface KFSecondSectionView : UITableViewCell


@property (nonatomic,strong) NSArray *items;

@property (nonatomic,weak) id<KFSecondSectionDelegate>delegate;


@end
