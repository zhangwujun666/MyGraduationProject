//
//  SYJaddressmangerTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/12.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJaddressmangerTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SYJAddressMangerTableViewCell.h"
#import "SYJAddAddressTableViewController.h"
#import "SYJAdddizhi.h"
#import "AddressHeadView.h"
@interface SYJaddressmangerTableViewController ()
{
    NSMutableArray *arr;
    SYJAddressMangerTableViewCell *cell;
    NSDictionary *dic;
    int i;
    NSMutableArray *addressid;
    SYJAddAddressTableViewController *vcc;
    SYJAdddizhi *vc;
    NSMutableArray *addId;
    NSMutableArray *name;
    NSMutableArray *addressname;
    NSMutableArray *shengshiqu;
    NSMutableArray *telephon;
    NSString *MRvalue;
    AddressHeadView *headvc;
}
@end

@implementation SYJaddressmangerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr=[NSMutableArray array];
    
    addressid=[NSMutableArray array];
    MRvalue=[[NSString string]init];
    i=1;
    
    vc=[[[NSBundle mainBundle]loadNibNamed:@"SYJAdddizhi" owner:self options:nil]objectAtIndex:0];
    vc.frame=CGRectMake(5, 530, [UIScreen mainScreen].bounds.size.width-10, 35);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Address) name:@"address" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReturnButton) name:@"AddressHeadView" object:nil];
    self.tableView.tableFooterView=[[UIView alloc] init];
    vc.layer.cornerRadius=8;
   [self.tabBarController.view addSubview:vc];
    self.tabBarController.tabBar.hidden=YES;
    [self creathead];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)Address{
    
    APPDELEGATE.SW=YES;
  vcc=[self.storyboard instantiateViewControllerWithIdentifier:@"addaddress"];
    [self.navigationController  pushViewController:vcc animated:YES];
}
-(void)request{
    NSString *str=[NSString stringWithFormat:@"%@%lu",kaddress,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
       dic=(NSDictionary*)responseObject;
       arr=[dic objectForKey:@"data"];
        [self.tableView reloadData];//这个不能丢
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *str=[NSString stringWithFormat:@"%@",arr];
    
    if([str isEqualToString:@"NULL"]){
        return 0;
    }
    else{
    return arr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   cell = [tableView dequeueReusableCellWithIdentifier:@"adress" forIndexPath:indexPath];

     arr=[dic objectForKey:@"data"];
    NSDictionary *dicc=[arr objectAtIndex:indexPath.row];
    NSLog(@"%@",arr);
    NSString *str=[NSString stringWithFormat:@"%@%@",[dicc objectForKey:@"useraddress_shengshiqu"],[dicc objectForKey:@"useradress_name"]];
    cell.addresslable.text=str;
    cell.Username.text=[dicc objectForKey:@"adress_name"];
    cell.Telephon.text=[dicc objectForKey:@"useraddress_telephon"];
    
    cell.tag=i;
    i++;
    NSLog(@"%@",[dicc objectForKey:@"useraddress_id"]);
    [addressid addObject:[dicc objectForKey:@"useraddress_id"]];
    
    [addressname addObject:[dicc objectForKey:@"useradress_name"]];
    [telephon addObject:[dicc objectForKey:@"useraddress_telephon"]];
    [name addObject:[dicc objectForKey:@"adress_name"]];
    [shengshiqu addObject:[dicc objectForKey:@"useraddress_shengshiqu"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
       
      NSString *adressid=[addressid objectAtIndex:indexPath.row];
        
         NSString *str=[NSString stringWithFormat:@"%@userid=%lu&&adressid=%@",Kdelecadress,APPDELEGATE.user.userID,adressid];
        AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
        [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self request];
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
      
           }
   
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *diccc=[arr objectAtIndex:indexPath.row];
    MRvalue=[diccc objectForKey:@"mraddress"];
    SYJAddAddressTableViewController *AddAdress=[self.storyboard instantiateViewControllerWithIdentifier:@"addaddress"];
    AddAdress.addid=[addressid objectAtIndex:indexPath.row];
    AddAdress.telephon=[telephon objectAtIndex:indexPath.row];
    AddAdress.name=[name objectAtIndex:indexPath.row];
    AddAdress.addressname=[addressname objectAtIndex:indexPath.row];
    AddAdress.shenshiqu=[shengshiqu objectAtIndex:indexPath.row];
    AddAdress.MR=MRvalue;
    [self.navigationController pushViewController:AddAdress animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
   addressid=[NSMutableArray array];
    shengshiqu=[NSMutableArray array];
    telephon=[NSMutableArray array];
    addressname=[NSMutableArray array];
    name=[NSMutableArray array];
    vc.hidden=NO;
    headvc.hidden=NO;
    [self request];
   }
-(void)viewWillDisappear:(BOOL)animated{
    vc.hidden=YES;
    headvc.hidden=YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除地址";
}
-(void)ReturnButton{
    [self.navigationController popViewControllerAnimated:YES];
  
}
-(void)creathead{
    headvc=[[[NSBundle mainBundle]loadNibNamed:@"AddressHeadView" owner:self options:nil]objectAtIndex:0];
    headvc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 63);
      [self.tabBarController.view addSubview:headvc];
}
@end
