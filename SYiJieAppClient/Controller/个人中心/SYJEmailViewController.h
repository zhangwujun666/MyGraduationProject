//
//  SYJEmailViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/21.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^changeremail)(NSString *);
@interface SYJEmailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (copy,nonatomic)changeremail changemail;
@end
