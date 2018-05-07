//
//  SYJCollectTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCollectTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SYJCollectTableViewCell.h"
#import "SYJCollectView.h"
#import "SYJStoreViewController.h"
@interface SYJCollectTableViewController ()<UIAlertViewDelegate>{
    NSMutableArray *CollectInfo;
    NSMutableArray *StoreInfo;
    SYJCollectView *headVc;
    __weak IBOutlet UIActivityIndicatorView *loadClict;
    
}

@end

@implementation SYJCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    CollectInfo=[NSMutableArray array];
    StoreInfo=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(retuenButton) name:@"ReturnButton" object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(CancelCollect) name:@"cancel" object:nil];
    [self creathead];
    [self requestCollect];
    [loadClict startAnimating];
    
}
-(void)creathead{
   headVc=[[[NSBundle mainBundle]loadNibNamed:@"SYJCollectView" owner:self options:nil]objectAtIndex:0];
    headVc.frame=CGRectMake(0, 0, 320, 75);

    [self.tabBarController.view addSubview:headVc];
    
}
-(void)requestCollect{
    NSString *php=[NSString stringWithFormat:@"%@%lu",Kcollect,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:php parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        CollectInfo=[dic objectForKey:@"data"];
        StoreInfo=dic[@"storeinfo"];
        if([[dic objectForKey:@"code"] isEqualToString:@"500"]){
        [self isN0Collect];
        }
        else{
            [self.tableView reloadData];
        }
        [loadClict stopAnimating];
        loadClict.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"500");
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return CollectInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYJCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell" forIndexPath:indexPath];
    NSDictionary *storearr=[StoreInfo objectAtIndex:indexPath.row];
    cell.Storename.text=[NSString stringWithFormat:@"店铺：%@",[storearr objectForKey:@"store_name"]];
    cell.Stroeaddress.text=[NSString stringWithFormat:@"店铺地址：%@",[storearr objectForKey:@"store_place"]];
    NSString *str=[NSString stringWithFormat:@"%@%@",SYJHTTPSHOPIMG,[storearr objectForKey:@"store_logo"]];
    NSURL *url=[NSURL URLWithString:str];
    cell.Cancel.tag=[[storearr objectForKey:@"store_id"]intValue];
    [cell.StoreImage setImageWithURL:url];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *selectarr=[StoreInfo objectAtIndex:indexPath.row];
    SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
    NSString * storeid=[selectarr objectForKey:@"store_id"];
    storeVC.storeId = [storeid intValue];
    [self.navigationController pushViewController:storeVC animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
   // self.navigationController.navigationBar.hidden=YES;
//    self.tabBarController.tabBar.hidden=YES;
//    self.navigationController.tabBarController.tabBar.hidden=YES;
    headVc.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    headVc.hidden=YES;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)retuenButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CancelColletcRequset{
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    NSString *path=[NSString stringWithFormat:@"%@Shop/addlike",SYJHTTP];
    NSDictionary *parameter=@{
                              @"userId":@(APPDELEGATE.user.userID),
                              @"storeId":@(APPDELEGATE.CollectStoreid)
                              };
    [manger GET:path parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
    }];
    
}
-(void)CancelCollect{
    UIAlertView *Cancel=[[UIAlertView alloc]initWithTitle:nil message:@"是否取消收藏" delegate:self cancelButtonTitle:@"是的" otherButtonTitles:@"不了",nil];
    [Cancel show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self CancelColletcRequset];
        [self requestCollect];
    }
    else if (buttonIndex==1){
        NSLog(@"点击了2");
    }
}
-(void)isN0Collect{
    UILabel *lable=[[UILabel alloc]init];
    lable.text=@"暂时还没有收藏，赶紧去逛逛吧";
    lable.frame=CGRectMake(60, 200, 400, 20);
   
    [self.tableView addSubview:lable];
}

@end
