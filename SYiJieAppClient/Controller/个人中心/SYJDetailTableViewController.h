//
//  SYJDetailTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/10.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *BabyImage;
@property (weak, nonatomic) IBOutlet UILabel *BabyName;
@property (weak, nonatomic) IBOutlet UILabel *StoreName;
@property (weak, nonatomic) IBOutlet UILabel *addree;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *usertelephon;

@property (weak, nonatomic) IBOutlet UILabel *OrderTime;
@property (weak, nonatomic) IBOutlet UILabel *BabyPrice;
@property (weak, nonatomic) IBOutlet UILabel *ordernumber;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *gocomment;

@property (nonatomic) NSString *babyid;
@property (nonatomic)NSString *stauts;
@property (nonatomic)NSString *address;
@property (nonatomic)int  oderid;
@end
