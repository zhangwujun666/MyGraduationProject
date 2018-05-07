//
//  SYJYanzhenViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/13.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJYanzhenViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SYJPassWordViewController.h"
@interface SYJYanzhenViewController (){
     NSString *_info;
    BOOL status;
    NSTimer *time;
    int j;
    NSString *str;
    BOOL statusone;
    BOOL judgecount;
    BOOL strjudge;
    BOOL requeststatue;
}
@property (weak, nonatomic) IBOutlet UITextField *TelePhonLable;

@property (weak, nonatomic) IBOutlet UITextField *CheckFiled;
@property (weak, nonatomic) IBOutlet UIButton *GetCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (weak, nonatomic) IBOutlet UILabel *one;

@end

@implementation SYJYanzhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.CheckFiled.tag=1;
    
    [self.CheckFiled addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    status=NO;

    self.NextButton.enabled=NO;
    self.NextButton.layer.cornerRadius=12;
}
-(void)sendMessageRequest{
    NSString *url=@"http://106.ihuyi.cn/webservice/sms.php?method=Submit";
    NSString *account = @"cf_zcm";
    NSString *password = @"abcd123e45";
    NSString *mobile = self.TelePhonLable.text;
    
    NSString *content = [NSString stringWithFormat:@"您的验证码是：%@。请不要把验证码泄露给其他人。",[self getSixVerifyNum]];
    NSDictionary *dic = @{
                          @"account":account,
                          @"password":password,
                          @"mobile":mobile,
                          @"content":content
                          };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkButton:(id)sender {
    [self requestcount];
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(yanchi) userInfo:nil repeats:NO];
}
-(void)yanchi{//注册各种判断
    statusone=YES;
        for (int i=0; i<self.TelePhonLable.text.length; i++) {
            unichar number=[self.TelePhonLable.text characterAtIndex:i];
            if(number>='0'&&number<='9'){//判断输入的字符为数字
                NSLog(@"yes");
            }
            else{
                statusone=NO;
            }
        }
        NSString *firstone=[self.TelePhonLable.text substringWithRange:NSMakeRange(0, 1)];
        if([firstone isEqualToString:@"1"]){//判断第一位数字为1
            strjudge=YES;
        }
        else{
            strjudge=NO;
        }
        if(self.TelePhonLable.text.length==11&&strjudge==YES&&statusone==YES&&judgecount==NO){
            
            j=60;
            self.one.text=str;
            //[self sendMessageRequest];
            time=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timelable) userInfo:nil repeats:YES];
            self.one.hidden=NO;
            self.GetCheckButton.hidden=YES;
        }
        else if(self.TelePhonLable.text.length!=11||strjudge==NO||statusone==NO){
            
            [self telephonremeber];
        }
        else{
            [self exitcz];
        }
    }


-(void)requestcount{
    judgecount=YES;
    requeststatue=NO;
    NSDictionary *dic=@{@"user_telephone":self.TelePhonLable.text};
    AFHTTPRequestOperationManager *mangr=[AFHTTPRequestOperationManager manager];
    [mangr POST:judge parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        NSDictionary *data=(NSDictionary *)responseObject;
        if([[data objectForKey:@"code"]isEqualToString:@"200"]){
            judgecount=YES;
            requeststatue=YES;
            [self yanchi];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failu");
        judgecount=NO;
        requeststatue=YES;
        [self yanchi];
    }];
}
-(void)timelable{
    if(j>0){
    j--;
str=[NSString stringWithFormat:@"%d秒",j];
       
  self.one.text=str;
    }
    else {
        
        self.GetCheckButton.titleLabel.text=@"重新获取";
        self.GetCheckButton.hidden=NO;
        [time invalidate];
        time=nil;
        self.one.hidden=YES;
    }
}
-(void)remeberlable{
    //提醒标签
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"验证码错误";
    //lbl.font=[UIFont systemFontOfSize:13];
    lbl.frame = CGRectMake(90, 400, 150, 25);
    
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
-(void)telephonremeber{
    //提醒标签
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"请输入正确的手机号";
    //lbl.font=[UIFont systemFontOfSize:13];
    lbl.frame = CGRectMake(80, 260, 150, 25);
    
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
-(void)exitcz{
    //提醒标签
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"手机号已经注册";
    //lbl.font=[UIFont systemFontOfSize:13];
    lbl.frame = CGRectMake(80, 260, 150, 25);
    
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

- (IBAction)NextButton:(UIButton *)sender {
    
    if ([self.CheckFiled.text isEqualToString:@"1"]) {

       SYJPassWordViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"zhuce"];
        vc.Tehephone=self.TelePhonLable.text;
       [self.navigationController  pushViewController:vc animated:YES];
        
    }
    else{
        [self remeberlable];
    }
    
    
}

-(void)textFieldChanged{
    NSLog(@"%@",self.CheckFiled.text);
    int longth=(int)[self.CheckFiled.text length];
    if(longth>0&&longth<5){
        UIColor *yellow=[UIColor colorWithRed:225.0/225 green:140.0/225 blue:00.0/225 alpha:1];
        self.NextButton.backgroundColor=yellow;
        self.NextButton.titleLabel.textColor=[UIColor whiteColor];
        self.NextButton.layer.cornerRadius=15;
        self.NextButton.alpha=0.8;
        
       // self.NextButton.titleLabel.textColor=[UIColor colorWithRed:229/255 green:224/255  blue:224/255  alpha:1];
       // self.NextButton.userInteractionEnabled=YES;
        self.NextButton.enabled=YES;
    }
    else{
     self.NextButton.backgroundColor=[UIColor colorWithRed:125/225 green:196 /225 blue:196/225 alpha:0.6];
        
        self.NextButton.titleLabel.textColor=[UIColor whiteColor];
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}

@end
