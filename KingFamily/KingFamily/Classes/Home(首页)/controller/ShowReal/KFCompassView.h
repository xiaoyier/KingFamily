//
//  KFCompassView.h
//  KingFamily
//
//  Created by Sycamore on 16/6/17.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFCompassView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *direcitionView;


+ (instancetype)compassView;

@end
