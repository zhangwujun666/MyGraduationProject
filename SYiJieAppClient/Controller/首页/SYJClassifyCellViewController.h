//
//  SYJClassifyCellViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJTadyBrandTableViewCell.h"
#import "SYJHotGoodsTableViewCell.h"
#import "SYJMiaoShaTableViewCell.h"
@interface SYJClassifyCellViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SYJTadyBrandTableViewCellDelegate,SYJHotGoodsTableViewCellDelegate,SYJMiaoShaTableViewCellDelegate>

@property (strong , nonatomic) NSString * type;
@property (weak, nonatomic) IBOutlet UITableView *classifyCellTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end
