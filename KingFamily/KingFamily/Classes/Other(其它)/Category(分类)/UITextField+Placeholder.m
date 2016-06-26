//
//  UITextField+Placeholder.m
//
//  Created by Sycamore on 16/4/29.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)

//当加载进内存的时候就交换方法的实现
+ (void)load
{
    Method setPlaceholderColor = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setBSPlaceholderColor = class_getInstanceMethod(self, @selector(setBS_placeholder:));
    
    //交换两个方法的实现
    method_exchangeImplementations(setPlaceholderColor, setBSPlaceholderColor);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    //关联属性
    objc_setAssociatedObject(self, (const void *)@"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    UILabel *placeHolderColor = [self valueForKey:@"placeholderLabel"];
    placeHolderColor.textColor = placeholderColor;

}


- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self,(const void *) @"placeholderColor");
}


- (void)setBS_placeholder:(NSString *)placeholder
{
    //先完成基本功能，再添加自己想要的功能
    [self setBS_placeholder:placeholder];

    //把颜色存起来，当设置完placeholder的内容后再使用
    if (self.placeholder) {
        self.placeholderColor = self.placeholderColor;

    }
    
}

@end
