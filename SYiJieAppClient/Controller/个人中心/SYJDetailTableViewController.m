//
//  SYJDetailTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/10.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJDetailTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "SYJBaybyTableViewController.h"
#import "SYJCommentTableViewController.h"
#import "SYJSurePaymoneyViewController.h"
#import "OrderDetailView.h"
@interface SYJDetailTableViewController (){
     SYJBaybyTableViewController *vcc;
    NSDictionary *dicdata;
    OrderDetailView *headVc;
    
    __weak IBOutlet UIActivityIndicatorView *loadClict;
}
@property (weak, nonatomic) IBOutlet UIButton *StatusButton;

@end

@implementation SYJDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
    self.StatusButton.layer.cornerRadius=8;
    self.addree.text=self.address;
    dicdata=[[NSDictionary alloc]init];
    [loadClict startAnimating];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReutrnButton) name:@"OrderDetailView" object:nil];
    [self creathead];
}
-(void)creathead{
    headVc=[[[NSBundle mainBundle]loadNibNamed:@"OrderDetailView" owner:self options:nil]objectAtIndex:0];
    headVc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 62);
    [self.tabBarController.view addSubview:headVc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(void)request{
    NSString *JSon=[NSString stringWithFormat:@"%@%d",kselcetorderdetail,self.oderid];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:JSon parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
       
        NSDictionary *dic=(NSDictionary *)responseObject;
        dicdata=[dic objectForKey:@"data"];
        self.BabyName.text=[dicdata objectForKey:@"order_goodsname"];
        NSString *price=[NSString stringWithFormat:@"￥%@.00",[dicdata objectForKey:@"order_goodsprice"]];
        self.BabyPrice.text=price;
        self.StoreName.text=[dicdata objectForKey:@"order_storename"];
        self.OrderTime.text=[dicdata objectForKey:@"order_pruducttime"];
        self.colour.text=dicdata[@"order_goodcolour"];
        self.size.text=dicdata[@"order_goodssize"];
        self.username.text=dicdata[@"order_username"];
        self.usertelephon.text=dicdata[@"order_addresstelephone"];
        self.ordernumber.text=dicdata[@"order_number"];
        NSString *ordertime=[NSString stringWithFormat:@"%@",[dicdata objectForKey:@"order_pruducttime"]];
        int turntime=[ordertime intValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//初始化时间格式
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:turntime];//时间戳转时间
        NSString* dateString = [formatter stringFromDate:confromTimesp];//给时间设置格式
        self.OrderTime.text=dateString;
        
        if ([dicdata[@"order_takegoods"] isEqualToString:@"3"]) {
            NSString *str=[NSString stringWithFormat:@"赶快去评价吧"];
            self.gocomment.text=str;
        }
        else if ([dicdata[@"order_takegoods"]  isEqualToString:@"2"]){
            NSString *str=[NSString stringWithFormat:@"前往确认收货"];
          self.gocomment.text=str;
        }
        else{
            NSString *str=[NSString stringWithFormat:@"已完成"];
            self.gocomment.text=str;
        }
       // self.StatusButton.titleLabel.text=[dicdata objectForKey:@"order_status"];
      // self.addree.text=[dicdata objectForKey:@"order_address_id"]
        NSString *str=[NSString stringWithFormat:@"%@%@",kscrollview,[dicdata objectForKey:@"order_goodsimage"]];
        NSURL *url=[NSURL URLWithString:str];     
        [self.BabyImage setImageWithURL:url ];
        [self.tableView reloadData];
        [loadClict stopAnimating];
        loadClict.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
    if(indexPath.row==0){
    vcc=[[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil]instantiateViewControllerWithIdentifier:@"baby"];
       
       vcc.idd=dicdata[@"order_goods_id"];
       
        [self.navigationController pushViewController:vcc animated:YES];
    }
    }
}
- (IBAction)statuseButton:(UIButton *)sender {
    if([dicdata[@"order_takegoods"] isEqualToString:@"3"]){
    SYJCommentTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    vc.Commentgoodsid=dicdata[@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
    }
    if([dicdata[@"order_takegoods"]isEqualToString:@"2"]){
        SYJSurePaymoneyViewController *vctwo=[self.storyboard instantiateViewControllerWithIdentifier:@"play"];
        [self.navigationController pushViewController:vctwo animated:YES];
        vctwo.goodsid=dicdata[@"order_goods_id"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.hidden=NO;
    headVc.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    headVc.hidden=YES;
}
-(void)ReutrnButton{
   
    [self.navigationController popViewControllerAnimated:YES];
}



@end
