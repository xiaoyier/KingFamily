//
//  KFTransitionAnimator.h
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol presentProtocol <NSObject>
@optional
- (UIImageView *)getImageViewWithIndex:(NSIndexPath *)indexPath;

- (CGRect)getStartRectWithIndex:(NSIndexPath *)indexPath;

- (CGRect)getEndRectWithIndex:(NSIndexPath *)indexPath;
@end

@protocol dismissProtocol <NSObject>
@optional

- (UIImageView *)getImageView;

- (NSIndexPath *)getIndexpath;

@end

@interface KFTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id<presentProtocol> presentDelegate;
@property (nonatomic,weak) id<dismissProtocol> dismissDelegate;


@end
