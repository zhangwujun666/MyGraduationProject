//
//  SYJShopdetailTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJShopdetailTableViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "SYJsubmitshopview.h"
#import "SYJPersonalTableViewController.h"
@interface SYJShopdetailTableViewController (){
    SYJsubmitshopview *vc;
    NSDictionary *dic;
    NSDictionary *userinfo;
    NSDictionary *StoreInfo;
    NSDictionary *goodinfo;
    
    __weak IBOutlet UIActivityIndicatorView *LoadClict;
}

@end

@implementation SYJShopdetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vc=[[[NSBundle mainBundle]loadNibNamed:@"SYJsubmitshopview" owner:self options:nil]objectAtIndex:0];
    vc.frame=CGRectMake(0, 500, 400, 80);
   
    [self.tabBarController.view addSubview:vc];
    [self requestuserinfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(submits) name:@"submits" object:nil];
    dic=[[NSDictionary alloc]init];
    userinfo=[[NSDictionary alloc]init];
    goodinfo=[[NSDictionary alloc]init];
    StoreInfo=[[NSDictionary alloc]init];
    [LoadClict startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestuserinfo{
// 根据用户和宝贝获取信息，店铺信息是通过宝贝信息得到的
    NSString *str=[NSString stringWithFormat:@"%@userId=%lu&goodId=%@",ksubmite,APPDELEGATE.user.userID,self.goodsid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        dic=(NSDictionary *)responseObject;
       userinfo=[dic objectForKey:@"userInfo"];
        goodinfo=[dic objectForKey:@"goodInfo"];
       StoreInfo=[dic objectForKey:@"storeInfo"];
        self.storename.text=[StoreInfo objectForKey:@"store_name"];
        NSString *useraddress=[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"useraddress_shengshiqu"],[userinfo objectForKey:@"useradress_name"]];
        self.username.text=[userinfo objectForKey:@"adress_name"];
        self.useraddress.text=useraddress;
        self.usertelephon.text=[userinfo objectForKey:@"useraddress_telephon"];
        NSString *yunfei=[NSString stringWithFormat:@"￥%@.00",[goodinfo objectForKey:@"goods_freight"]];
        self.yunmoney.text=yunfei;
        self.goodsname.text=[goodinfo objectForKey:@"goods_name"];
        NSString *price=[NSString stringWithFormat:@"商品单价:￥%@.00",[goodinfo objectForKey:@"goods_price"]];
        self.goodsprice.text=price;
        NSString *goodsnumber=[NSString stringWithFormat:@"%@件",APPDELEGATE.shopnumber];
        NSString *size=[NSString stringWithFormat:@"尺码：%@",self.size];
    NSString *colour=[NSString stringWithFormat:@"尺码：%@",self.colour];
        self.goodsnuber.text=goodsnumber;
        self.goodssize.text=size;
        self.goodscolour.text=colour;
        int number=[APPDELEGATE.shopnumber intValue];
        int pricee=[[goodinfo objectForKey:@"goods_price"] intValue];
        int yf=[[goodinfo objectForKey:@"goods_freight"] intValue];
        int totail=number*pricee+yf;
        int totaill=number*pricee;
        NSString *totailprice=[NSString stringWithFormat:@"￥%d.00",totaill];
        self.zgoodsmoney.text=totailprice;
        vc.playmoney.text=[NSString stringWithFormat:@"￥%d.00",totail];
         NSString *imageurl=[[NSString alloc]initWithFormat:@"%@%@",kscrollview,[goodinfo objectForKey:@"goods_image"]];
        NSURL *url=[NSURL URLWithString:imageurl];
        [self.goodiamge sd_setImageWithURL:url];
        [LoadClict stopAnimating];
        LoadClict.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
- (IBAction)Return:(UIButton *)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [vc removeFromSuperview ];
 
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    else if(section==1){
        return 2;
    }
    else{
        return 3;
    }
}
-(void)addorderRequest{
    NSNumber *userid=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
    NSDictionary *orderinfo=@{@"user_id":userid,
                        @"storename":[StoreInfo objectForKey:@"store_name"],
                        @"order_goodsimage":[goodinfo objectForKey:@"goods_image"],
                        @"order_goodsname":[goodinfo objectForKey:@"goods_name"],
                        @"order_goodsprice":[goodinfo objectForKey:@"goods_price"],
                        @"order_store_id":[StoreInfo objectForKey:@"store_id"],
                        @"order_goods_id":goodinfo[@"goods_id"],
                        @"order_adressname":[userinfo objectForKey:@"useraddress_shengshiqu"],
                        @"order_goodssize":self.size,
                        @"order_goodcolour":self.colour,
                        @"order_addresstelephone":[userinfo objectForKey:@"useraddress_telephon"],
                        @"order_username":[userinfo objectForKey:@"useradress_name"]};
    AFHTTPRequestOperationManager* manger=[AFHTTPRequestOperationManager manager];
    [manger POST:kaddorder parameters:orderinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"200");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"100");
    }];
}


-(void)remeberlable{
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

-(void)submits{
 [self addorderRequest];
    self.tabBarController.selectedIndex=4;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self remeberlable];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
