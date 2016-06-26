//
//  KFFirstSectionHeader.h
//  KingFamily
//
//  Created by Sycamore on 16/6/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFFirstSectionHeader : UIView

+ (instancetype)header;

@property (nonatomic,copy) void(^touchHandeler)();

@end
