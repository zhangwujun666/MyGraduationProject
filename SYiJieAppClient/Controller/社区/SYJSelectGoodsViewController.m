//
//  SYJSelectGoodsViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSelectGoodsViewController.h"
#import "SYJSelectGoodsCellTableViewCell.h"
#import "SYJAddShareViewController.h"
static const CGFloat MJDuration = 2.0;
@interface SYJSelectGoodsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * finishGoodsArray;
    NSInteger goodsNum;
}

@end

@implementation SYJSelectGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置一次加载的的个数
    goodsNum = 10;
    //上拉刷新、下拉加载
    [self loadNew];
    //[self loadMore];
    //设置代理
    self.goodsFinishTableView.dataSource = self;
    self.goodsFinishTableView.delegate = self;
    //设置TableView不显示分割线，不显示滚动条
    self.goodsFinishTableView.separatorStyle = NO;
    self.goodsFinishTableView.showsVerticalScrollIndicator = NO;

}


-(void)Nogoods{
    [self.goodsFinishTableView removeFromSuperview];
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 100, 100)];
    
    imgview.image=[UIImage imageNamed:@"store"];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(70, 300, 300, 70)];
    lable.text=@"什么都没有赶紧去逛逛吧！";
    [self.view addSubview:lable];
    [self.view addSubview:imgview];
}
- (void)getFinshGoodsData{
    NSUInteger ID=11;
    NSString *path=[[NSString alloc]initWithFormat:@"%@userId=%lu&&ordertakegoods=4",korderr,ID];
    NSURL *url=[NSURL URLWithString:path];
    NSOperationQueue *dui=[NSOperationQueue mainQueue];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:dui completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *JSOn=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary * dic = [JSOn objectForKey:@"data"];
        finishGoodsArray=[dic objectForKey:@"store_goodDetail0"];
        if (finishGoodsArray == nil) {
            finishGoodsArray = [[NSMutableArray alloc]init];
        }
        if([finishGoodsArray count] == 0){
            [self Nogoods];
        }
        [self.goodsFinishTableView reloadData];

    }];

    
}
- (IBAction)blackClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 设置TableView显示几个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
#pragma mark - 设置TableView每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSArray *array = [[NSArray alloc]init];
    if (goodsNum > [finishGoodsArray count]) {
        return [finishGoodsArray count];
    }
    return goodsNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *goodsDic=[finishGoodsArray objectAtIndex:indexPath.row];
    SYJSelectGoodsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectgoodscell"];
    cell.goodsNameLable.text=[goodsDic objectForKey:@"order_goodsname"];
    NSString *price=[NSString stringWithFormat:@"￥%@",[goodsDic objectForKey:@"order_goodsprice"]];
    cell.goodsPriceLabel.text=price;
    NSString *imageurl=[[NSString alloc]initWithFormat:@"%@%@",korderimage,[goodsDic objectForKey:@"order_goodsimage"]];
    NSURL *goodsimg=[NSURL URLWithString:imageurl];
    [cell.goodsImage sd_setImageWithURL:goodsimg];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
//每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodsDic=[finishGoodsArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyBoard = self.storyboard;
    SYJAddShareViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:@"addshareview"];
    vc.source = @"compose";
    vc.goodsId = goodsDic[@"order_goods_id"];
    vc.goodsName = goodsDic[@"order_goodsname"];
    
    self.navigationController.navigationBar.hidden =NO;
    [self.navigationController pushViewController:vc animated:YES];
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
    self.goodsFinishTableView.header = header;
}
#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.goodsFinishTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
        [self.goodsFinishTableView reloadData];
        [self getFinshGoodsData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.goodsFinishTableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        //商品数量加倍
        goodsNum +=10;
        // 刷新表格
        [self.goodsFinishTableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.goodsFinishTableView.footer endRefreshing];
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
