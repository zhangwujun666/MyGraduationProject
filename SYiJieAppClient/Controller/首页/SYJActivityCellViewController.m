//
//  SYJActivityCellViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJActivityCellViewController.h"
#import "SYJMiaoShaHeadView.h"
#import "SYJMiaoshaCellTableViewCell.h"
#import "SYJBaybyTableViewController.h"
static const CGFloat MJDuration = 2.0;
@interface SYJActivityCellViewController ()

@end

@implementation SYJActivityCellViewController{
    NSArray * miaoShaGoodsArray;
}
- (void)viewDidLoad{
    //设置头颜色
    self.titleView.backgroundColor = titleColor;
    //获取数据
    [self getDataSource];
    //设置显示商品数目
    self.goodsNum = 10.0;
    //上拉刷新，下拉加载
    [self loadMore];
    [self loadNew];
    //设置当前的秒杀场
    if ([self.date isEqualToString:@"0"]) {
        [self.time0Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"10"]) {
        [self.time10Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"16"]) {
        [self.time16Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"22"]) {
        [self.time22Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
#pragma mark -返回
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取miaosha数据资源和配置
-(void)getDataSource{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/miaoshagoods",SYJHTTP];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *info=@{@"miaoshaactivityimage_date":self.date
                         };
    [manager POST:urlPath parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        miaoShaGoodsArray = dicdescription[@"data"];
        NSLog(@"dic=%@",miaoShaGoodsArray);
        [self.miaoShaTaleView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.miaoShaTaleView.delegate = self;
    self.miaoShaTaleView.dataSource =self;
    
    SYJMiaoShaHeadView * miaoshaHead = [[[NSBundle mainBundle] loadNibNamed:@"SYJMiaoShaHeadView" owner:self options:nil]objectAtIndex:0];
    miaoshaHead.date = self.date;
    [miaoshaHead setInit];
    [self.miaoShaTaleView  setTableHeaderView: miaoshaHead];
    
    //设置TableView不显示分割线，不显示滚动条
    self.miaoShaTaleView.separatorStyle = NO;
    self.miaoShaTaleView.showsVerticalScrollIndicator = NO;
    

    /*
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.showsVerticalScrollIndicator = NO;
    self.goodsCollectionView.alwaysBounceVertical = YES;
    self.goodsCollectionView.scrollEnabled =NO;
    */
}


#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.navigationController.navigationBar.hidden = YES;
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
    if (self.goodsNum > (NSInteger)[miaoShaGoodsArray count]) {
        return [miaoShaGoodsArray count];
    }
    return self.goodsNum;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYJMiaoshaCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"miaoshacelltableviewcell"];
    cell.date = self.date;
    [cell setUpCellWithDic:[miaoShaGoodsArray objectAtIndex:indexPath.row/2] ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tome0clicked:(UIButton *)sender {
    //[sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if ([self.date isEqualToString:@"0"]) {
        [self.time0Button setTitleColor:cellTextColor forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"10"]) {
        [self.time10Button setTitleColor:cellTextColor forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"16"]) {
        [self.time16Button setTitleColor:cellTextColor forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"22"]) {
        [self.time22Button setTitleColor:cellTextColor forState:UIControlStateNormal];
    }
    self.date = [NSString stringWithFormat:@"%d",(int)(sender.tag-550)];
    if ([self.date isEqualToString:@"0"]) {
        [self.time0Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"10"]) {
        [self.time10Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"16"]) {
        [self.time16Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([self.date isEqualToString:@"22"]) {
        [self.time22Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    self.goodsNum = 10.0;
    [self.miaoShaTaleView setContentOffset:CGPointMake(0,0) animated:NO];
    [self getDataSource];
}

//每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu",indexPath.row);
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
    self.miaoShaTaleView.header = header;
}
#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.miaoShaTaleView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{

    // 模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.miaoShaTaleView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.miaoShaTaleView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //显示数目加倍
        self.goodsNum +=10;
        // 刷新表格
        [self.miaoShaTaleView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.miaoShaTaleView.footer endRefreshing];
    });
}


/*
#pragma mark - Navigation

// In a sto
 ryboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
