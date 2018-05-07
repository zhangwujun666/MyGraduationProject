//
//  SYJClassifyAllCellViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/6.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJClassifyAllTableViewCell.h"

@interface SYJClassifyAllCellViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SYJClassifyAllTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ClassifyAllTableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (strong,nonatomic) NSString * type;
@end
