//
//  KFTabBar.h

//
//  Created by Sycamore on 16/4/27.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyOperation)();
@interface KFTabBar : UITabBar

@property (nonatomic,copy) MyOperation operation;

@end
