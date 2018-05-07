//
//  SYJClassifyCellViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJClassifyCellViewController.h"
#import "SYJClassifyScrollTableViewCell.h"
#import "SYJMiaoShaTableViewCell.h"
#import "SYJHotGoodsTableViewCell.h"
#import "SYJStoreViewController.h"
#import "SYJBaybyTableViewController.h"
static const CGFloat MJDuration = 2.0;
@interface SYJClassifyCellViewController (){
    SYJHotGoodsTableViewCell *goodsCell;
    CGFloat goodsCellSize;
}

@end

@implementation SYJClassifyCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    
    //[self.goodsSearchBar setBackgroundColor:[UIColor redColor]];
    
    // Do any additional setup after loading the view.
}
- (void)setUpInit{
    //关闭导航栏
    self.navigationController.navigationBar.hidden =YES;
    NSArray *type = @[@"潮流女装",@"精品男装",@"童 装",@"家居服",@"上 衣",@"裤 子",@"内 衣"];
    self.titleLabel.text = [type objectAtIndex: [self.type intValue]-2];
    //设置头的颜色
   self.titleView.backgroundColor = titleColor;
    /*
     [self.homeHeadView setFrame:CGRectMake(0, 0, 320, 64)];
     [self.goodsSearchBar setBackgroundColor:homeViewHead];
     [self.goodsSearchBar setTintColor:homeViewHead];
     
     */
    
    //设置tableview的代理为本视图
    self.classifyCellTableView.delegate =self;
    self.classifyCellTableView.dataSource = self;
    //设置TableView不显示分割线，不显示滚动条
    self.classifyCellTableView.separatorStyle = NO;
    self.classifyCellTableView.showsVerticalScrollIndicator = NO;
    //上拉刷新，下拉加载
    [self loadMore];
    [self loadNew];
    //10个商品显示的高度
    goodsCellSize = 1215.0;
    
    //self.classifyCellTableView.scrollEnabled = NO;
}
- (IBAction)backClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 今日打牌跳转回调

#pragma mark - 热销店铺代理的跳转协议
-(void)SYJTadyBrandTableViewCellDelegateWithshopId:(NSString *)shopId{
    
    SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
    //storeVC.storeId = [shopId intValue];
    storeVC.storeId = 10;

    [self.navigationController pushViewController:storeVC animated:YES];
    
}
#pragma mark - 畅销宝贝代理的跳转协议/*
-(void)SYJGoodsTableViewCellDelegateWithGoodId:(NSString *)goodsId{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
 
}
#pragma mark - 秒杀代理的跳转协议/*
-(void)SYJMiaoShaTableViewCellDelegateWithGoodId:(NSString *)goodsId{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
    
}
#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
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
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
        SYJClassifyScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyscrolltableviewcell"];
        cell.type =self.type;
        
        [cell getScrollImage];
        return cell;
    }
    else if (indexPath.row ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headtadybrand" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row ==2){
        SYJTadyBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tadybrandtableviewcell" forIndexPath:indexPath];
        cell.type =self.type;
        cell.delegate = self;
        [cell getDataSource];
        return cell;
    }

    else if (indexPath.row ==3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headmiaosha" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row ==4){
        SYJMiaoShaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"miaosha" forIndexPath:indexPath];
        cell.type = self.type;
        [cell getDataSourceWithNum:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 6) {
        SYJMiaoShaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"miaosha" forIndexPath:indexPath];
        cell.type = self.type;
        [cell getDataSourceWithNum:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;

    }
    else if(indexPath.row == 7) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 8) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotproductshead" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if(indexPath.row == 9) {
        SYJHotGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotproducts" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = self.type;
        cell.delegate = self;
        [cell getDataSource];
        goodsCell = cell;
        return cell;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  size[10]={120,35,150,30,105,1,105,1,35,goodsCellSize};
    return size[indexPath.row];
}
//每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%d",(int)indexPath.row);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
}

#pragma mark UITableView + 下拉刷新 隐藏时间
- (void)loadNew
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
    self.classifyCellTableView.header = header;
}
#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.classifyCellTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"end!%f",scrollView.contentOffset.y);
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
        [self.classifyCellTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.classifyCellTableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.classifyCellTableView reloadData];
        //宽度加倍
        goodsCellSize = goodsCellSize + 1225.0;
        //商品数量加倍
        goodsCell.goodsNum +=10;
        //刷新商品表
        [goodsCell.goodsCollectionView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.classifyCellTableView.footer endRefreshing];
    });
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
