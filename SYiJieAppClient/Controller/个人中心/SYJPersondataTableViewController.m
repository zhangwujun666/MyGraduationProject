//
//  SYJPersondataTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJPersondataTableViewController.h"
#import "AFNetworking.h"
#import "SYJUsernameViewController.h"
#import "AppDelegate.h"
#import "SYJDataPickView.h"
#import "SYJPersonalTableViewController.h"
#import "Pickview.h"
#import "SYJEmailViewController.h"
#import "SYJPersondata.h"
@interface SYJPersondataTableViewController ()<ZHPickViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,Pickdelegate>
{
    SYJPersondata *personheadVc;
    int Mouth ;
    NSString *Strage;
    NSInteger intage;
    NSNumber *Useryear;
    UIView *back;
    Pickview *pickView;
    UITapGestureRecognizer *tapgeture;
    UIView *view;
}
@property (nonatomic, retain) UIControl *controlForDismiss;
@property(nonatomic,strong)ZHPickView *pickview;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *SexLable;
@property (weak, nonatomic) IBOutlet UILabel *datelable;
@property (weak, nonatomic) IBOutlet UILabel *lovestatelable;
@property (weak, nonatomic) IBOutlet UILabel *userhometownLable;
@property (weak, nonatomic) IBOutlet UILabel *userconstellationLable;
@property (weak, nonatomic) IBOutlet UILabel *EmalLable;
@property (weak, nonatomic) IBOutlet UILabel *registerTimelable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_loadClict;

@end

@implementation SYJPersondataTableViewController
@synthesize controlForDismiss = _controlForDismiss;
- (void)viewDidLoad {
    [super viewDidLoad];
    //'self.tableView.separatorStyle=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
       self.tableView.tableFooterView=[[UIView alloc]init];
self.datelable.text=APPDELEGATE.user.user_brithday;

  self.userconstellationLable.text= [NSString stringWithFormat:@"%@", APPDELEGATE.user.user_Constellation];
 [self RequestUserData];
     tapgeture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personReturn) name:@"personname" object:nil];
    [self creatheandView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"username"]) {
        SYJUsernameViewController *vc=(SYJUsernameViewController *)segue.destinationViewController;
        vc.changer=^(NSString *name){
            self.usernameLable.text=name;
            NSLog(@"66666%@",name);
            [self changerdate];
        };
    }
    else{
        SYJEmailViewController *vcc=(SYJEmailViewController *)segue.destinationViewController;
        vcc.changemail=^(NSString *email){
            self.EmalLable.text=email;
            APPDELEGATE.user.email=email;
            [APPDELEGATE.defaults setObject:email forKey:@"email"];
        };
    }
   
}
//#pragma mark用户请求个人资料
-(void)RequestUserData{
      self.usernameLable.text=APPDELEGATE.user.username;
 self.SexLable.text=APPDELEGATE.user.sex;
   self.lovestatelable.text=APPDELEGATE.user.lovestate;
   self.userhometownLable.text=APPDELEGATE.user.home;
//  self.EmalLable.text=APPDELEGATE.user.email;
}
//
#pragma mark用户修改增加资料
-(void)changerdate{
    //保存在数据库中
    NSNumber *age=[NSNumber numberWithInt:APPDELEGATE.user.age];
    NSDictionary *personinfo=@{@"user_sex":self.SexLable.text,
                               @"user_name":APPDELEGATE.user.username,
                                @"lovestate":APPDELEGATE.user.lovestate,
                               @"user_brithday":APPDELEGATE.user.user_brithday,
                               @"user_constellation":APPDELEGATE.user.user_Constellation,
                               @"user_age":age,
                               @"user_address":APPDELEGATE.user.home};
    
    NSString *requestID=[NSString stringWithFormat:@"%@%lu",kchangedata,APPDELEGATE.user.userID];
    NSLog(@"ffff%@",[personinfo objectForKey:@"user_sex"]);
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager ];
    [manager POST:requestID parameters:personinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改增加成功");
        
        //保存在缓存中
        [APPDELEGATE.defaults setObject:self.usernameLable.text forKey:@"username"];
        //保存在运行程序中
        APPDELEGATE.user.username = self.usernameLable.text;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"修改失败");
    }];
}


#pragma mark 指定选择性别cell那栏
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    if(indexPath.row==0){
        
    }
        if(indexPath.row==1){
           
            UIActionSheet *Sexshow=[[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
            Sexshow.tag=0;
            [Sexshow showInView:self.view];
        }
    if(indexPath.row==2){
         [self viewaa];
        [self DataShow];
     
    }
    if (indexPath.row==3) {
        
        UIActionSheet *love=[[UIActionSheet alloc]initWithTitle:@"恋爱情况" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"单身" otherButtonTitles:@"热恋中",@"保密", nil];
        love.tag=1;
        [love showInView:self.view];
    }
    
    if(indexPath.row==4){
     view=[[UIView alloc]init];
        view.frame=[UIScreen mainScreen].bounds;
        [self.tableView addSubview:view];
        pickView=[[[NSBundle mainBundle]loadNibNamed:@"PIckView" owner:self options:nil]objectAtIndex:0];
         pickView.delegate=self;
         pickView.frame=CGRectMake(0, 600, [[UIScreen mainScreen]bounds].size.width, 400);
        [ view addGestureRecognizer:tapgeture];
        [view addSubview:pickView];
        [pickView changanima];
    }
   
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==0){
    if(buttonIndex==0){
        NSString *Man=@"男";
        [APPDELEGATE.defaults setObject:Man forKey:@"user_sex"];
        APPDELEGATE.user.sex=Man;
        self.SexLable.text=Man;
        [self changerdate];
    }
    if(buttonIndex==1){
        NSString *Woman=@"女";
        [APPDELEGATE.defaults setObject:Woman forKey:@"user_sex"];
        APPDELEGATE.user.sex=Woman;
        self.SexLable.text=Woman;
        [self changerdate];
    }
    }
    else{
        if(buttonIndex==0){
            NSString *single=@"单身";
            [APPDELEGATE.defaults setObject:single forKey:@"lovestate"];
            APPDELEGATE.user.lovestate=single;
            self.lovestatelable.text=single;
            [self changerdate];
        }
        else if (buttonIndex==1){
            NSString *loved=@"热恋中";
            [APPDELEGATE.defaults setObject:loved forKey:@"lovestate"];
            APPDELEGATE.user.lovestate=loved;
            self.lovestatelable.text=loved;
            [self changerdate];
        }
        else{
            NSString *loved=@"保密";
            [APPDELEGATE.defaults setObject:loved forKey:@"lovestate"];
            APPDELEGATE.user.lovestate=loved;
            self.lovestatelable.text=loved;
            [self changerdate];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark日期视图
-(void)DataShow{
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    self.pickview.delegate=self;
    
    [ self.pickview show];
    }
#pragma mark日期触发事件
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
   
    [self viewbb];
    [APPDELEGATE.defaults setObject:resultString forKey:@"brithday"];
    APPDELEGATE.user.user_brithday=resultString;
     self.datelable.text=resultString;
    
    NSString *Mouthstr1= [resultString substringWithRange:NSMakeRange(5, 2)];
    NSString *data= [resultString substringWithRange:NSMakeRange(8, 2)];
    Strage=[resultString substringWithRange:NSMakeRange(0,4)];
    
   NSString *XingZuo = [NSString stringWithFormat:@"%@%@",Mouthstr1,data];
    intage=[Strage integerValue];
    Mouth=[XingZuo intValue];
    NSLog(@"%lu",intage);
    [self xingzuo];
    [self UserAge];
    NSLog(@"%@",Useryear);
    [self changerdate];
  }
#pragma mark星座
-(void)xingzuo{
     if(Mouth>119&&Mouth<=218){
        self.userconstellationLable.text=@"水瓶座";
    }
     else if(Mouth>119&&Mouth<=320){
         self.userconstellationLable.text=@"双鱼座";
     }
   else if(Mouth>320&&Mouth<=419){
       self.userconstellationLable.text=@"白羊座";
    }
   else if(Mouth>419&&Mouth<=520){
        self.userconstellationLable.text=@"金牛座";
    }
   else if(Mouth>520&& Mouth<=621){
        self.userconstellationLable.text=@"双子座";
       APPDELEGATE.user.user_Constellation=@"双子座";
    }
   else if(Mouth>621&& Mouth<=722){
        self.userconstellationLable.text=@"巨蟹座";
    }
    else if(Mouth>722&& Mouth<=822){
        self.userconstellationLable.text=@"狮子座";
    }
   else if(Mouth>822&&Mouth<=922){
        self.userconstellationLable.text=@"处女座";
    }
   else if(Mouth>922&& Mouth<=1023){
        self.userconstellationLable.text=@"天秤座";
    }
   else if(Mouth>1023&& Mouth<=1122){
        self.userconstellationLable.text=@"天蝎座";
    }
   else if(Mouth>1122&& Mouth<=1221){
        self.userconstellationLable.text=@"射手座";
    }
    else{
         self.userconstellationLable.text=@"魔蝎座";
    }
     [APPDELEGATE.defaults setObject:self.userconstellationLable.text forKey:@"Constellation"];
    APPDELEGATE.user.user_Constellation=self.userconstellationLable.text;

}
#pragma mark年龄
-(void)UserAge{
    NSDate* now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags =NSYearCalendarUnit ;
    
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSLog(@"%@",now);
    NSInteger y=[dd year];
    NSInteger yearr=y-intage;
    if(yearr>0){
    Useryear = [[NSNumber alloc]initWithInteger:yearr];
        
    [APPDELEGATE.defaults setObject:Useryear forKey:@"age"];
        APPDELEGATE.user.age=(int)yearr;
        self.useragee=[NSNumber numberWithInteger:yearr];
    }else{
        NSInteger erroyear=0;
         Useryear = [[NSNumber alloc]initWithInteger:erroyear];
        [APPDELEGATE.defaults setObject:Useryear forKey:@"age"];
        APPDELEGATE.user.age=(int)erroyear;
        self.useragee=[NSNumber numberWithInteger:erroyear];
    }
    
}
//点击取消的时候去掉背景的暗黑色
-(void)removebarckcolour{
    [self viewbb];
}
-(void)viewaa{
    CGRect rect = [[UIScreen mainScreen]bounds];
    back=[[UIView alloc]initWithFrame:rect];
    back.backgroundColor=[UIColor blackColor];
    back.alpha=0.5;
    [self.tableView addSubview:back];
    
                  }
-(void)viewbb{
    back.backgroundColor=[UIColor whiteColor];
    back.alpha=0;
    [back removeFromSuperview];
    
}
//- (void)handle:(UITapGestureRecognizer*)sender
- (void)handleBackgroundTap:(UITapGestureRecognizer*)sender{
    [self changerdate];
    [UIView animateWithDuration:0.5 animations:^{
        [pickView cityy];

    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [pickView removeFromSuperview];
    }];
    
}

-(void)pick:(Pickview *)pickVc sheng:(NSString *)sheng andcity:(NSString *)city andqu:(NSString *)qu{
    NSString *home=[NSString stringWithFormat:@"%@",city];
    self.userhometownLable.text=home;
    APPDELEGATE.user.home=home;
    
    [APPDELEGATE.defaults setObject:home forKey:@"user_address"];
    
}
-(void)viewWillAppear:(BOOL)animated{
  
   // self.navigationController.navigationBar.hidden=YES;//把导航标题移除了
    self.tabBarController.tabBar.hidden=YES;
    
    personheadVc.hidden=NO;
//    self.tabBarController.view.hidden=YES;//整个视图都没了
    //self.navigationController.t
}

-(void)viewWillDisappear:(BOOL)animated{
    personheadVc.hidden=YES;
}
#pragma mark自定义头
-(void)creatheandView{
    personheadVc=[[[NSBundle mainBundle]loadNibNamed:@"SYJPersondata" owner:self options:nil]objectAtIndex:0];
    personheadVc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    [self.tabBarController.view addSubview:personheadVc];
    
}
-(void)personReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
