//
//  KFCartSectionHeader.h
//  KingFamily
//
//  Created by Sycamore on 16/6/18.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFCartSectionHeader : UIView

@property (nonatomic,copy) void(^gotoPick)();

+ (instancetype)sectionHeader;

@end
