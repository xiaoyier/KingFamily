//
//  KFTransitionAnimator.m
//  KingFamily
//
//  Created by Sycamore on 16/6/24.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFTransitionAnimator.h"

@interface KFTransitionAnimator () <UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) BOOL isPresent;

@end

@implementation KFTransitionAnimator


#pragma mark UIViewControllerTransitioningDelegate

//弹出动画由谁处理(需要遵守UIViewControllerAnimatedTransitioning
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresent = YES;
    return self;
}


//返回动画由谁处理(需要遵守UIViewControllerAnimatedTransitioning)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPresent = NO;
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning

//动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}


//执行动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //是否是弹出动画
    if (_isPresent) {
        
        if (_indexPath == nil || _presentDelegate == nil) {
            return;
        }
        
        //获取要弹出的视图
        UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
        
        //校正位置
        presentView.X = 0;
        presentView.Y = 0;
        
        //获得要动画的图片
        UIImageView *imageView = [_presentDelegate getImageViewWithIndex:_indexPath];
        
        //在转场的容器view上添加imageView
        UIView *containerView =  [transitionContext containerView];
        [containerView addSubview:imageView];
        containerView.backgroundColor = [UIColor blackColor];
        
        //获得动画的起始位置
        CGRect startRect = [_presentDelegate getStartRectWithIndex:_indexPath];
        imageView.frame = startRect;
        
        //获得动画的结束位置
        CGRect endRect = [_presentDelegate getEndRectWithIndex:_indexPath];
        
        
        //执行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = endRect;
        } completion:^(BOOL finished) {
            
            //将要弹出的视图加到容器View上
            [containerView addSubview:presentView];
            
            containerView.backgroundColor = [UIColor clearColor];
            
            //将图片移除
            [imageView removeFromSuperview];
            
            //动画完成后，告知
            [transitionContext completeTransition:YES];
        }];
    }
    
    //返回动画
    else{
        
        if (_dismissDelegate == nil || _presentDelegate == nil) {
            return;
        }
        
        //获得要动画的view
        UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        //获得要动画的图片
        UIImageView *imageView = [_dismissDelegate getImageView];
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:imageView];
        
        //获得cell的indexPath
        NSIndexPath *indexPath = [_dismissDelegate getIndexpath];
        
        //获得动画的结束位置
        CGRect endRect = [_presentDelegate getStartRectWithIndex:indexPath];
        
        if (CGRectEqualToRect(endRect, CGRectZero)) {
            [imageView removeFromSuperview];
            dismissView.alpha = 1.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
               
                dismissView.alpha = 0;
                
            } completion:^(BOOL finished) {
               
                [dismissView removeFromSuperview];
                [transitionContext completeTransition:YES];
                
            }];
        }else{
            
            //执行动画
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                [dismissView removeFromSuperview];
                imageView.frame = endRect;
                
            } completion:^(BOOL finished) {
                
                [imageView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
            
        }
        
        
    }
}


@end
