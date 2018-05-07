//
//  SYJNavigationView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJNavigationView.h"

@implementation SYJNavigationView

//初始化自定义view的函数
-(void)awakeFromNib{
    //去除搜索框的背景
    UIView *view0=[self.customSearchBar.subviews objectAtIndex:0];
    UIView *subView0=[view0.subviews objectAtIndex:0];
    [subView0 removeFromSuperview];
    
    //给imageView添加一个手势
    self.backImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *gersture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goback:)];
    [self.backImage addGestureRecognizer:gersture];
    //定义代理执行响应的事件
    self.customSearchBar.delegate=self;
    
    //设置背景颜色和字体
    self.backgroundColor=navigationViewBgcolor;
    [self.searchButton setTintColor:btnColor];
    self.searchButton.titleLabel.font=titleFont;
    [self.customSearchBar setTintColor:cellTextColor];
    [self setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:lineColor borderWidth:1];
}

//点击
-(void)goback:(UITapGestureRecognizer *)recognizer{
    if ([self.delegate respondsToSelector:@selector(backImageGoBack)]) {
        [self.delegate backImageGoBack];
    }
}

//点击键盘上的search键的时候开始执行
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search--%@",self.customSearchBar.text);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search--点击了取消按钮");
}


#pragma mark-设置UIView边框
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

@end
