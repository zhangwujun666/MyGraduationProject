//
//  SYJCarGoodsTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCarGoodsTableViewController.h"
#import "SYJCarcellTableViewCell.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SYJCustomview.h"
#import "SYJheaderView.h"
#import "SYJBaybyTableViewController.h"
#import "SYJSectionhead.h"
#import "SYJshopTableViewController.h"
#import "SYJGood.h"
#import "SYJStore.h"
#import "SYJLoginViewController.h"

@interface SYJCarGoodsTableViewController ()<SYJCustomvDeleate,SYjCelldeleate>
{
    SYJLoginViewController *loginVc;
    SYJCustomview *VC;
    NSDictionary *dicbaby;
    SYJCarcellTableViewCell *cell;
    NSMutableArray * arrr;
    SYJheaderView *headView;
    SYJSectionhead *SectionheadView;
    int i;
    NSMutableArray *idarr;
    NSMutableDictionary *dic;
    NSMutableArray *arr;
    UILabel *lable;
}

//@property (nonatomic,strong) NSMutableArray *goodArray;
@property (nonatomic,strong) NSMutableArray *storeArray;
@end

@implementation SYJCarGoodsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAllWidth, kAllHeight)];
//    self.view.backgroundColor = [UIColor whiteColor];
    arr=[NSMutableArray array];
    dic=[[NSMutableDictionary alloc]init];
    
    headView=[[[NSBundle mainBundle]loadNibNamed:@"headerView" owner:self options:nil]objectAtIndex:0];
    headView.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 65);
        [self.navigationController.view addSubview:headView];
    
    dicbaby=[[NSDictionary alloc]init];
    arrr=[NSMutableArray array];
    idarr=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBedge:) name:@"name" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Returndetail) name:@"return" object:nil];
    i=1;
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 30.0f;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f, navBarHeight);
    [bar setFrame:frame];
    
    lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, 400, 16)];
    lable.backgroundColor=[UIColor blackColor];
    lable.alpha=0.2;
    [bar addSubview:lable];
    [self creathead];
    //[self islogin];
    [self request];//地址请求
    self.navigationController.navigationBar.hidden=YES;
}

-(void)updateBedge:(NSNotification *)sender{
    NSString *goodprice=[NSString stringWithFormat:@"￥%d",APPDELEGATE.allprice];
    self.tabBarItem.badgeValue=@"2";
    VC.alltatolButton.text=goodprice;
}
-(void)request{
    
    NSString *str=[NSString stringWithFormat:@"%@%lu",kaddress,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        dic=(NSMutableDictionary *)responseObject;
        arr=[dic objectForKey:@"data"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

-(void)Returndetail{
//    if(APPDELEGATE.State1==YES){
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
//    SYJshopTableViewController *shopvc=[storyBoard instantiateViewControllerWithIdentifier:@"sp"];
//
//    [self.navigationController pushViewController:shopvc animated:YES];
//    }
//    else{
//        UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:@"请补充地址哦" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [tishi show];
//    }
    NSLog(@"%@",[dic objectForKey:@"data"]);
    
    if([[dic objectForKey:@"code"] isEqualToString:@"500"]&&APPDELEGATE.State1==YES){
        UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:@"请补充地址哦" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [tishi show];
    }
    else if (APPDELEGATE.State1==NO){
        UIAlertView *tishitwo=[[UIAlertView alloc]initWithTitle:@"请勾选宝贝" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
              [tishitwo show];
    }
    else{
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
            SYJshopTableViewController *shopvc=[storyBoard instantiateViewControllerWithIdentifier:@"sp"];
            
            [self.navigationController pushViewController:shopvc animated:YES];
    }
}
-(void)creathead{
    VC=[[[NSBundle mainBundle]loadNibNamed:@"SYJCustomview" owner:self options:nil]objectAtIndex:0];
    VC.frame=CGRectMake(0, 470, [[UIScreen mainScreen]bounds].size.width, 60);
    VC.deleate=self;
    
    [VC.selelcallButton setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:VC];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  请求购物车中的数据
 */
-(void)requersCar{
    __weak SYJCarGoodsTableViewController *weakSelf = self;
    self.storeArray=[NSMutableArray array];
    [self.storeArray removeAllObjects];
    APPDELEGATE.cartstorearr=[NSMutableArray array];
    APPDELEGATE.Carnumber=0;
    NSUInteger IDD=APPDELEGATE.user.userID;
    NSLog(@"%lu",APPDELEGATE.user.userID);
    NSString *path=[[NSString alloc]initWithFormat:@"%@%lu",kCar,IDD];
  
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result=(NSDictionary *)responseObject;
        NSString *code=result[@"code"];
        if ([code isEqualToString:@"200"]) {
            //获取当前的数据集
            dicbaby=result[@"data"];
            //获取店铺的数量
            int storeCount=[dicbaby[@"storeCount"] intValue];
            
            if (storeCount != 0) {
                if (weakSelf.noDataView!=nil) {
                    [weakSelf.noDataView removeFromSuperview];
                }
                VC.hidden = NO;
            }else{
                VC.hidden = YES;
                [self createNoDataLabel];
            }
            
            for (int m=0; m<storeCount; m++) {
                //获得店铺的名字
                NSString *storeNameKey=[NSString stringWithFormat:@"store%d",m];
                NSString *storeName=dicbaby[storeNameKey];
                //获得店铺的宝贝数量
                NSString *storeGoodCountKey=[NSString stringWithFormat:@"store_good_count%d",m];
                int storeGoodCount=[dicbaby[storeGoodCountKey] intValue];
                APPDELEGATE.Carnumber+=storeCount;
                //获得店铺的具体宝贝
                NSString *storeGoodArrayKey=[NSString stringWithFormat:@"store_goodDetail%d",m];
                NSArray *storeGoodArray=dicbaby[storeGoodArrayKey];
                NSLog(@"%@",storeGoodArray);
                //创建店铺
                
                SYJStore *store=[[SYJStore alloc] initWithStoreName:storeName andGoodCount:storeGoodCount andGoodArray:storeGoodArray];
                [APPDELEGATE.cartstorearr addObject:store];
                [self.storeArray addObject:store];
            }
            NSLog(@"%d",APPDELEGATE.Carnumber);
            [self.tableView reloadData];
        }else{
            NSLog(@"请求网络数据失败....");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题....");
    }];
}

//- (void)createNoDataLabel{
//    //首先隐藏tableView
//    //self.tableView.hidden = YES;
//    VC.hidden = YES;
//    
//    //创建
//    if (self.noDataLabel == nil) {
//        //创建背景视图
//        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAllWidth, kAllHeight)];
//        self.backView.backgroundColor = [UIColor whiteColor];
//        [self.tableView addSubview:self.backView];
//        
//        self.noDataLabel = [[UILabel alloc] init];
//        //宽度80，高度为40
//        CGFloat noDataW = kAllWidth;
//        CGFloat noDataH = 40;
//        CGFloat noDataX = 0;
//        CGFloat noDataY = 65 + 10.0;
//        self.noDataLabel.frame = CGRectMake(noDataX, noDataY, noDataW, noDataH);
//        self.noDataLabel.text = @"亲，你还没有宝贝哦，赶紧去购买吧~~";
//        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
//        self.noDataLabel.font = [UIFont systemFontOfSize:14];
//        //self.noDataLabel.backgroundColor = [UIColor yellowColor];
//        [self.backView addSubview:self.noDataLabel];
//    }
//}

//- (void)removeNoDataLabel{
//    //首先移除noDataLabel
//    if ((self.noDataLabel!=nil)&&(self.noDataLabel.hidden == NO)) {
//        [self.backView removeFromSuperview];
//    }
//    
//    //显示tableView
//    //self.tableView.hidden = YES;
//    VC.hidden = NO;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.storeArray==nil||self.storeArray.count==0||(self.storeArray.class==[NSNull class])) {
        return 0;
    }else{
        return self.storeArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SYJStore *store=[self.storeArray objectAtIndex:section];
    if (store.goodArray==nil||store.goodArray.count==0||(store.goodArray.class==[NSNull class])) {
        return 0;
    }else{
        return store.goodArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell=[tableView dequeueReusableCellWithIdentifier:@"car" forIndexPath:indexPath];
    //首先获取店铺
    //获取宝贝
    SYJStore *store=[self.storeArray objectAtIndex:indexPath.section];
    SYJGood *good=[store.goodArray objectAtIndex:indexPath.row];
    cell.priceLable.text = [NSString stringWithFormat:@"￥%d",good.car_pricegoods];
    cell.babynamelable.text=good.car_namegoods;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kscrollview,good.car_imagegoods]];
    [cell.babyimg sd_setImageWithURL:url];
    cell.Numberlable.text=[NSString stringWithFormat:@"%d",good.car_numbercar];
    cell.SIzeLble.text=good.car_sizegood;
    cell.ColourLable.text =good.car_colourgood;
    //存放cell的路径
    cell.path=indexPath;
    cell.deleate=self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SYJStore *store=[self.storeArray objectAtIndex:indexPath.section];
    SYJGood *good=[store.goodArray objectAtIndex:indexPath.row];
    
    SYJBaybyTableViewController *vcc= [[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil]instantiateViewControllerWithIdentifier:@"baby"];
    //vcc.idd=[idarr objectAtIndex:good.car_cargoods_id];
    vcc.idd=[NSString stringWithFormat:@"%d",good.car_cargoods_id];
    
    [self.navigationController pushViewController:vcc animated:YES];
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionheadView=[[[NSBundle mainBundle]loadNibNamed:@"SYJSectionhead" owner:self options:nil]objectAtIndex:0];
    NSString *keystore=[NSString stringWithFormat:@"store%lu",section];
    NSLog(@"%@",[dicbaby objectForKey:keystore]);
    
    
    SectionheadView.headnamelable.text=[dicbaby objectForKey:keystore];
    return SectionheadView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}

-(void)viewWillAppear:(BOOL)animated{
    [self islogin];
    
    APPDELEGATE.allprice=0;
    [APPDELEGATE.cartCalculateArray removeAllObjects];
    APPDELEGATE.Carnumber=0;
    APPDELEGATE.State1=NO;
    VC.alltatolButton.text=@"0.00";
    VC.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    
    self.navigationController.navigationBar.hidden=NO;
    headView.hidden=NO;
   [self requersCar];
}

-(void)viewWillDisappear:(BOOL)animated{
    headView.hidden=YES;
    [lable removeFromSuperview];
    VC.hidden=YES;
}

#pragma mark-重写代理事件
-(void)selectBox:(NSIndexPath *)path{//cell 中的sele path，已经把所有的复制过去了
    //indexPath传入进来,获取指定的cell,将cell添加到全局数组中
    SYJStore *store=[self.storeArray objectAtIndex:path.section];
    SYJGood *good=[store.goodArray objectAtIndex:path.row];
    [APPDELEGATE.cartCalculateArray addObject:good];
 
    [APPDELEGATE.pathArray addObject:path];
    
    APPDELEGATE.xiaorderpath=path;
}

-(void)deselectBox:(NSIndexPath *)path{
    //indexPath传入进来,获取指定的cell,将cell从全局数组中删除
    SYJStore *store=[self.storeArray objectAtIndex:path.section];
    SYJGood *good=[store.goodArray objectAtIndex:path.row];
    [APPDELEGATE.cartCalculateArray removeObject:good];
    [APPDELEGATE.pathArray removeObject:path];
    APPDELEGATE.xiaorderpath=nil;
}

-(void)addCount:(NSIndexPath *)path{
    //改变当前数组和全局数组中的count值
    SYJStore *store=[self.storeArray objectAtIndex:path.section];
    SYJGood *good=[store.goodArray objectAtIndex:path.row];
    good.car_numbercar++;
    //改变数据库中的count值
}

-(void)deleteCount:(NSIndexPath *)path{
    //改变当前数组和全局数组中的count值
    SYJStore *store=[self.storeArray objectAtIndex:path.section];
    SYJGood *good=[store.goodArray objectAtIndex:path.row];
    good.car_numbercar--;
    
    //改变数据库中的值
}
-(void)islogin{
    if (APPDELEGATE.user.userID==0) {
//        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        loginVc=[[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"tijiao"];
//        [self.navigationController pushViewController:loginVc animated:YES];
//        self.navigationController.navigationBar.hidden=YES;
//         //
//        APPDELEGATE.Loginstatus=YES;
        if (self.noDataView==nil) {
            self.noDataView = [[UIView alloc] init];
            self.noDataView.frame = CGRectMake(0, 68, kAllWidth, kAllHeight - 65 - 49);
            self.noDataView.backgroundColor = [UIColor whiteColor];
            [self.navigationController.view addSubview:self.noDataView];
            
            //添加noData的提示
            self.noDatalb = [[UILabel alloc] init];
            float lbW = 240;
            float lbH = 40;
            float lbX = 0.5*(kAllWidth - lbW);
            float lbY = 20;
            self.noDatalb.frame = CGRectMake(lbX, lbY, lbW, lbH);
            self.noDatalb.font = [UIFont systemFontOfSize:13.0];
            self.noDatalb.text = @"亲,你暂时还没有购买东西哦~~";
            self.noDatalb.textAlignment = NSTextAlignmentCenter;
            self.noDatalb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
            [self.noDataView addSubview:self.noDatalb];
        }
    }
}

- (void)createNoDataLabel{
    if (self.noDataView==nil) {
        self.noDataView = [[UIView alloc] init];
        self.noDataView.frame = CGRectMake(0, 68, kAllWidth, kAllHeight - 65 - 49);
        self.noDataView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:self.noDataView];
        
        //添加noData的提示
        self.noDatalb = [[UILabel alloc] init];
        float lbW = 240;
        float lbH = 40;
        float lbX = 0.5*(kAllWidth - lbW);
        float lbY = 20;
        self.noDatalb.frame = CGRectMake(lbX, lbY, lbW, lbH);
        self.noDatalb.font = [UIFont systemFontOfSize:13.0];
        self.noDatalb.text = @"亲,你暂时还没有购买东西哦~~";
        self.noDatalb.textAlignment = NSTextAlignmentCenter;
        self.noDatalb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        [self.noDataView addSubview:self.noDatalb];
    }
}
@end

