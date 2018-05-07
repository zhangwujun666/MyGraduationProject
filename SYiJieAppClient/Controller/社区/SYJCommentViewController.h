//
//  SYJCommentViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/22.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJShareTableViewCell.h"

@interface SYJCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic)NSString * shareId;
@property (assign, nonatomic)int headerViewHeight;
@property (strong, nonatomic)UIView *tableviewHeaderView;
@property (strong, nonatomic)SYJShareTableViewCell *sharecell;
@property (assign, nonatomic)int goodId;
@property (strong, nonatomic) UIView *blackView;//背景的黑色view
@property (strong, nonatomic) UIScrollView *scrollView;//scrollView
@property (strong, nonatomic) UIPageControl *pageControl;//pageControl

- (void)setUpInit;
@end
