//
//  SYJEmailViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/21.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJEmailViewController.h"
#import "AppDelegate.h"
@interface SYJEmailViewController ()

@end

@implementation SYJEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      // self.Email.text=APPDELEGATE.user.email;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.changemail(self.Email.text);
    APPDELEGATE.user.email=self.Email.text;
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
