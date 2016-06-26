//
//  KFBrandCollectionView.m
//  KingFamily
//
//  Created by Sycamore on 16/4/23.
//  Copyright © 2016年 King. All rights reserved.
//

#import "KFBrandCollectionView.h"

#define ColumCount            4
#define RowCount              3


@implementation KFBrandCollectionView

//- (void)drawRect:(CGRect)rect
//{
//    CGFloat height = self.height / RowCount;
//    CGFloat width = self.width / ColumCount;
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    //画横线
//    for (NSInteger index = 0; index <= RowCount; index ++) {
//        [path moveToPoint:CGPointMake(0, index * height)];
//        [path addLineToPoint:CGPointMake(Screen_Width,index * height)];
//        
//    }
//    //画竖线
//    for (NSInteger index = 1; index < ColumCount; index ++) {
//        [path moveToPoint:CGPointMake(index * width, 0)];
//        [path addLineToPoint:CGPointMake(index * width,ColumCount * height)];
//        
//    }
//    [KFColor(200, 200, 200) set];
//    
//    //使用path stroke就不用在上下文里操作了
//    [path stroke];
//    
//}
@end
