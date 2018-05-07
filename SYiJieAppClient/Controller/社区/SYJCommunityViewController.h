//
//  SYJCommunityViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/17.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJCommunityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UITableView *shareTableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) UIView *blackView;//背景的黑色view
@property (strong, nonatomic) UIScrollView *scrollView;//scrollView
@property (strong, nonatomic) UIPageControl *pageControl;//pageControl

- (void)getDataSource;

@end
