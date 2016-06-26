//
//  KFCartBottomView.h
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KFCartBottomView;
@protocol KFCartBottomViewDelegate <NSObject>

@optional
- (void)cartBottomView:(KFCartBottomView *)bottomView didClickAccountButton:(UIButton *)accountButton;

- (void)cartBottomView:(KFCartBottomView *)bottomView didClickAllSelectButton:(UIButton *)allSelectButton;

@end

@interface KFCartBottomView : UIView

+ (instancetype)cartBottomView;

@property (nonatomic,weak) id<KFCartBottomViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *gotoAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (nonatomic,assign) CGFloat totleCount;

@end
