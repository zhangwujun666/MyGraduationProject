//
//  SYJShareDetailCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/9/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJShareDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UILabel *shareContent;//内容
@property (strong, nonatomic) UILabel *repeatLabel;//设置转发的内容
@end
