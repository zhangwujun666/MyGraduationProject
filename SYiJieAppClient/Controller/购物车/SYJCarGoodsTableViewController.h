//
//  SYJCarGoodsTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJCarGoodsTableViewController : UITableViewController
@property (nonatomic, strong) UILabel *noDataLabel;//显示没有数据的UILabel
@property (nonatomic, strong) UIView *backView;//背景视图

@property (nonatomic, strong) UIView *noDataView;//未登录的视图
@property (nonatomic, strong) UILabel *noDatalb;//未登录的提示信息
@end
