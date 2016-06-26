//
//  KFPostTextView.m
//
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//


/*总结：自定义一个控件，可以在创建的时候给一个默认设置，然后可以重写父类的一些属性，添加一些额外的功能，比如设置颜色，文字，frame等，
       比如重写textView，扩充功能时，要考虑周全。添加placeholder时，要考虑文字的改变，设置的多样化，尽量在自己内部处理
 */


#import "KFPostTextView.h"

@implementation KFPostTextView

//明确自定义textView的目的：textField不能换行，尺寸是固定的，textView能换行，但是没有placeholder这个属性
//综合考虑：相对来说，给textView添加个placeholder更加容易，在textView里面绘制文字就可以了



//一个控件手动创建，或者从xib里创建的时候，都可以先进行一些默认的设置
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.placeholder = @"请输入占位文字";
    self.placeholderColor = [UIColor purpleColor];
    self.alwaysBounceVertical = YES;  //默认为NO,内容小于bounds的时候，不能滚动
    self.font = [UIFont systemFontOfSize:15];   //默认文字尺寸
    
    //textView里面的文字发生改变了，就会发出通知，监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//注意，每次调用drawRect方法，都会将之前绘制的内容清除掉
- (void)drawRect:(CGRect)rect
{
    //如果textView输入了内容，就不绘制placeholder
    if (self.hasText) {
        return;
    }
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = self.font;
    attri[NSForegroundColorAttributeName] = self.placeholderColor;
    

    //设置绘制文字的范围
    CGFloat smallMargin = 5;
    rect.origin.x = smallMargin;
    rect.origin.y = 8;
    rect.size.width = Screen_Width - smallMargin * 2;
    [self.placeholder drawInRect:rect withAttributes:attri];
}


//每次文字改变的时候都会发出通知，然后进行重绘，重会的时候判断textView里面是否有文字，有的话就显示文字，没有就绘制placeholder
- (void)textDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
}


//外界设置font
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    //重绘
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

//设置文字后，就需要重新绘制了
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
@end
