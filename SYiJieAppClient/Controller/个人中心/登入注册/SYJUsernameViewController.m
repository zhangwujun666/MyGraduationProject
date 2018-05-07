//
//  SYJUsernameViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJUsernameViewController.h"
#import "AppDelegate.h"
@interface SYJUsernameViewController ()

@end

@implementation SYJUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changernameLable.text=APPDELEGATE.user.username;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    self.changer(self.changernameLable.text);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
