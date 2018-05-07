//
//  SYJuserTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJuserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *prcie;

@property (weak, nonatomic) IBOutlet UILabel *goodsname;
@property (weak, nonatomic) IBOutlet UIImageView *goodsimage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadClict;

@end
