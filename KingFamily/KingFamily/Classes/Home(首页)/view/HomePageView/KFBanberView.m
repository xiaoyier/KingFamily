//
//  KFBanberView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/20.
//  Copyright © 2016年 King. All rights reserved.
//

//这个宏加上后，可以去掉'mas_'这个前缀了
//#define MAS_SHORTHAND
//这个宏加上后，可以去掉自动包装方法的'mas_'前缀
//#define MAS_SHORTHAND_GLOBALS
//注意，这两个宏必须定义在这个头文件的上面，因为"Masonry.h"中要用到上面2个宏，如果已经定义过了的话

#import "KFBanberView.h"
#import <Masonry.h>
#import "KFBannerItem.h"
#import <UIImageView+WebCache.h>

@interface KFBanberView () <UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;

@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation KFBanberView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化设置
        [self initialSetUp];
    }
    return self;
}

- (void)awakeFromNib
{
    //初始化设置
    [self initialSetUp];

}


- (void)initialSetUp
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.contentView addSubview:scrollView];
    _scrollView = scrollView;
    _scrollView.backgroundColor = KFColor(240, 240, 240);
    scrollView.delegate = self;
    //设置占位图片
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages =  _bannerImageList.count;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPageIndicatorTintColor = Bar_TintColor;
    pageControl.pageIndicatorTintColor = KFColor(240, 240, 240);
    [self.contentView addSubview:pageControl];
    _pageControl = pageControl;
}


- (void)setBannerImageList:(NSArray *)bannerImageList
{
    _bannerImageList = bannerImageList;
    //取出数组里面的每个item,获得里面的图片
    
    [self setupImagesWithImageList:bannerImageList];

    NSLog(@"%ld",bannerImageList.count);
}

//设置图片
- (void)setupImagesWithImageList:(NSArray *)imageList
{
    
    //如果scrollView里面已经有图片了，就直接返回
    if (_scrollView.subviews.count > 2) {
        return;
    }
    
    //记住，pageControl的这个属性一定要在这里设置一下
    _pageControl.numberOfPages = imageList.count;
    //设置图片
    for (NSInteger index = 0; index < imageList.count; index++) {
        UIImageView *banberImageView = [[UIImageView alloc]init];
        [_scrollView addSubview:banberImageView];
        banberImageView.backgroundColor = KFRandomColor;
        banberImageView.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, self.contentView.height);
        //同时做内存缓存和磁盘缓存
        banberImageView.image = [UIImage imageNamed:@"home_default_goods"];
        [banberImageView sd_setImageWithURL:[NSURL URLWithString:imageList[index]] placeholderImage:[UIImage imageNamed:@"home_default_goods"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //将获得的image保存进数组里面
            
            //等所有的图片下完之后再开启定时器进行图片的轮播
            if (index > 1 && index == imageList.count - 1) {
                [self startTimer];
            }
            
        }];
        
    }
    
    _scrollView.contentSize = CGSizeMake(imageList.count * Screen_Width,   self.contentView.height);

    
    
    
}

- (void)startTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(imageAnimate) userInfo:nil repeats:YES];
    
    //记住，要采用这种模式，才能保证在scrollView拖动的时候也能生效
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
}

//在这个方法里面进行图片的轮播
- (void)imageAnimate
{
    NSInteger page = _pageControl.currentPage;
    page ++;
    if (page == _bannerImageList.count - 1) {
        page = 0;
    }
    [_scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * page, 0) animated:YES];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //添加约束
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _pageControl.width = 100.0f;
    _pageControl.height = 20.0f;
    _pageControl.centerX = self.contentView.centerX;
    _pageControl.centerY = self.contentView.height * 0.95;
    
}


#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int Page = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
    self.pageControl.currentPage = Page;
}

//将要开始拖拽，关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
}


//将要结束拖拽的时候，开启定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self startTimer];
}

@end
