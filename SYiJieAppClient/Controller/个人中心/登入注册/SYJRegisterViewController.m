//
//  SYJRegisterViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJRegisterViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface SYJRegisterViewController (){
    NSString *_info;
  
}
@property (weak, nonatomic) IBOutlet UITextField *telephonField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *UsernameField;
@property (weak, nonatomic) IBOutlet UITextField *accountsField;

@end

@implementation SYJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view endEditing:YES];
}
#pragma mark 注册
- (IBAction)SureButton:(UIButton *)sender {
    NSDictionary *info=@{@"user_telephone":self.telephonField.text,
                         @"user_password":self.passwordField.text,
                         @"user_name":self.UsernameField.text,
                         @"user_accounts":self.accountsField.text};
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager ];
    [manager POST:kRegister parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@",dic);
        
         APPDELEGATE.user=[SYJUser initWithDic:dic];//给当前的程序就是给全局变量
        
        [APPDELEGATE.defaults setObject:@"1" forKey:@"isLogin"];//存入缓存
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_name"] forKey:@"username"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_image"] forKey:@"headImage"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_sex"] forKey:@"user_sex"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_constellation"] forKey:@"constellation"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_id"] forKey:@"user_id"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_brithday"] forKey:@"brithday"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_lovestate"] forKey:@"lovestate"];
        NSNumber *age=[dic objectForKey:@"user_age"];
       
        [APPDELEGATE.defaults setObject:age forKey:@"age"];
        NSLog(@"%@",APPDELEGATE.user.lovestate);
        self.statuisregist=YES;
        self.navigationController.tabBarController.selectedIndex=4;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
        self.statuisregist=NO;
    }];
 
    
}
//-(void)nn{
//    if(APPDELEGATE.Loginstatus==YES&&judgeislogin==YES){
//        
//        SYJCarGoodsTableViewController *carvc=[[UIStoryboard storyboardWithName:@"CarGoods" bundle:nil]instantiateViewControllerWithIdentifier:@"car"];
//        
//        [self.navigationController pushViewController:carvc animated:YES];
//    }
//    else if (judgeislogin==YES&&APPDELEGATE.outrightplay==YES){
//        //        SYJBaybyTableViewController *babyvc=[[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil]instantiateViewControllerWithIdentifier:@"baby"];
//        //        [self.navigationController pushViewController:babyvc animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else if (judgeislogin==YES){
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [self prompt];
//        
//    }
//
//}
-(void)sendMessageRequest{
    NSString *url=@"http://106.ihuyi.cn/webservice/sms.php?method=Submit";
    NSString *account = @"cf_zcm";
    NSString *password = @"abcd123e45";
    NSString *mobile = self.telephonField.text;
    NSString *content = [NSString stringWithFormat:@"【尚衣街】您的验证码是：%@。请不要把验证码泄露给其他人。",[self getSixVerifyNum]];
    NSDictionary *dic = @{
                          @"account":account,
                          @"password":password,
                          @"mobile":mobile,
                          @"content":content
                          };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送请求成功！");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送请求失败！");
    }];
}
#pragma mark - 生成四位随机数
-(NSString *)getSixVerifyNum{
    self.str = [NSMutableString string];
    for (int i = 0; i < 4; i++) {
        int num = arc4random() % 10;
        [self.str appendFormat:@"%d",num];
    }
    return self.str;
}


-(void)viewDidDisappear:(BOOL)animated{
   // [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_name"]
}

//取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];// [textFiled resignFirstResponder];这个是取消当前textFIled的键盘
     }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
