//
//  SYJOrdderTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/2.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJOrdderTableViewController.h"
#import "AFNetworking.h"
#import "SYJorderCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "SYJorderheade.h"
#import "SYJBaybyTableViewController.h"
#import "SYJDetailTableViewController.h"
#import "SYJHeadView.h"
#import "SYJHeadView.h"
#import "SYJCommentTableViewController.h"
#import "SYJSurePaymoneyViewController.h"
#import "SYJLoginViewController.h"
#import "SYJMyOrderView.h"
@interface SYJOrdderTableViewController ()<headviewDelegate>
{
    NSMutableArray *orderarr;
    NSMutableArray *babyarr;
    NSMutableArray * arrr;
    NSDictionary *dicc;
    SYJorderCell *cell;
    NSDictionary *yparr;
    SYJorderheade *vc;
    NSMutableArray *idarr;
      int i;
    UIImageView *imgview;
    UILabel *lable;
    NSString *two;
    NSString *statues;
    UIView *view;
    NSString *takegoods;
    NSDictionary *dic;
    NSMutableArray *statuesarr;
    NSMutableArray *Address;
    SYJHeadView *headview;
    NSMutableArray *orderstatues;
    int j;
    UIButton *bt;
    SYJMyOrderView *headVc;
    __weak IBOutlet UIActivityIndicatorView *loadClict;
    
}
@end

@implementation SYJOrdderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderarr=[NSMutableArray array];
    babyarr=[NSMutableArray array];
    arrr=[NSMutableArray array];
    idarr=[NSMutableArray array];
    statuesarr=[NSMutableArray array];
    Address=[NSMutableArray array];
    
     [self yprequest];
    
    i=1;
    j=0;
    self.tableView.tableFooterView=[[UIView alloc]init];
       [self.tableView addSubview:view];
     imgview=[[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 100, 100)];
    headview=[[[NSBundle mainBundle]loadNibNamed:@"SYJHeadView" owner:self options:nil]objectAtIndex:0];
    headview.delegate=self;
    self.tableView.tableHeaderView=headview;
     self.tableView.tableFooterView=[[UIView alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReturnButton) name:@"order" object:nil];
  [self creathead];
    [loadClict startAnimating];
    self.tableView.showsVerticalScrollIndicator=NO;
}

-(void)requestt{
    self.tableView.separatorStyle=YES;
    [imgview removeFromSuperview];
    [lable removeFromSuperview];
     [self yprequest];
   }
-(void)one{
     self.tableView.separatorStyle=YES;
    [imgview removeFromSuperview];
    [lable removeFromSuperview];
    [self yprequesttwo];
}

-(void)requesttwo{
     self.tableView.separatorStyle=YES;
    [imgview removeFromSuperview];
    [lable removeFromSuperview];
    [self yprequesttwo];
}
-(void)requeststree{
     self.tableView.separatorStyle=YES;
    [imgview removeFromSuperview];
    [lable removeFromSuperview];
    [self yprequestStree];
    
    }
-(void)requestfore{
   
     self.tableView.separatorStyle=YES;
    [imgview removeFromSuperview];
    [lable removeFromSuperview];
 
    [self yprequestfore];
    
}
-(void)Nogoods{
    
    
    self.tableView.separatorStyle=NO;
   imgview=[[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 100, 100)];
        
    imgview.image=[UIImage imageNamed:@"store"];
        
    lable=[[UILabel alloc]initWithFrame:CGRectMake(70, 300, 300, 70)];
    lable.text=@"什么都没有赶紧去逛逛吧！";
    [self.tableView addSubview:lable];
        
    [self.tableView addSubview:imgview];
        
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)yprequest{
  // NSUInteger ID=11;
  
    NSString *path=[[NSString alloc]initWithFormat:@"%@userId=%lu&&ordertakegoods=%",korderr,APPDELEGATE.user.userID];
    NSURL *url=[NSURL URLWithString:path];
    NSOperationQueue *dui=[NSOperationQueue mainQueue];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:dui completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *JSOn=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        yparr=[JSOn objectForKey:@"data"];
     
       
        [self.tableView reloadData];
        if(yparr.count==1){
            [self Nogoods];
        }
    }];
    [loadClict stopAnimating];
    loadClict.hidden=YES;
}


//设置订单数 分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return [yparr[@"storeCount"] intValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *rowNum=[NSString stringWithFormat:@"store_good_count%lu",section];
    NSString *rowCount=yparr[rowNum];
    
    return [rowCount intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   cell=[tableView dequeueReusableCellWithIdentifier:@"goods" forIndexPath:indexPath];
     NSString *currentarr=[[NSString alloc]initWithFormat:@"store_goodDetail%lu",indexPath.section];//第一次0
    arrr=[yparr objectForKey:currentarr];//根据key的值获取到当前店铺下面的所有宝贝
    
    dic=[arrr objectAtIndex:indexPath.row];
  
    cell.goodname.text=[dic objectForKey:@"order_goodsname"];
     NSString *price=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"order_goodsprice"]];
    cell.pricelable.text=price;
    NSString *imageurl=[[NSString alloc]initWithFormat:@"%@%@",kscrollview,[dic objectForKey:@"order_goodsimage"]];
    NSURL *goodsimg=[NSURL URLWithString:imageurl];
    [cell.goodimage setImageWithURL:goodsimg];
   
    
    [idarr addObject:[dic objectForKey:@"order_goods_id"]];
    i++;
    
    [Address addObject:[dic objectForKey:@"order_adressname"]];
    [statuesarr addObject:[dic objectForKey:@"order_takegoods"]];
    
   bt=[[UIButton alloc]initWithFrame:CGRectMake(220, 55, 80, 20)];
    
    int orderid=[[dic objectForKey:@"order_id"] intValue];
    bt.tag=orderid;
    j++;
    cell.tag=orderid;
    bt.titleLabel.text=nil;
    [bt setTitle:[dic objectForKey:@"order_status"] forState:UIControlStateNormal];
  // bt.titleLabel.textColor=[UIColor blackColor];
    [bt.titleLabel setTextColor:[UIColor blackColor]];
     bt.backgroundColor=[UIColor blackColor];
    UIColor *customColor=[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    bt.backgroundColor=customColor;
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont systemFontOfSize:12];
    [bt addTarget:self action:@selector(sendEvent:) forControlEvents:UIControlEventTouchDown];
    [cell addSubview:bt];
   
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    vc=[[[NSBundle mainBundle]loadNibNamed:@"SYJorderheade" owner:self options:nil]objectAtIndex:0];
    NSString *keystore=[NSString stringWithFormat:@"store%lu",section];
   
    vc.storeNamelable.text=[yparr objectForKey:keystore];
    
    return vc;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYJorderCell *celll=(SYJorderCell*)[tableView cellForRowAtIndexPath:indexPath];
  int current=(int)celll.tag;
  SYJDetailTableViewController *vcc= [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    vcc.oderid=current;
    
    [self.navigationController pushViewController:vcc animated:YES];
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 33;
    
}


-(void)yprequesttwo{
    
    
    NSString *path=[[NSString alloc]initWithFormat:@"%@userId=%lu&&ordertakegoods=2",korderr,APPDELEGATE.user.userID];
    NSURL *url=[NSURL URLWithString:path];
    NSOperationQueue *dui=[NSOperationQueue mainQueue];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:dui completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *JSOn=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        yparr=[JSOn objectForKey:@"data"];
        
        
        [self.tableView reloadData];
        if(yparr.count==1){
            [self Nogoods];
        }
        
    }];
    
}
-(void)yprequestStree{
    NSUInteger ID=11;
    
    NSString *path=[[NSString alloc]initWithFormat:@"%@userId=%lu&&ordertakegoods=3",korderr,APPDELEGATE.user.userID];
    NSURL *url=[NSURL URLWithString:path];
    NSOperationQueue *dui=[NSOperationQueue mainQueue];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:dui completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *JSOn=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        yparr=[JSOn objectForKey:@"data"];
       
        
        if(yparr.count==1){
            [self Nogoods];
        }
 [self.tableView reloadData];
    }];
    
}
-(void)yprequestfore{
   
    NSString *path=[[NSString alloc]initWithFormat:@"%@userId=%lu&&ordertakegoods=4",korderr,APPDELEGATE.user.userID];
    NSURL *url=[NSURL URLWithString:path];
    NSOperationQueue *dui=[NSOperationQueue mainQueue];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:dui completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *JSOn=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        yparr=[JSOn objectForKey:@"data"];
         
        
        [self.tableView reloadData];
        if(yparr.count==1){
            [self Nogoods];
        }
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    headVc.hidden=YES;
    [view removeFromSuperview];
   self.navigationController.view.hidden=NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=NO;
    headview.hidden=NO;
    headVc.hidden=NO;
}
-(void)Nobabyview{
    self.tableView.separatorStyle=NO;
}

- (IBAction)StatuesButton:(UIButton *)sender {
    NSString *str=[statuesarr objectAtIndex:sender.tag];
    NSLog(@"%@",str);
    
}
-(void)sendEvent:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    if([sender.titleLabel.text isEqualToString:@"去评价"]){
    SYJCommentTableViewController *vccc=[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    vccc.Commentgoodsid=[NSString stringWithFormat:@"%ld",sender.tag];
            [self.navigationController pushViewController:vccc animated:YES];
        }
    else if ([sender.titleLabel.text isEqualToString:@"去收货"]){
                SYJSurePaymoneyViewController *play=[self.storyboard instantiateViewControllerWithIdentifier:@"play"];
                play.goodsid=[NSString stringWithFormat:@"%ld",sender.tag];//dingdan id chuang guo qu
                [self.navigationController pushViewController:play animated:YES];
                
            }
    else{
        NSLog(@"no");
    }
    
}
-(void)ReturnButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creathead{
headVc=[[[NSBundle mainBundle]loadNibNamed:@"SYJMyOrderView" owner:self options:nil]objectAtIndex:0];
    headVc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 62);
    [self.navigationController.view addSubview:headVc];
}

@end
