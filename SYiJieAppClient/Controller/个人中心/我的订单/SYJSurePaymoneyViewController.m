//
//  SYJSurePaymoneyViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/21.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSurePaymoneyViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface SYJSurePaymoneyViewController (){
    NSString *goodsid;
}
@property (weak, nonatomic) IBOutlet UILabel *goodsname;
@property (weak, nonatomic) IBOutlet UILabel *goodprice;

@end

@implementation SYJSurePaymoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *hand=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(YinChan)];
    hand.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:hand];
    [self requsetordergoodsid];
    //[self requestbabyShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requsetordergoodsid{
  
    {
        
        NSString *str=[NSString stringWithFormat:@"%@%@",krequertgoods,self.goodsid];//
        AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
        [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功");
            NSDictionary *dicc=(NSDictionary *)responseObject;
            NSDictionary *dic=[dicc objectForKey:@"orderlist"];
            goodsid=[dic objectForKey:@"order_goods_id"];
            [self requestbabyShow];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
}


-(void)requestbabyShow{
    
  NSString *str=[NSString stringWithFormat:@"%@%@",krequertgoods,self.goodsid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        NSDictionary *dicc=(NSDictionary *)responseObject;
        NSDictionary *dic=[dicc objectForKey:@"orderlist"];
        self.goodsname.text=[dic objectForKey:@"order_goodsname"];
        NSString *price=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"order_goodsprice"]];
        self.goodprice.text=price;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)PayMoneyButton:(UIButton *)sender {
    NSLog(@"%@",self.pasward.text);
    if ([self.pasward.text isEqualToString:@""]) {
        UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:nil message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tishi show];
    }
    else{
        [self requestchangstatus];
        UILabel *tishi=[[UILabel alloc]initWithFrame:CGRectMake(120, 400, 100, 30)];
        [tishi setText:@"您已确认收货"];
        tishi.backgroundColor=[UIColor blackColor];
        tishi.font=[UIFont systemFontOfSize:12];
        tishi.textAlignment=NSTextAlignmentCenter;
        tishi.textColor=[UIColor whiteColor];
        tishi.layer.cornerRadius=10;
        [tishi.layer setCornerRadius:20.0];
        [self.navigationController.view addSubview:tishi];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [UIView animateWithDuration:1.5 animations:^{
            tishi.alpha=0;
        }
                         completion:^(BOOL finished) {
                             [tishi removeFromSuperview];
                             
                         }];

    }
}
- (IBAction)Return:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestchangstatus{
    NSString *str=[NSString stringWithFormat:@"%@%@",kchangestatue,self.goodsid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"333失败");
    }];
}
-(void)YinChan{
    [self.view endEditing:YES];
}
@end
