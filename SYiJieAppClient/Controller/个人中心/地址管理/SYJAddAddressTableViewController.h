//
//  SYJAddAddressTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJAddAddressTableViewController : UITableViewController
@property(nonatomic) NSString *addid;
@property NSString *telephon;
@property NSString *name;
@property NSString *addressname;
@property NSString *shenshiqu;
@property (weak, nonatomic) IBOutlet UISwitch *Switchison;
@property NSString *MR;
@end
