//
//  SYJActivityCellViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJActivityCellViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *miaoShaTaleView;
@property (weak, nonatomic) IBOutlet UIButton *time10Button;
@property (weak, nonatomic) IBOutlet UIButton *time16Button;
@property (weak, nonatomic) IBOutlet UIButton *time22Button;
@property (weak, nonatomic) IBOutlet UIButton *time0Button;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (strong ,nonatomic)NSString * date;
@property (nonatomic)NSInteger goodsNum;
@end
