//
//  KFToolBar.m
//
//  Created by Sycamore on 16/5/25.
//  Copyright © 2016年 Sycamore. All rights reserved.
//

#import "KFToolBar.h"
#import "KFAddTagViewController.h"
#import "KFNavigationController.h"

@interface KFToolBar ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,weak) UIButton *addButton;

@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,strong) NSMutableArray *taglabels;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomHeightCOnstrint;
@end

@implementation KFToolBar

- (NSMutableArray *)taglabels
{
    if (!_taglabels) {
        _taglabels = [NSMutableArray array];
    }
    return _taglabels;
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    //初始化设置
    [self initialSetup];
    
    return self;
}

- (void)awakeFromNib
{
    //初始化设置
    [self initialSetup];
}


- (void)initialSetup
{
    [self setupAddButton];
    
    //默认创建两个
    _tags = @[@"美食",@"旅行"];
    [self setupTagLabels];
}



- (void)setupAddButton
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"tag_add_iconN"] forState:UIControlStateHighlighted];
    [addButton sizeToFit];
    addButton.height = KFTagH;

    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _addButton = addButton;
    [_topView addSubview:addButton];
    
}

//创建label
- (void)setupTagLabels
{
    
    //每次创建新的labels的时候，需要把之前创建的给清除掉，不然一直累加
    [self.taglabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.taglabels removeAllObjects];   //记住一定要移除，不然虽然从父控件上移除了，但还是站着数组里的位置
    
    for (int i = 0; i < _tags.count; i ++) {
        UILabel *tagLabel = [[UILabel alloc]init];
        tagLabel.backgroundColor = KFTagButtonColor;
        tagLabel.text = _tags[i];
        tagLabel.font = [UIFont systemFontOfSize:15];
        tagLabel.layer.cornerRadius = 5;
        tagLabel.layer.masksToBounds = YES;
        [_topView addSubview:tagLabel];
        [self.taglabels addObject:tagLabel];
        
        //尺寸
        [tagLabel sizeToFit];
        tagLabel.height = KFTagH;
        tagLabel.width += KFSmallSmallMargin * 2;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    //加号按钮的位置发生了改变，需要重新布局
    [self setNeedsLayout];
}


+ (instancetype)viewFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"KFToolBar" owner:nil options:nil]lastObject];
}


//布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //label的位置
    for (int i = 0; i < self.taglabels.count; i++) {
        
        UILabel *currentLabel = _taglabels[i];
        if (i == 0) {
            currentLabel.X = KFSmallSmallMargin;
            currentLabel.Y = KFSmallSmallMargin;
        }
        else{
            UILabel *previousLabel = _taglabels[i - 1];
            CGFloat leftWidth = _topView.width - CGRectGetMaxX(previousLabel.frame) - KFSmallSmallMargin;
            if (currentLabel.width > leftWidth) {
                currentLabel.X = KFSmallSmallMargin;
                currentLabel.Y = CGRectGetMaxY(previousLabel.frame) + KFSmallSmallMargin;
            }
            else{
                currentLabel.X = CGRectGetMaxX(previousLabel.frame) + KFSmallSmallMargin;
                currentLabel.Y = previousLabel.Y;
            }
        }

    }
    
    //加号按钮的位置
    if (self.taglabels.count == 0) {
        _addButton.X  = KFSmallSmallMargin;
        _addButton.Y = KFSmallSmallMargin;
        
    }else{
        UILabel *lastLabel = self.taglabels[self.taglabels.count - 1];
        CGFloat leftWidth = _topView.width - CGRectGetMaxX(lastLabel.frame) - KFSmallSmallMargin;
        if (_addButton.width > leftWidth) {
            _addButton.X = KFSmallSmallMargin;
            _addButton.Y = CGRectGetMaxY(lastLabel.frame) + KFSmallSmallMargin;
        }
        else{
            _addButton.X = CGRectGetMaxX(lastLabel.frame) + KFSmallSmallMargin;
            _addButton.Y = lastLabel.Y;
        }
    }
    
    //计算位置
    self.height = CGRectGetMaxY(_addButton.frame) + KFSmallSmallMargin + self.BottomHeightCOnstrint.constant;
    
    //往下偏移
    self.Y += _topView.height - CGRectGetMaxY(_addButton.frame) - KFSmallSmallMargin;
}



#pragma mark 事件监听
- (void)addButtonClick
{
    KFAddTagViewController *addTagVc = [[KFAddTagViewController alloc]init];
    KFWeakSelf;
    addTagVc.TagButttonsHandler = ^(NSArray *tagTitles){
        
        //创建label
        _tags = tagTitles;
        [weakSelf setupTagLabels];
        
    };
    
    //传递数据过去
    addTagVc.tags = _tags;
    KFNavigationController *navi = [[KFNavigationController alloc]initWithRootViewController:addTagVc];
    
    //只有正在窗口上面显示的控制器才能modal出新的控制器
    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:navi animated:YES completion:nil];
}


@end
