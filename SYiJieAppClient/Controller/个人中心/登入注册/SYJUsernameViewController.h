//
//  SYJUsernameViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^changername)(NSString *);

@interface SYJUsernameViewController : UIViewController
@property (copy,nonatomic)changername changer;

@property (weak, nonatomic) IBOutlet UITextField *changernameLable;

@end
