//
//  SYJPassWordViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/13.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJPassWordViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SYJYanzhenViewController.h"
@interface SYJPassWordViewController ()<ViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *paswordFileld;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SYJPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RegisterButton:(UIButton *)sender {
        [self request];
    
    
}
-(void)request{
    NSDictionary *info=@{@"user_telephone":self.Tehephone,
                         @"user_password":self.paswordFileld.text,
                         @"user_name":@"尚衣街",
                         @"user_accounts":@"123"};
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager ];
    [manager POST:kRegister parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@",dic);
         
        APPDELEGATE.user=[SYJUser initWithDic:dic];
        [APPDELEGATE.defaults setObject:@"1" forKey:@"isLogin"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_name"] forKey:@"username"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_image"] forKey:@"headImage"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_sex"] forKey:@"user_sex"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_constellation"] forKey:@"constellation"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_id"] forKey:@"user_id"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_brithday"] forKey:@"brithday"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_lovestate"] forKey:@"lovestate"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_address"] forKey:@"user_address"];
        NSNumber *age=[dic objectForKey:@"user_age"];
        
        [APPDELEGATE.defaults setObject:age forKey:@"age"];
        NSLog(@"%@",APPDELEGATE.user.user_Constellation);
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SYJYanzhenViewController *vc=(SYJYanzhenViewController *)segue.destinationViewController;
    vc.delegate=self;
}
-(void)ViewControllerWithName:(NSString *)name{
    self.Tehephone=name;
}
@end
