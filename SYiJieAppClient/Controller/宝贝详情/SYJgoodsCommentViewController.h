//
//  SYJCommentViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/19.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJgoodsCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableviewShow;
@property NSString *babyid;
@property (strong, nonatomic) UIView *blackView;//背景的黑色view
@property (strong, nonatomic) UIScrollView *scrollView;//scrollView
@property (strong, nonatomic) UIPageControl *pageControl;//pageControl
@end

