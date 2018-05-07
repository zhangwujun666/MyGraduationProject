//
//  SYJShopdetailTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJShopdetailTableViewController : UITableViewController
@property (strong,nonatomic)NSString *goodsid;
@property (strong,nonatomic)NSString *size;
@property (strong,nonatomic)NSString *colour;
@property (strong,nonatomic)NSString *shopnumber;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *usertelephon;
@property (weak, nonatomic) IBOutlet UILabel *useraddress;
@property (weak, nonatomic) IBOutlet UILabel *storename;
@property (weak, nonatomic) IBOutlet UILabel *goodsname;
@property (weak, nonatomic) IBOutlet UILabel *goodssize;
@property (weak, nonatomic) IBOutlet UILabel *goodscolour;
@property (weak, nonatomic) IBOutlet UIImageView *goodiamge;
@property (weak, nonatomic) IBOutlet UILabel *yunmoney;
@property (weak, nonatomic) IBOutlet UILabel *zgoodsmoney;
@property (weak, nonatomic) IBOutlet UILabel *goodsnuber;
@property (weak, nonatomic) IBOutlet UILabel *goodsprice;
@property (strong,nonatomic)NSString *sholudprice;
@end
