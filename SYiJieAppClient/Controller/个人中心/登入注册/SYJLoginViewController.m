//
//  SYJLoginViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJLoginViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SYJPersonalTableViewController.h"
#import "SYJNologin.h"
#import "SYJCarGoodsTableViewController.h"
#import "SYJBaybyTableViewController.h"
#import "UMSocial.h"
#import "UMSocialSnsPlatformManager.h"
@interface SYJLoginViewController (){
    SYJNologin *vcc;
    BOOL judgeislogin;
}
@property (weak, nonatomic) IBOutlet UITextField *telephoneUITextField;
@property (weak, nonatomic) IBOutlet UITextField *paswardUITextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SYJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius=7;
    //self.navigationController.navigationBar.hidden = YES;
    vcc=[[[NSBundle mainBundle]loadNibNamed:@"Nologin" owner:self options:nil]objectAtIndex:0];
    vcc.frame=CGRectMake(0, 0, 320, 70);
    [self.navigationController.view addSubview:vcc];
    
    //给VCC的backImaeg绑定事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClicked)];
    vcc.backImageView.userInteractionEnabled = YES;
    [vcc addGestureRecognizer:gesture];
    //self.navigationController.title = @"登录页面";
    
}

- (void)backClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 登入
- (IBAction)EnterButton:(UIButton *)sender {
    judgeislogin=NO;
    NSString *str=[NSString stringWithFormat:@"user_telephone=%@&user_password=%@",self.telephoneUITextField.text,self.paswardUITextField.text];
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *requst=[[NSMutableURLRequest alloc]init];
    [requst setTimeoutInterval:10];
    [requst setURL:[NSURL URLWithString:klogin]];
    [requst setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [requst setHTTPMethod:@"POST"];
    [requst setHTTPBody:data];
    NSData *connent=[NSURLConnection sendSynchronousRequest:requst returningResponse:nil error:nil];
    
    NSDictionary *responseobject=[NSJSONSerialization JSONObjectWithData:connent options:NSJSONReadingMutableLeaves error:nil];
      NSString *code = [responseobject objectForKey:@"code"];
    
    if ([code isEqualToString:@"200"]) {
        //登入成功
      
    NSDictionary *dic=[responseobject objectForKey:@"data"];
    APPDELEGATE.user.email=[dic objectForKey:@"user_email"]==nil?@"":[dic objectForKey:@"user_email"];
        //传给当前运行的用户
        NSLog(@"%@",dic);
    APPDELEGATE.user=[SYJUser initWithDic:dic]; 
   //存入缓存中18094157890
        NSLog(@"%lu",APPDELEGATE.user.userID);
    [APPDELEGATE.defaults setObject:@"1" forKey:@"isLogin"];
    [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_name"]==nil?@"":[dic objectForKey:@"user_name"] forKey:@"username"];
    [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_image"]==nil?@"":[dic objectForKey:@"user_image"] forKey:@"headImage"];
    [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_sex"]==nil?@"":[dic objectForKey:@"user_sex"] forKey:@"user_sex"];
    [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_constellation"]==nil?@"":[dic objectForKey:@"user_constellation"] forKey:@"constellation"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_id"]==nil?@"":[dic objectForKey:@"user_id"] forKey:@"user_id"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_brithday"]==nil?@"":[dic objectForKey:@"user_brithday"] forKey:@"brithday"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_lovestate"]==nil?@"":[dic objectForKey:@"user_lovestate"] forKey:@"lovestate"];
        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_address"]==nil?@"":[dic objectForKey:@"user_address"] forKey:@"adress"];
        NSNumber *age=[dic objectForKey:@"user_age"]==nil?@"":[dic objectForKey:@"user_age"];
         NSLog(@"%@",[dic objectForKey:@"user_address"]);
        [APPDELEGATE.defaults setObject:age forKey:@"age"];
        judgeislogin=YES;
        
        //发送通知提示更新社区上面的头像和购物车里面的数据
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"reloadPersonImage" object:nil];
    }
    else{
        //登入失败
        judgeislogin=NO;
        NSLog(@"登入失败");
        
    }
   
    if(APPDELEGATE.Loginstatus==YES&&judgeislogin==YES){
        
        SYJCarGoodsTableViewController *carvc=[[UIStoryboard storyboardWithName:@"CarGoods" bundle:nil]instantiateViewControllerWithIdentifier:@"car"];
       
        [self.navigationController pushViewController:carvc animated:YES];
    }
    else if (judgeislogin==YES&&APPDELEGATE.outrightplay==YES){
        //        SYJBaybyTableViewController *babyvc=[[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil]instantiateViewControllerWithIdentifier:@"baby"];
        //        [self.navigationController pushViewController:babyvc animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (judgeislogin==YES){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self prompt];
       
    }
}

-(void)prompt{
    //提醒标签
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"账号或密码错误！";
    //lbl.font=[UIFont systemFontOfSize:13];
    lbl.frame = CGRectMake(80, 200, 150, 25);
    
    lbl.backgroundColor = [UIColor blackColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.alpha = 0.7;
    lbl.font=[UIFont systemFontOfSize:12];
    lbl.layer.cornerRadius=10;
    lbl.layer.masksToBounds=YES;
    //lbs设置为圆角？？
    
    //label添加到父视图中显示
    [self.view addSubview:lbl];
    
    //简单动画：2秒内让lable的alpha从1变为0，实现渐变效果
    
    [UIView animateWithDuration:2 animations:^{
        //动画内容
        lbl.alpha = 0;
        
    } completion:^(BOOL finished) {
        //从父视图中移除lable
        [lbl removeFromSuperview];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    //self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    vcc.hidden=YES;
    self.navigationController.navigationBar.hidden = NO;
    //self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{//对控件不起作用，对空白区域有作用
    [self.view endEditing:YES];
    [self.paswardUITextField resignFirstResponder];
}
- (IBAction)OtherloginButton:(UIButton *)sender {
//    [self otherlogin];
//    judgeislogin=NO;
//    NSString *str=[NSString stringWithFormat:@"user_telephone=%@&user_password=%@",self.telephoneUITextField.text,self.paswardUITextField.text];
//    
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *requst=[[NSMutableURLRequest alloc]init];
//    [requst setTimeoutInterval:10];
//    [requst setURL:[NSURL URLWithString:klogin]];
//    [requst setCachePolicy:NSURLRequestUseProtocolCachePolicy];
//    [requst setHTTPMethod:@"POST"];
//    [requst setHTTPBody:data];
//    NSData *connent=[NSURLConnection sendSynchronousRequest:requst returningResponse:nil error:nil];
//    
//    NSDictionary *responseobject=[NSJSONSerialization JSONObjectWithData:connent options:NSJSONReadingMutableLeaves error:nil];
//    NSString *code = [responseobject objectForKey:@"code"];
//    
//    if ([code isEqualToString:@"200"]) {
//        //登入成功
//        
//        NSDictionary *dic=[responseobject objectForKey:@"data"];
//        APPDELEGATE.user.email=[dic objectForKey:@"emal"];
//        //传给当前运行的用户
//        NSLog(@"%@",dic);
//        APPDELEGATE.user=[SYJUser initWithDic:dic];
//        //存入缓存中18094157890
//        NSLog(@"%lu",APPDELEGATE.user.userID);
//        [APPDELEGATE.defaults setObject:@"1" forKey:@"isLogin"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_name"] forKey:@"username"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_image"] forKey:@"headImage"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_sex"] forKey:@"user_sex"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_constellation"] forKey:@"constellation"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_id"] forKey:@"user_id"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_brithday"] forKey:@"brithday"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_lovestate"] forKey:@"lovestate"];
//        [APPDELEGATE.defaults setObject:[dic objectForKey:@"user_address"] forKey:@"adress"];
//        NSNumber *age=[dic objectForKey:@"user_age"];
//        NSLog(@"%@",[dic objectForKey:@"user_address"]);
//        [APPDELEGATE.defaults setObject:age forKey:@"age"];
//        judgeislogin=YES;
//        
//    }
//    else{
//        //登入失败
//        judgeislogin=NO;
//        NSLog(@"登入失败");
//        
//    }
//    
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
}

-(void)otherlogin{
    UMSocialSnsPlatform *snsolatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsolatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        UMSocialResponseEntity *entity=(UMSocialResponseEntity *)response;
        NSDictionary *data=entity.data;
        NSDictionary *sina=[data valueForKey:@"sina"];
        
        NSLog(@"%@",[sina objectForKey:@"tags"]);
        
        
    });
}
@end
