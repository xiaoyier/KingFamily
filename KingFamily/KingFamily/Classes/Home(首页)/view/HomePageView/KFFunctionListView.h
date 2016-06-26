//
//  KFButtonListView.h
//  KingFamily
//
//  Created by Sycamore on 16/4/20.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KFFunctionListView;
@protocol KFFunctionListViewDelegate <NSObject>

@optional

- (void) functionListView:(KFFunctionListView *)cell didClickButton:(UIButton *)button;

@end



@interface KFFunctionListView : UICollectionViewCell


@property (nonatomic,weak) id<KFFunctionListViewDelegate>   delegate;

@property (nonatomic,strong) NSArray *functionImageList;


@end
