//
//  KFAddTagViewController.m
//
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFAddTagViewController.h"
#import "KFTagButton.h"
#import "KFTextField.h"
#import "SVProgressHUD.h"
#import "UITextField+Placeholder.h"

@interface KFAddTagViewController () <UITextFieldDelegate>

@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,weak) KFTextField *textField;
@property (nonatomic,weak) UIButton *tipButton;
@property (nonatomic,strong) NSMutableArray *tagButtons;
@end

@implementation KFAddTagViewController
#pragma mark 懒加载
- (UIButton *)tipButton
{
    if (!_tipButton) {
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //文字等属性设置
        tipButton.backgroundColor = KFTagButtonColor;
        
        tipButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [tipButton addTarget:self action:@selector(tipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        //位置
        tipButton.X = 0;
        tipButton.Y = CGRectGetMaxY(_textField.frame) + KFSmallSmallMargin;
        
        //尺寸
        tipButton.width = _contentView.width;
        tipButton.height = KFTagH;
        
        //让其内部的label从左边
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //让文字向右便宜一点
        tipButton.titleEdgeInsets = UIEdgeInsetsMake(0, KFSmallSmallMargin, 0, 0);
        [_contentView addSubview:tipButton];
        _tipButton = tipButton;
    }
    
    return _tipButton;
}
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavi];
    
    [self setupContentView];
    
    [self setupTextField];
    
    //添加上个页面传过来的button
    [self setupTagsButton];
}

- (void)setupNavi
{
    self.navigationItem.title = @"添加标签";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(succeed)];
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc]init];
    contentView.X = KFSmallSmallMargin;
    contentView.Y = KFSmallSmallMargin;
    contentView.width = Screen_Width - KFSmallSmallMargin * 2;
    contentView.height = Screen_Height;
    [self.view addSubview:contentView];
    _contentView = contentView;
    
}

- (void)setupTextField
{
    KFTextField *textField = [[KFTextField alloc]init];
//    textField.spellCheckingType = UITextSpellCheckingTypeNo;       //拼写检查
//    textField.autocorrectionType = UITextAutocorrectionTypeNo;   //取消自动纠错
    textField.tintColor = KFTagButtonColor;                        //设置光标颜色
    textField.X = 0;
    textField.Y = 0;
    
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    
    //尺寸
    textField.width = _contentView.width;
    textField.height = KFTagH;
    
    //可以利用KVC给textField的占位文字赋值
//    [textField setValue:[UIColor purpleColor] forKeyPath:@"placeholderLabel.textColor"];
    
    //也可以利用运行时，交换系统的实现，给系统的实现添加功能。活着直接给UITextField添加一个属性，重写其setget方法，在其内部通过KVC为其赋值
    textField.placeholderColor = [UIColor grayColor];

    [_contentView addSubview:textField];
    
    _textField = textField;
    
    KFWeakSelf;
    textField.deleteCallBack = ^{
        
        //如果textView里面还有文字的话，textField自己作过滤处理，不调用此block！！！
        //纠错处理，以免没有按钮的情况下删除会报数组越界
        if (self.tagButtons.count == 0) {
            return ;
        }
        [weakSelf tagButtonDidClick:weakSelf.tagButtons.lastObject];
        
    };
    
    //一般监听事件，考虑通知，代理和target,一般首先考虑代理，在代理方法不好使的情况下addtarget
    textField.delegate = self;
    [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//添加从上个页面传过来的tags
- (void)setupTagsButton
{
    for (NSString *tag in self.tags) {
        
        //相当于设置textField的内容之后，再点击tipButton
        _textField.text = tag;
        [self tipButtonClick];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //呼出键盘
    [_textField  becomeFirstResponder];
}

#pragma mark 事件监听
- (void)cancel
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)succeed
{
    //成功，需要将tagsButton里的title包装成数组传给前一个控制器（逆向传递，使用block）
    NSArray *tagTitles = [self.tagButtons valueForKeyPath:@"currentTitle"];
    
    //逆向传递数据
    if (_TagButttonsHandler != nil) {
        
        _TagButttonsHandler(tagTitles);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


//文字改变的时候，就会调用此方法
- (void)textDidChange:(KFTextField *)textField
{
    //如果有文字了，就创建提醒按钮
    if (textField.hasText) {
        
        
        self.tipButton.hidden = NO;

        
        //如果最后一个文字是逗号(如果第一个就是逗号那就不允许了)
        NSString *lastString = [textField.text substringFromIndex:textField.text.length-1];
        if ([lastString isEqualToString:@","] || [lastString isEqualToString:@"，"]) {
            
            //相当于点击了提醒按钮(只有一个逗号是不行的)
            if (textField.text.length > 1) {
                [self tipButtonClick];
            }
            
        }
        
        //计算文本框输入过程中是否需要换行
        NSString *tips = [NSString stringWithFormat:@"添加标签:%@",textField.text];
        [self.tipButton setTitle:tips forState:UIControlStateNormal];
        [self setupTextFieldFrame:textField previousButton:self.tagButtons.lastObject];

        
        
    }
    else{
        
        [textField layoutIfNeeded];
        //如果没有文字
        self.tipButton.hidden = YES;
    }
}

//点击提醒按钮，生成一个button
- (void)tipButtonClick
{
    //严谨
    if (_textField.hasText == NO) {
    
        return;
    }
    
    
    //最多只能允许8个标签
    if (self.tagButtons.count == 8) {
        [SVProgressHUD showErrorWithStatus:@"最多只能添加8个标签"];
        return;
    }
    
    
    KFTagButton *newTagButton = [KFTagButton buttonWithType:UIButtonTypeCustom];
    NSString *title = _textField.text;
    
    //中英文逗号都要监听
    if ([_textField.text containsString:@","] || [_textField.text containsString:@"，"]) {
        title = [_textField.text substringToIndex:_textField.text.length - 1];
    }
    [newTagButton setTitle:title forState:UIControlStateNormal];
    
    //监听按钮的点击
    [newTagButton addTarget:self action:@selector(tagButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取上一个标签按钮
    KFTagButton *lastButton = [self.tagButtons lastObject];
    
    //布局按钮位置
    [self setupTagButtonFram:newTagButton previousButton:lastButton];
    
    [_contentView addSubview:newTagButton];
    [self.tagButtons addObject:newTagButton];
    
    //设置文本框的位置(跟在newButton的后面)
    [self setupTextFieldFrame:_textField previousButton:newTagButton];
    
    //隐藏提示按钮,清空文本框
    _textField.text = nil;
    _tipButton.hidden = YES;

    
}

- (void)tagButtonDidClick:(KFTagButton *)tagButton
{
    NSInteger index = [self.tagButtons indexOfObject:tagButton];
    [self.tagButtons removeObjectAtIndex:index];
    [tagButton removeFromSuperview];
    

    
    //重新排布后面的内容,此时发现，需要抽一些内容，不然代码复用太低，冗余度高
    for (NSInteger i = index; i < self.tagButtons.count ; i++) {
        
        KFTagButton *tagButton = self.tagButtons[i];
        
        //此处注意，不能用index判断
        KFTagButton *previousButton = (i == 0) ? nil : self.tagButtons[i - 1];
        [self setupTagButtonFram:tagButton previousButton:previousButton];
        
        
    }
    
    //排布textField
    KFTagButton *previousButton = (self.tagButtons.count == 0) ? nil  : self.tagButtons[self.tagButtons.count - 1];
    [self setupTextFieldFrame:_textField previousButton:previousButton];
    
    //隐藏提醒按钮
    if (_textField.hasText) {
        _tipButton.hidden = YES;
    }
}


- (void)setupTagButtonFram:(KFTagButton *)newTagButton previousButton:(KFTagButton *)lastTagButton
{
    //如果没有上一个按钮，则说明就是第一个按钮
    if (lastTagButton == nil) {
        newTagButton.X = 0;
        newTagButton.Y = 0;
        
        return ;  //直接返回，就不用计算后面的了
    }
    //有上一个按钮的情况下
        //计算这一行还剩多少的控件
        CGFloat leftWidth = _contentView.width - CGRectGetMaxX(lastTagButton.frame)- KFSmallSmallMargin;
        
        //如果当前按钮的宽度小于上一行剩下的宽度
        if (newTagButton.width < leftWidth) {
            newTagButton.X = CGRectGetMaxX(lastTagButton.frame) + KFSmallSmallMargin;
            newTagButton.Y = lastTagButton.Y;
        }
        else{
            newTagButton.X = 0;
            newTagButton.Y = CGRectGetMaxY(lastTagButton.frame) + KFSmallSmallMargin;
        
    }
}

- (void)setupTextFieldFrame:(KFTextField *)textField previousButton:(KFTagButton *)lastButton
{
    
    CGFloat leftWidth = _contentView.width - CGRectGetMaxX(lastButton.frame) - KFSmallSmallMargin;
    CGFloat textWidth = [textField.text sizeWithAttributes : @{NSFontAttributeName : textField.font}].width;
    //比较二者，获得真实的textField的宽度
    textWidth = MAX(textWidth, 100);
    
    if (leftWidth >= textWidth) {
        _textField.Y = lastButton.Y;
        _textField.X = CGRectGetMaxX(lastButton.frame) + KFSmallSmallMargin;
    }
    else{
        _textField.X = 0;
        _textField.Y = CGRectGetMaxY(lastButton.frame) + KFSmallSmallMargin;
    }
    
    
    //更新tip按钮的位置
    self.tipButton.Y = CGRectGetMaxY(_textField.frame) + KFSmallSmallMargin;
}

#pragma mark UITextFieldDelegate
//是否返回(点击返回按钮的时候会调用此方法)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self tipButtonClick];
    return YES;
}


@end
