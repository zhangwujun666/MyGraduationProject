//
//  SYJAddAddressTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJAddAddressTableViewController.h"
#import "Pickview.h"
#import "SaveAdressView.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SYJPersonalTableViewController.h"
#import "UpdateHeadiew.h"

@interface SYJAddAddressTableViewController ()<UIGestureRecognizerDelegate,Pickdelegate>{
    Pickview *pick;
    UIView *view;
    SaveAdressView *vc;
     NSString *shengg;
     NSString *cityy;
     NSString *quu;
    NSNumber *nm;
    int MR;
    UpdateHeadiew *headvc;
    
}
@property (weak, nonatomic) IBOutlet UITextField *GetNameFileld;
@property (weak, nonatomic) IBOutlet UITextField *TelePhonfiled;
@property (weak, nonatomic) IBOutlet UIButton *PickButton;
@property (weak, nonatomic) IBOutlet UITextField *AddressFileld;
@property (weak, nonatomic) IBOutlet UILabel *tishiLable;

@end

@implementation SYJAddAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vc=[[[NSBundle mainBundle]loadNibNamed:@"SaveAdressView" owner:self options:nil]objectAtIndex:0];
    
    vc.frame=CGRectMake(0, 260, 320, 40);
    
    vc.layer.cornerRadius=8;
    [self.tableView addSubview:vc];
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self creathead];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle:)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SaveAddress) name:@"save" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReturnBUtton) name:@"UpdateHeadiew" object:nil];
    gesture.delegate=self;
    
    self.TelePhonfiled.text=self.telephon;
    self.PickButton.titleLabel.text=self.shenshiqu;
    [self.PickButton setTitle:self.shenshiqu forState:UIControlStateNormal];
    NSLog(@"%@",self.shenshiqu);
    if(self.shenshiqu!=nil){
        [self.tishiLable removeFromSuperview];
    }
    self. GetNameFileld.text=self.name;
    self.AddressFileld.text=self.addressname;
    
    [self.tableView addGestureRecognizer:gesture];
    if([self.MR isEqualToString:@"1"]){
        self.Switchison.on=YES;
    }
    if(APPDELEGATE.SW==YES){
        self.Switchison.on=YES;
    }
    MR=0;
    
}

- (IBAction)Pick:(UIButton *)sender {
 
    [self.TelePhonfiled resignFirstResponder];
    [self.GetNameFileld resignFirstResponder];
    [self.AddressFileld resignFirstResponder];
    CGRect rect = [[UIScreen mainScreen]bounds];
    view=[[UIView alloc]initWithFrame:rect];
    [self.navigationController.view addSubview:view];
    
 
 pick=[[[NSBundle mainBundle]loadNibNamed:@"PIckView" owner:self options:nil]objectAtIndex:0];
    pick.frame=CGRectMake(0, 600, 400, 200);
  
    pick.delegate=self;
    [view addSubview:pick];
    [self.tableView addSubview:view];
    [pick changanima];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)handle:(UITapGestureRecognizer*)sender
{
    [self.TelePhonfiled resignFirstResponder];
    [self.GetNameFileld resignFirstResponder];
    [self.AddressFileld resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        pick.frame = CGRectMake(0, 650, [[UIScreen mainScreen]bounds].size.width, 300);
    }
                     completion:^(BOOL finished) {
                         [pick removeFromSuperview];
                         [view removeFromSuperview];
                     }];
}
-(void)requset{
  nm=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
    NSDictionary *info=@{@"useradress_user_id":nm,
                         @"useradress_name":self.AddressFileld.text,
                         @"useraddress_telephon":self.TelePhonfiled.text,
                         @"adress_name":self.GetNameFileld.text,
                         @"useraddress_shengshiqu":self.PickButton.titleLabel.text,
                         @"mraddress":@"1"};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    [manger POST:kaddressa parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
-(void)Saverequest{
   
    NSNumber *mrr=[NSNumber numberWithInt:MR ];
    if(APPDELEGATE.SW==YES){
        mrr=[NSNumber numberWithInt:1];
    }
    nm=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
    NSDictionary *info=@{@"useradress_user_id":nm,
                         @"useradress_name":self.AddressFileld.text,
                         @"useraddress_telephon":self.TelePhonfiled.text,
                         @"adress_name":self.GetNameFileld.text,
                         @"useraddress_shengshiqu":self.PickButton.titleLabel.text,
                         @"mraddress":mrr,
                         @"addressidd":self.addid};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    [manger POST:kupmr parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
-(void)selectquest{
    
}
-(void)pick:(Pickview *)pickVc sheng:(NSString *)sheng andcity:(NSString *)city andqu:(NSString *)qu{
    [self.tishiLable removeFromSuperview];
    shengg=sheng;
    cityy=city;
    quu=qu;
    NSLog(@"1202102%@%@%@",shengg,cityy,quu);
    NSString *str=[NSString stringWithFormat:@"%@%@%@",shengg,cityy,quu];
    self.PickButton.titleLabel.text=str;
    [self.PickButton setTitle:str forState:UIControlStateNormal];
}
-(void)SaveAddress{
    if(APPDELEGATE.isaddress==YES){
         [self requset];
       // [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
   else if (self.addid==nil) {
        self.Switchison.on=YES;
        [self requset];//增加地址
        
    }
    else{
        [self Saverequest];//更改地址
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    vc.hidden=YES;
    headvc.hidden=YES;
}
- (IBAction)ISSureGoaddress:(UISwitch *)sender {
    if(sender.isOn){
        MR=1;
    }else{
        MR=0;
    }
    NSLog(@"%@",sender);
}
-(void)viewWillAppear:(BOOL)animated{
    APPDELEGATE.SW=NO;
    headvc.hidden=NO;
}
-(void)creathead{
    headvc=[[[NSBundle mainBundle]loadNibNamed:@"UpdateHeadiew" owner:self options:nil]objectAtIndex:0];
    headvc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 62);
    [self.tabBarController.view addSubview:headvc];
}
-(void)ReturnBUtton{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
