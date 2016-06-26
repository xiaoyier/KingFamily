//
//  KFAddTagViewController.h
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFAddTagViewController : UIViewController


//定义一个block，用于逆向传递数据
@property (nonatomic,copy) void (^TagButttonsHandler)(NSArray *);


//接受上个页面传过来的
@property (nonatomic,strong) NSArray *tags;
@end
