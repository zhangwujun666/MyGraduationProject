//
//  SYJHomeViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJHomeViewController.h"
#import "SYJScrollTableViewCell.h"
#import "SYJClassifyTableViewCell.h"
#import "SYJActivityTableViewCell.h"
#import "SYJShopTableViewCell.h"
#import "SYJGoodsTableViewCell.h"
#import "QRCodeReaderViewController.h"
#import "SYJClassifyCellViewController.h"
#import "SYJClassifyAllCellViewController.h"
#import "SYJActivityCellViewController.h"
#import "SYJClassifyViewController.h"
#import "SYJStoreViewController.h"
#import "SYJGoodsTableViewCell.h"
#import "SYJDetailTableViewController.h"
#import "SYJBaybyTableViewController.h"
#import "MJRefreshNormalHeader.h"
#import "UIViewController+Example.h"
#import "SYJSearchViewController.h"

#import "AppDelegate.h"

static const CGFloat MJDuration = 2.0;
@interface SYJHomeViewController ()<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate,SYJClassifyTableViewCellDelegate,SYJShopTableViewCellDelegate,SYJGoodsTableViewCellDelegate,SYJActivityTableViewCellDelegate,UISearchBarDelegate>{
    SYJGoodsTableViewCell * goodsCell;
    CGFloat goodsCellSize;
}

@end

@implementation SYJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    [self.goodsSearchBar setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}
- (void)setUpInit{
    //关闭导航栏
    self.navigationController.navigationBar.hidden =YES;
    //设置头的颜色
    self.homeHeadView.backgroundColor = homeViewHead1;
    [self.homeHeadView setFrame:CGRectMake(0, 0, 320, 64)];
    //[self.goodsSearchBar setBackgroundColor:homeViewHead1];
    //[self.goodsSearchBar setTintColor:homeViewHead1];
    
    //设清楚搜所框的两条黑色线
    self.goodsSearchBar.layer.borderWidth = 1;
    self.goodsSearchBar.layer.borderColor = [homeViewHead1 CGColor];
    self.goodsSearchBar.delegate=self;
    //[self.goodsSearchBar setBackgroundColor:homeViewHead];
    //[self.goodsSearchBar setTintColor:homeViewHead];
    self.goodsSearchBar.backgroundColor = homeViewHead;
    self.goodsSearchBar.tintColor = homeViewHead;
    self.goodsSearchBar.barTintColor = homeViewHead;
    
//    UIView *backgroundView=[[[self.goodsSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
//    [backgroundView removeFromSuperview];
//    //self.goodsSearchBar.backgroundColor=homeViewHead;
//    self.goodsSearchBar.tintColor=homeViewHead;
    //self.goodsSearchBar.layer.backgroundColor=homeViewHead.CGColor;
    //[self.goodsSearchBar removeFromSuperview];
    //[self.goodsSearchBar removeFromSuperview];
    
    //UISearchBar *customSearchBar = [[UISearchBar alloc] init];
    //customSearchBar.frame=CGRectMake(70, 18, 206, 44);
    //[self.navigationController.navigationBar addSubview:customSearchBar];
    
    
    
    //设置tableview的代理为本视图
    self.mainTableView.delegate =self;
    self.mainTableView.dataSource = self;
    //设置TableView不显示分割线，不显示滚动条
    self.mainTableView.separatorStyle = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    //上拉加载，下拉刷新
    [self example03];
    [self example11];
    //NSString * area = [APPDELEGATE.cityName substringFromIndex:1];
    //[self.areaShowButton setTitle: area forState:UIControlStateNormal];
    
    goodsCellSize = 2440.0;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 分类代理的跳转协议
- (void)SYJClassifyTableViewCellDelegateWithName:(NSString *)name{
    //第一步：找到storyboard对象
    UIStoryboard *storyBoard =self.storyboard;
    if ([name isEqualToString:@"9"]){
        //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
        SYJClassifyAllCellViewController *ClassifyCellMV = (SYJClassifyAllCellViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"classifyallcel"];
        
        //第三步:传递参数
        ClassifyCellMV.type = name;
        //第四步：跳转      
        [self.navigationController pushViewController:ClassifyCellMV animated:NO];
        //[self presentViewController:ActivityCellMV animated:YES completion:nil];
    }
    else{
        //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
        SYJClassifyCellViewController *ClassifyCellMV = (SYJClassifyCellViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ClassifyCell"];
        
        //第三步:传递参数
        ClassifyCellMV.type = name;
        //第四步：跳转
        [self.navigationController pushViewController:ClassifyCellMV animated:NO];
        //[self presentViewController:ActivityCellMV animated:YES completion:nil];
    }
    
}
#pragma mark - 热销店铺代理的跳转协议
-(void)SYJShopTableViewCellDelegateWithId:(NSString *)Id andName:(NSString *)Name andImage:(UIImageView *)Image{

    SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
    storeVC.storeId = [Id intValue];
    storeVC.storeName=Name;
    storeVC.storeImage=Image.image;
    [self.navigationController pushViewController:storeVC animated:YES];
    
}
#pragma mark - 畅销宝贝代理的跳转协议
-(void)SYJGoodsTableViewCellDelegateWithGoodId:(NSString *)goodsId{
    
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
     SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
    
   /*
    SYJBaybyTableViewController *vcc= [[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil] instantiateInitialViewController];
    
    [self.navigationController pushViewController:vcc animated:YES];
    */
}
#pragma mark - 秒杀代理的跳转协议
-(void)SYJActivityTableViewCellDelegateWithGoodId:(NSString *)goodsId{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
    
    /*
     SYJBaybyTableViewController *vcc= [[UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil] instantiateInitialViewController];
     
     [self.navigationController pushViewController:vcc animated:YES];
     */
}


- (IBAction)areaSelectClicked:(UIButton *)sender {
    
}

//搜索框获取焦点的时候
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SYJSearchViewController *vc=[[SYJSearchViewController alloc] initWithNibName:@"SYJSearchViewController" bundle:nil];
    //[navgationView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

#pragma mark - 扫一扫
- (IBAction)saoClickedButton:(UIButton *)sender {
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];

    
}
#pragma mark - QRCodeReader Delegate Methods 扫码结果显示.

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }];
    NSRange typeRange=NSMakeRange(0, 1);
    NSString *type=[result substringWithRange:typeRange];
    
    NSRange numRange=NSMakeRange(result.length-6, 6);
    NSString *num=[result substringWithRange:numRange];
    
    if ([type isEqualToString:@"a"]) {
        //店铺
        SYJStoreViewController *storevc=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
        storevc.storeId=[num intValue];
        [self.navigationController pushViewController:storevc animated:YES];
    }else if ([type isEqualToString:@"b"]){
        //宝贝
        //跳转到宝贝页面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
        SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
        vcc.idd = [NSString stringWithFormat:@"%d",[num intValue]];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vcc animated:YES];
    }else{
        
    }
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if(APPDELEGATE.areaName){
        [self.areaShowButton setTitle:APPDELEGATE.areaName forState:UIControlStateNormal];
    }
}
#pragma mark - 跳转之前执行
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //打开head
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];// [textFiled resignFirstResponder];这个是取消当前textFIled的键盘
    
}
#pragma mark - 设置TableView显示几个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
#pragma mark - 设置TableView每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSArray *array = [[NSArray alloc]init];
    return 11;
}
/**
 *  根据indexPath来区分不同区域显示的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
        //图片轮换的cell
        SYJScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scrolltableviewcell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SYJScrollTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        return cell;
    }
    else if (indexPath.row ==1){
        //分类的cell
        SYJClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifytableviewcell" forIndexPath:indexPath];
        cell.delegate =self;
        return cell;
    }
    else if (indexPath.row ==2){
        //分割线
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row ==3){
        //活动头部的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityhead" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row ==4){
        //活动的具体cell
        SYJActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activity" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 5) {
        //分割线
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween1" forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.row == 6) {
        //特惠店铺部分的头
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shophead" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 7) {
        //特惠店铺的具体cell
        SYJShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shop" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 8) {
        //分割线
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween2" forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.row == 9) {
        //畅销宝贝的头
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodshead" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  
        return cell;
    }
    else if(indexPath.row == 10) {
        //畅销宝贝的具体cell
        SYJGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goods" forIndexPath:indexPath];
        cell.delegate = self;
        goodsCell = cell;
        return cell;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size[11] = {100,136,5,35,100,5,35,200,5,50,goodsCellSize};
    return size[indexPath.row];
}
//每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu",indexPath.row);
    //秒杀入口
    if(indexPath.row == 3){
        UIStoryboard *storyBoard =self.storyboard;
        //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
        SYJActivityCellViewController *ActivityCellMV = (SYJActivityCellViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ActivityCellMV"];
        
        //第三步:传递参数
        NSDate *  nowdate=[NSDate date];
        //时间格式
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HHmmss"];
        NSString *  locationString=[dateformatter stringFromDate:nowdate];
        NSString * h = [locationString substringToIndex:2];
        NSLog(@"%d",[h intValue]);
        if ([h intValue]<10 && [h intValue]>=0) {
            ActivityCellMV.date = @"0";
        }
        if ([h intValue]<16 && [h intValue]>=10) {
            ActivityCellMV.date = @"10";
        }
        if ([h intValue]<22 && [h intValue]>=16) {
            ActivityCellMV.date = @"16";
        }
        if ([h intValue]>=22) {
            ActivityCellMV.date = @"22";
        }
        //第四步：跳转
        [self.navigationController pushViewController:ActivityCellMV animated:NO];
    }
    //更多店铺的入口
    if(indexPath.row == 6){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Classify" bundle:nil];
        //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
        SYJClassifyViewController *ClassifyMV = (SYJClassifyViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ClassifyMV"];
        //第三步:传递参数
        //第四步：跳转
        [self.navigationController pushViewController:ClassifyMV animated:NO];
    }
    if(indexPath.row == 9){
        
    }
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //NSLog(@"end!%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > 500) {
//        
//        self.mainTableView.scrollEnabled =NO;
//        goodsCell.goodsCollectionView.scrollEnabled = YES;
////        if ([self.delegate  respondsToSelector:@selector(SYJHomeViewControllerDelegateLoadMoreData)]) {
////            [self.delegate SYJHomeViewControllerDelegateLoadMoreData];
////        }
//    }
//}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"end!%f",scrollView.contentOffset.y);
}


-(void)SYJGoodsTableViewCellDelegateLoadMoreData{
    self.mainTableView.scrollEnabled = YES;
}
/*
//让代理执行操作，同时传递参数
if ([self.delegate  respondsToSelector:@selector(SYJGoodsTableViewCellDelegateWithGoodId:)]) {
    [self.delegate SYJGo
 
 odsTableViewCellDelegateWithGoodId:dic[@"goods_id"]];
}*/

#pragma mark UITableView + 下拉刷新 隐藏时间
- (void)example03
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.mainTableView.header = header;
}
#pragma mark UITableView + 上拉刷新 默认
- (void)example11
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data insertObject:MJRandomData atIndex:0];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.mainTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.mainTableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data addObject:MJRandomData];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.mainTableView reloadData];
        //宽度加倍
        goodsCellSize = goodsCellSize + 2450.0;
        //商品数量加倍
        goodsCell.goodsNum +=20;
        //刷新商品表
        [goodsCell.goodsCollectionView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.mainTableView.footer endRefreshing];
    });
}








/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoTableViewController *VC =[[InfoTableViewController alloc] initWithNibName:@"InfoTableViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
