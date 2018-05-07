//
//  SYJshopTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJshopTableViewController.h"
#import "SYJuserTableViewCell.h"
#import "SYJstoreTableViewCell.h"
#import "SYJyunfeiTableViewCell.h"
#import "SYJgoodspriceTableViewCell.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SYJsubmitshopview.h"
#import "SYJnumberTableViewCell.h"
#import "SYJGood.h"
#import "SYJStore.h"
#import "SYJgoodTableViewCell.h"
@interface SYJshopTableViewController (){
   
    SYJsubmitshopview *vc;
    NSString *totaillprice;
    int babyidd;
    
    NSDictionary *useridress;
    NSMutableArray *goods;
    int alllepirce;
    int  allprice;
    SYJuserTableViewCell *cel;
    SYJGood *good;
    
}

@end

@implementation SYJshopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vc=[[[NSBundle mainBundle]loadNibNamed:@"SYJsubmitshopview" owner:self options:nil]objectAtIndex:0];
    vc.frame=CGRectMake(0, 500, 400, 80);
    [self.tabBarController.view addSubview:vc];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Sumbits) name:@"twosubmits" object:nil];
    goods=[NSMutableArray array];
    
    //隐藏多余的tableView的框线
    self.tableView.tableFooterView=[[UIView alloc] init];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    #pragma mark-让分割线置顶
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [cel.loadClict startAnimating];
   
    [self arrrequers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)arrrequers{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //发送一个请求,传输数组
    //NSArray *arr=[NSArray arrayWithObjects:@"AA",@"BB",@"CC",@"DD",@"EE",nil];
  
    //NSDictionary *parameter=@{
//                              @"userId":@(11),
//                              @"goodsArray":APPDELEGATE.selectid
//                              };
    NSString *url=[NSString stringWithFormat:@"%@%ld",kGetAddress,APPDELEGATE.user.userID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"%@",dic[@"data"]);
            useridress=[dic objectForKey:@"data"];
            [cel.loadClict stopAnimating];
            cel.loadClict.hidden=YES;
            
            [self.tableView reloadData];
        }else{
            NSLog(@"获取网络数据失败!");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题!");
    }];
}
-(void)goodsrow{
    for (int u=0; u<APPDELEGATE.selectid.count; u++) {
      NSNumber *babyid=[APPDELEGATE.selectid objectAtIndex:u];
        babyidd=[babyid intValue];
      //  [self requestuserinfotwo];
        
    }
//   [self.tableView reloadData];
}
#pragma mark - Table view data source
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if(goods==nil||goods.count==0||goods.class==[NSNull class]){
//    return 0;
//    }
//    else{
        return 3;
    //}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 1;
    }
    else if (section==1) {
        if (APPDELEGATE.cartCalculateArray==nil||APPDELEGATE.cartCalculateArray.count==0||APPDELEGATE.cartCalculateArray.class==[NSNull class]) {
            return  0;
        }else{
            return APPDELEGATE.cartCalculateArray.count;
        }
    }
    else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){//地址模块
        
        SYJgoodTableViewCell *celll=[tableView dequeueReusableCellWithIdentifier:@"one" forIndexPath:indexPath];
    
         NSString *useraddress=[NSString stringWithFormat:@"%@%@",[useridress objectForKey:@"useraddress_shengshiqu"],[useridress objectForKey:@"useradress_name"]];
        celll.name.text=[useridress objectForKey:@"adress_name"];
    celll.telephon.text=[useridress objectForKey:@"useraddress_telephon"];
        celll.address.text=useraddress;
        return celll;
    
    }
   else if(indexPath.section==1){//店铺模块

            SYJGood *good=[APPDELEGATE.cartCalculateArray objectAtIndex:indexPath.row];
       
           cel=[tableView dequeueReusableCellWithIdentifier:@"stree" forIndexPath:indexPath];
          
       cel.goodsname.text=good.car_namegoods;
            cel.size.text=good.car_sizegood;
            cel.colour.text=good.car_colourgood;
             NSString *price=[NSString stringWithFormat:@"商品单价:￥%d.00",good.car_pricegoods];
            cel.prcie.text=price;
       NSString *path=[NSString stringWithFormat:@"%@%@",kscrollview,good.car_imagegoods];
       [cel.goodsimage setImageWithURL:[NSURL URLWithString:path]];
  
            allprice+=good.car_pricegoods*good.car_numbercar;
            return cel;
    }else{
       if(indexPath.row==0){//运费模块
            //NSDictionary *goodsdic=[goods objectAtIndex:indexPath.row];
           SYJyunfeiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"fore" forIndexPath:indexPath];
            NSString *yunfei=[NSString stringWithFormat:@"￥%d.00",5];
           //NSString *str=[NSString stringWithFormat:@"%d",5];
           //int freight=[str intValue];
           cell.yunfei.text=yunfei;
           //vc.playmoney.text=[NSString stringWithFormat:@"￥%d.00",allprice+freight];
           return cell;
       }
       else if(indexPath.row==1){              //商品总价模块
           SYJgoodspriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"fin" forIndexPath:indexPath];
           int sum=0;
           for (SYJGood *good in APPDELEGATE.cartCalculateArray) {
               sum+=good.car_pricegoods*good.car_numbercar;
           }
           cell.price.text=[NSString stringWithFormat:@"￥%d.00",sum];
           sum+=5;
           vc.playmoney.text=[NSString stringWithFormat:@"￥%d.00",sum];
        return cell;
       }
       else{
           SYJnumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"six" forIndexPath:indexPath];
           int sum=0;
           for (SYJGood *good in APPDELEGATE.cartCalculateArray) {
               sum+=good.car_numbercar;
           }
           
           NSString *goodsnumber=[NSString stringWithFormat:@"%d件",sum];
           cell.number.text=goodsnumber;
           return cell;
       }
   }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }
    else if(indexPath.section==1){
//        if(indexPath.row==0){
//            return 30;
//        }
//        else{
            return 120;
//        }
    
    }
    else{
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    vc.hidden=YES;
}
-(void)Sumbits{
  [self addorderRequest];
    [self remeberlablee];
}
-(void)addorderRequest{
    for(int i=0;i<APPDELEGATE.pathArray.count;i++){
        NSIndexPath *path=[APPDELEGATE.pathArray objectAtIndex:i];
     SYJStore  *store=[APPDELEGATE.cartstorearr objectAtIndex:path.section];
        good=[store.goodArray objectAtIndex:path.row];
        NSNumber *userid=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
        NSNumber *goodsprice=[NSNumber numberWithInt:good.car_pricegoods];
        NSNumber *goodsid=[NSNumber numberWithInt:good.car_cargoods_id];
        NSNumber *storeid=[NSNumber numberWithInt:good.car_store_id];
         NSString *useraddress=[NSString stringWithFormat:@"%@%@",[useridress objectForKey:@"useraddress_shengshiqu"],[useridress objectForKey:@"useradress_name"]];
        NSDictionary *orderinfo=@{@"user_id":userid,
                                  @"storename":store.storeName,
                                  @"order_store_id":storeid,
                                  @"order_goodsimage":good.car_imagegoods,
                                   @"order_goodsname":good.car_namegoods,
                                  @"order_goodsprice":goodsprice,
                                  @"order_goods_id":goodsid,
                                  @"order_goodssize":good.car_sizegood,
                                  @"order_goodcolour":good.car_colourgood,
                                  @"order_username":[useridress objectForKey:@"adress_name"],
                                  @"order_adressname":useraddress,
                                  @"order_addresstelephone":[useridress objectForKey:@"useraddress_telephon"]};
        NSLog(@"000000%@",orderinfo) ;
    
            AFHTTPRequestOperationManager* manger=[AFHTTPRequestOperationManager manager];
            [manger POST:kaddorder parameters:orderinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"100");
            }];
        [self DelectCarGood];
        }
    
    self.tabBarController.selectedIndex=4;
    [self.navigationController popToRootViewControllerAnimated:YES];
    vc.hidden=YES;
}
-(void)DelectCarGood{
    NSString *str=[NSString stringWithFormat:@"%@%@",delectcargoodis,good.car_id];
    AFHTTPRequestOperationManager *mangerrr=[AFHTTPRequestOperationManager manager];
    [mangerrr GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"shibai");
    }];
}
-(void)remeberlablee{
    UILabel *tishi=[[UILabel alloc]initWithFrame:CGRectMake(120, 400, 100, 30)];
    [tishi setText:@"您已确认收货"];
    tishi.backgroundColor=[UIColor blackColor];
    tishi.font=[UIFont systemFontOfSize:12];
    tishi.textAlignment=NSTextAlignmentCenter;
    tishi.textColor=[UIColor whiteColor];
    tishi.layer.cornerRadius=10;
    [tishi.layer setCornerRadius:20.0];
    [self.navigationController.view addSubview:tishi];
    self.tabBarController.selectedIndex=4;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [UIView animateWithDuration:1.5 animations:^{
        tishi.alpha=0;
    }
                     completion:^(BOOL finished) {
                         [tishi removeFromSuperview];
                         
                     }];

}
@end
