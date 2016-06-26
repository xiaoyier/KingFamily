//
//  KFPostWordViewController.m
//
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFPostWordViewController.h"
#import "KFPostTextView.h"
#import "KFToolBar.h"

@interface KFPostWordViewController () <UITextViewDelegate>

@property (nonatomic,weak) KFPostTextView *textView;
@property (nonatomic,weak) UIButton *rightButton;
@property (nonatomic,weak) UIView *toolBar;

@end

@implementation KFPostWordViewController

#pragma mark -初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavi];
    
    [self setupTextView];
    
    [self setupToolBar];
    
    
}

//设置导航条内容
- (void)setupNavi
{
    self.navigationItem.title = @"选你喜欢";
    
    UIView *leftView = [[UIView alloc]init];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftButton];
    [leftButton sizeToFit];     //不能确定其位置，但是一定要自适应尺寸
    leftView.bounds = leftButton.bounds;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView]; //设置为button的话，点击范围会非常大，可以包装一个View,但是button和View的尺寸都是需要确定的
    
    UIView *rightView = [[UIView alloc]init];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [rightButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    [rightView addSubview:rightButton];
    rightView.bounds = rightButton.bounds;
    _rightButton = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    //注意，一定要设置好状态
    rightButton.enabled = NO;
    
    
}

//设置textView
- (void)setupTextView{
    
    KFPostTextView *testView = [[KFPostTextView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:testView];
    _textView = testView;
    _textView.placeholder = @"把好玩的事情，搞笑的图片，或是精彩的视频发送到这里吧，我们将展示给万千网友！同时，您也可以选择您感兴趣的标签，我们将向您推送您感兴趣的内容......";
    testView.placeholderColor = [UIColor lightGrayColor];
    //设置代理
    testView.font = [UIFont systemFontOfSize:15];
    testView.delegate = self;

}

//设置工具条
- (void)setupToolBar
{
    KFToolBar *toolBar = [KFToolBar viewFromNib];
    
    //设置位置和尺寸(默认在底部，等键盘出来了跟随键盘弹上来)
    toolBar.frame = CGRectMake(0, Screen_Height - toolBar.height  , Screen_Width, toolBar.height);
    [self.view addSubview:toolBar];
    _toolBar = toolBar;
    
    //监听键盘改变的通知，跟随键盘移动而移动
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //一进来就弹出键盘
    [_textView becomeFirstResponder];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UITextViewDelegate,UIScrollViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //判断右上角完成按钮是否能够点击
    _rightButton.enabled = textView.hasText;  //注意，将UIbutton包装成barbuttonItem后，设置item的状态必须通过button设置，不然没有效果！
}

//即将拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];    //注意，resignFirsyResponder还会有光标，endEditing没有光标
}


#pragma mark 事件监听
//让toolBar的尺寸跟随键盘改变而改变
- (void)keyboardWillChange:(NSNotification *)noti{
    
    //获得动画时间
    NSDictionary *userInfo = noti.userInfo;
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
    //y坐标改变的值 (xib里面用约束的话，最好不要用frame了，不过xib整个View可以，因为约束只是相对父控件的)
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = ( Screen_Height - endFrame.origin.y );
    
    [UIView animateWithDuration:duration animations:^{
        
        //键盘弹出时，工具条往上滑，当键盘往下弹的时候，工具条回到底部（回到原位）
        _toolBar.transform = CGAffineTransformMakeTranslation(0, -ty);
    }];
    
    
}


- (void)cancel
{
    //退出键盘
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post{
    NSLog(@"你真的想发送吗，可是发送不了哇");
}


@end
