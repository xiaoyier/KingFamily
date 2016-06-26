//
//  KFTextField.h
//
//  Created by Sycamore on 16/5/26.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFTextField : UITextField

@property (nonatomic,copy) void(^deleteCallBack)();

@end
