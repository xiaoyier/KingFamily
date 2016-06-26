//
//  KFTextField.m
//
//  Created by Sycamore on 16/5/26.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFTextField.h"

@implementation KFTextField


//自定义控件目的:系统的textField的删除功能无法满足我的需求，所以自定义一个，重写这个方法，扩充功能
- (void)deleteBackward
{
    
    //如果没有文字了,那就需要删除按钮了
    if (self.text.length == 0) {
        
        if (self.deleteCallBack != nil) {
            self.deleteCallBack();
        }
        
    }
    
    [super deleteBackward];
}







@end
