//
//  SYJCollectTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *StoreImage;
@property (weak, nonatomic) IBOutlet UILabel *Storename;
@property (weak, nonatomic) IBOutlet UILabel *Stroeaddress;
@property (weak, nonatomic) IBOutlet UIButton *Cancel;

@end
