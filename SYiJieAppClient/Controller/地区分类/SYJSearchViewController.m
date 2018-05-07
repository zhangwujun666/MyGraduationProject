//
//  SYJSearchViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/6.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSearchViewController.h"
#import "SYJNavigationView.h"
#import "AFNetworking.h"
#import "SYJTableViewStoreCell.h"
#import "SYJTableViewGoodCell.h"
#import "SYJSearchStoreReusbleHeaderView.h"
#import "SYJStoreViewController.h"
#import "SYJBaybyTableViewController.h"
#import "AppDelegate.h"

#define storeCellIdentifer @"storeCell"
#define goodCellIdentifer @"goodCell"
#define header1CellIdentifer @"header1Cell"
#define header2CellIdentifer @"header2Cell"
#define headerBgColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]//导航栏的背景色

@interface SYJSearchViewController ()<SearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ShowAllDetailDelegate>
{
    SYJNavigationView *navigationView;//自定义导航view
    CGRect headerFrame;//tableView的frame
    NSMutableArray *storeArray;//存放店铺信息的数组
    NSMutableArray *storeTempArray;//临时存放店铺信息的数组
    NSMutableArray *goodArray;//存放商品信息的数组
    NSMutableArray *goodTempArray;//临时存放商品信息的数组
    SYJSearchStoreReusbleHeaderView *headerViewFirstSection;//section0头视图
    SYJSearchStoreReusbleHeaderView *headerViewSecondSection;//section1头视图
    SYJSearchStoreReusbleHeaderView *reuseableSecondSection;//section1头视图
    NSString *reuseableSecondHeaderBtnText;//自己缓存一份section1的视图
    //UITapGestureRecognizer *recognizer;//tableView的手势
    
    UITableView *resultTableView;//自定义tableView
    int showAllStore;//是否显示所有店铺
    int showAllGood;//是否显示所有商品
    int storeCount;//存储上一次商店cell的个数
    int goodCount;//存储上一次商品cell的个数
}
@end

@implementation SYJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storeArray=[[NSMutableArray alloc] init];//初始化存放店铺数据的数组
    storeTempArray=[[NSMutableArray alloc] init];//初始化临时存放店铺数据的数组
    goodArray=[[NSMutableArray alloc] init];//初始化存放商品数据的数组
    goodTempArray=[[NSMutableArray alloc] init];//初始化临时存放商品数据的数组
    
    //设置自动空白为空
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    showAllStore=0;//初始化不显示全部店铺
    showAllGood=0;//初始化不显示全部商品
    
    //隐藏tabBar
    self.tabBarController.tabBar.hidden=YES;
    
}

//输入框的文字变化时触发这个事件
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (reuseableSecondHeaderBtnText!=nil) {
        reuseableSecondHeaderBtnText=nil;
    }
    
    showAllStore=0;
    showAllGood=0;
    
    [storeTempArray removeAllObjects];
    [goodTempArray removeAllObjects];
    
    NSString *content=navigationView.customSearchBar.text;
    APPDELEGATE.searchKey=content;
    
    if ([content isEqualToString:@""]) {
        //NSLog(@"当前没有内容.");
    }else{
        //NSLog(@"搜索框的内容是:%@",content);
        [self setUpSearchData:content];
    }

}

//开始编辑的方法
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}


//点击搜索按钮,消除键盘,移除手势
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [navigationView.customSearchBar resignFirstResponder];
//    [resultTableView removeGestureRecognizer:recognizer];
}

//section的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//返回Header的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        headerViewFirstSection=[tableView dequeueReusableHeaderFooterViewWithIdentifier:header1CellIdentifer];
        if (headerViewFirstSection==nil) {
            headerViewFirstSection=[[SYJSearchStoreReusbleHeaderView alloc] initWithReuseIdentifier:header1CellIdentifer];
            headerViewFirstSection.storeNameLabel.text=@"店铺搜索结果";
            [headerViewFirstSection.showAllButton setTitle:@"显示全部店铺" forState:UIControlStateNormal];
        }
        
        headerViewFirstSection.delegate=self;
        
        return headerViewFirstSection;
    }else{
        headerViewSecondSection=[tableView dequeueReusableHeaderFooterViewWithIdentifier:header2CellIdentifer];
        if (headerViewSecondSection==nil) {
            headerViewSecondSection=[[SYJSearchStoreReusbleHeaderView alloc] initWithReuseIdentifier:header2CellIdentifer];
            headerViewSecondSection.storeNameLabel.text=@"宝贝搜索结果";
            if ([reuseableSecondHeaderBtnText isEqualToString:@""]||(reuseableSecondHeaderBtnText==nil)) {
                [headerViewSecondSection.showAllButton setTitle:@"显示全部宝贝" forState:UIControlStateNormal];
            }else{
                [headerViewSecondSection.showAllButton setTitle:reuseableSecondHeaderBtnText forState:UIControlStateNormal];
            }
        }
        
        headerViewSecondSection.delegate=self;
        
        reuseableSecondSection=headerViewSecondSection;
        
        return headerViewSecondSection;
    }
}

//实现代理方法
-(void)showAllData:(UITableViewHeaderFooterView *)headerView{
    SYJSearchStoreReusbleHeaderView *reuableHeaderView=(SYJSearchStoreReusbleHeaderView *)headerView;
    reuseableSecondHeaderBtnText=reuseableSecondSection.showAllButton.titleLabel.text;

    if ([reuableHeaderView.showAllButton.titleLabel.text isEqualToString:@"显示全部店铺"]) {
        //NSLog(@"显示全部店铺.");
        if (storeTempArray.count==0) {
            storeTempArray=[storeArray mutableCopy];
        }
        //设置显示全部店铺的标志为1
        showAllStore=1;
        //恢复数据源中的数据
        storeArray=[storeTempArray mutableCopy];
        //重新插入所有的cell
        [resultTableView beginUpdates];
        NSMutableArray *arrayAdd=[NSMutableArray array];
        for (int i=3; i<[storeArray count]; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            [arrayAdd addObject:indexPath];
        }
        [resultTableView insertRowsAtIndexPaths:arrayAdd withRowAnimation:UITableViewRowAnimationFade];
        [resultTableView endUpdates];
    }else if([reuableHeaderView.showAllButton.titleLabel.text isEqualToString:@"隐藏部分店铺"]){
        //NSLog(@"隐藏部分店铺.");
        storeArray=nil;
        storeArray=[[NSMutableArray alloc] init];
        //向数组中添加3个数据
        for (int i=0; i<3; i++) {
            [storeArray addObject:[storeTempArray objectAtIndex:i]];
        }
        
        //移除之前的cell
        [resultTableView beginUpdates];
        NSMutableArray *arrayDel=[NSMutableArray array];
        for (int i=3; i<storeCount; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            [arrayDel addObject:indexPath];
        }
        [resultTableView deleteRowsAtIndexPaths:arrayDel withRowAnimation:UITableViewRowAnimationFade];
        [resultTableView endUpdates];
        
        //设置全部显示的标志为0
        showAllStore=0;
    }else if ([reuableHeaderView.showAllButton.titleLabel.text isEqualToString:@"显示全部宝贝"]){
        //NSLog(@"显示全部宝贝.");
        if (goodTempArray.count==0) {
            goodTempArray=[goodArray mutableCopy];
        }
        //设置显示全部店铺的标志为1
        showAllGood=1;
        //恢复数据源中的数据
        goodArray=[goodTempArray mutableCopy];
        //重新插入所有的cell
        [resultTableView beginUpdates];
        NSMutableArray *arrayAdd=[NSMutableArray array];
        for (int i=3; i<[goodArray count]; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:1];
            [arrayAdd addObject:indexPath];
        }
        [resultTableView insertRowsAtIndexPaths:arrayAdd withRowAnimation:UITableViewRowAnimationFade];
        [resultTableView endUpdates];
    }else{
        //NSLog(@"隐藏部分宝贝.");
        goodArray=nil;
        goodArray=[[NSMutableArray alloc] init];
        //向数组中添加3个数据
        for (int i=0; i<3; i++) {
            [goodArray addObject:[goodTempArray objectAtIndex:i]];
        }
        
        //移除之前的cell
        [resultTableView beginUpdates];
        NSMutableArray *arrayDel=[NSMutableArray array];
        for (int i=3; i<goodCount; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:1];
            [arrayDel addObject:indexPath];
        }
        [resultTableView deleteRowsAtIndexPaths:arrayDel withRowAnimation:UITableViewRowAnimationFade];
        [resultTableView endUpdates];
        
        //设置全部显示的标志为0
        showAllGood=0;
    }
    
    NSString *text=reuableHeaderView.showAllButton.titleLabel.text;
    NSRange range=NSMakeRange(0, 4);
    NSString *subString=[text substringWithRange:range];
    NSString *result=@"";
    
    if ([subString isEqualToString:@"显示全部"]) {
        result=[text stringByReplacingCharactersInRange:range withString:@"隐藏部分"];
        //NSLog(@"%@",result);
    }else{
        result=[text stringByReplacingCharactersInRange:range withString:@"显示全部"];
        //NSLog(@"%@",result);
    }
    [reuableHeaderView.showAllButton setTitle:result forState:UIControlStateNormal];
}

//每个Section的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        //店铺的行数
        if (storeArray.count>0) {
            //如果显示全部的标志为1
            if (showAllStore==1) {
                //返回全部的数量
                storeCount=(int)storeArray.count;
                return storeArray.count;
            }else{
                //如果不要求全部显示
                if (storeArray.count<3) {
                    //如果搜索结果少于3，就显示全部搜索结果
                    storeCount=(int)storeArray.count;
                    return storeArray.count;
                }else{
                    //如果搜索结果大于3，就显示3条
                    storeCount=3;
                    return 3;
                }
            }
        }else{
            storeCount=0;
            return 0;
        }
    }else if(section==1){
        //商品的行数
        if (goodArray.count>0) {
            //判断是否全部显示商品
            if (showAllGood==1) {
                //需要全部显示
                goodCount=(int)goodArray.count;
                return goodArray.count;
            }else{
                //不需要全部显示
                if (goodArray.count>3) {
                    //搜索的结果数量大于3
                    goodCount=3;
                    return 3;
                }else{
                    //搜索的结果少于3
                    goodCount=(int)goodArray.count;
                    return goodArray.count;
                }
            }
        }else{
            goodCount=0;
            return 0;
        }
    }else{
        return 0;
    }
}

//将要显示头视图
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    SYJSearchStoreReusbleHeaderView *reuseView=(SYJSearchStoreReusbleHeaderView *)view;
//    NSLog(@"－－－－－%@",reuseView.showAllButton.titleLabel.text);
    
    if (storeArray.count==0||storeArray.count<3) {
        headerViewFirstSection.showAllButton.enabled=NO;
    }else{
        headerViewFirstSection.showAllButton.enabled=YES;
    }
    
    if (goodArray.count==0||goodArray.count<3) {
        headerViewSecondSection.showAllButton.enabled=NO;
    }else{
        headerViewSecondSection.showAllButton.enabled=YES;
    }
    
}

//每一个cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (storeArray.count==0||storeArray.count<3) {
        headerViewFirstSection.showAllButton.enabled=NO;
    }else{
        headerViewFirstSection.showAllButton.enabled=YES;
    }
    
    if (goodArray.count==0||goodArray.count<3) {
        headerViewSecondSection.showAllButton.enabled=NO;
    }else{
        headerViewSecondSection.showAllButton.enabled=YES;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"SYJTableViewStoreCell" bundle:nil] forCellReuseIdentifier:storeCellIdentifer];
    
    [tableView registerNib:[UINib nibWithNibName:@"SYJTableViewGoodCell" bundle:nil] forCellReuseIdentifier:goodCellIdentifer];
    
    if (indexPath.section==0) {
        SYJTableViewStoreCell *storeCell=(SYJTableViewStoreCell *)[tableView dequeueReusableCellWithIdentifier:storeCellIdentifer forIndexPath:indexPath];
        NSDictionary *storeDic=[storeArray objectAtIndex:indexPath.row];
        //获取店铺的logo图片
        NSString *storeLogo=storeDic[@"store_logo"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@shopimg/%@",SYJHTTPIMG,storeLogo]];
        
        [storeCell.storeImageView sd_setImageWithURL:url];
        storeCell.storeNameLabel.text=storeDic[@"store_name"];
        storeCell.tag=[storeDic[@"store_id"] intValue]+storeTag;
        return storeCell;
    }else{
        SYJTableViewGoodCell *goodCell=[tableView dequeueReusableCellWithIdentifier:goodCellIdentifer forIndexPath:indexPath];
        NSDictionary *goodDic=[goodArray objectAtIndex:indexPath.row];
        //获取商品的图片
        NSString *goodPic=goodDic[@"goods_image"];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@goodimg/%@",SYJHTTPIMG,goodPic]];
        [goodCell.goodImageView sd_setImageWithURL:url];
        goodCell.goodNameLabel.text=goodDic[@"goods_name"];
        goodCell.priceLabel.text=[NSString stringWithFormat:@"¥%.2f",[goodDic[@"goods_price"] floatValue]];
        goodCell.salesLabel.text=[NSString stringWithFormat:@"销量:%@",goodDic[@"goods_sales"]];
        goodCell.tag=[goodDic[@"store_id"] intValue]+goodTag;
        return goodCell;
    }
}

//返回Header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 60;
    }else{
        return 82;
    }
}

//获取搜索的相关的数据
-(void)setUpSearchData:(NSString *)data{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSString *url=[NSString stringWithFormat:@"%@Search/getdata",SYJHTTP];
    NSDictionary *parameter=@{@"inputKey":data};
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            storeArray=dic[@"result1"];
            goodArray=dic[@"result2"];
            //NSLog(@"%@",storeArray);
            //NSLog(@"%@",goodArray);
            [resultTableView reloadData];
        }else{
            NSLog(@"获取网络数据失败,请重试。");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题,请检查网络连接.");
    }];
    
}

//移动分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }

}

//添加导航栏
-(void)viewWillAppear:(BOOL)animated{
    navigationView=[[[NSBundle mainBundle] loadNibNamed:@"SYJNavigationView" owner:self options:nil] objectAtIndex:0];
    navigationView.delegate=self;
    navigationView.customSearchBar.delegate=self;
    [self.navigationController.view addSubview:navigationView];
    
    headerFrame=CGRectMake(0, navigationView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-navigationView.frame.size.height-1);
    
    //创建TableView
    resultTableView=[[UITableView alloc] initWithFrame:headerFrame style:UITableViewStylePlain];
    //将tableView添加到父视图中
    [self.view addSubview:resultTableView];
    //隐藏搜索的tableView的多余的cell
    resultTableView.tableFooterView=[[UIView alloc] init];
    //设置代理对象
    resultTableView.dataSource=self;
    resultTableView.delegate=self;
    
    [resultTableView reloadData];
    
    #pragma mark-让分割线置顶
    if ([resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [resultTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [resultTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    NSLog(@"searchKey=%@",APPDELEGATE.searchKey);
    if ([APPDELEGATE.searchKey isEqualToString:@""]||APPDELEGATE.searchKey==NULL||APPDELEGATE.searchKey==nil) {
        //设置navigationView为第一响应者,页面载入时会自动弹出键盘
        [navigationView.customSearchBar becomeFirstResponder];
    }else{
        //NSString *content=navigationView.customSearchBar.text;
        //APPDELEGATE.searchKey=content;
        navigationView.customSearchBar.text=APPDELEGATE.searchKey;
        [navigationView.customSearchBar resignFirstResponder];
    }
}

//消除键盘
-(void)hideKeyBoard{
//    [navigationView.customSearchBar resignFirstResponder];
//    [resultTableView removeGestureRecognizer:recognizer];
    NSLog(@"执行了一个手势");
}

//消除键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [navigationView.customSearchBar resignFirstResponder];
    
//    //这里判断当前的数据源中数据的个数
//    if (storeArray.count!=3) {
//        [headerViewFirstSection.showAllButton setTitle:@"隐藏部分店铺" forState:UIControlStateNormal];
//    }else{
//        [headerViewFirstSection.showAllButton setTitle:@"显示全部店铺" forState:UIControlStateNormal];
//    }
//    
//    if (goodArray.count!=3) {
//        [headerViewSecondSection.showAllButton setTitle:@"隐藏部分宝贝" forState:UIControlStateNormal];
//    }else{
//        [headerViewFirstSection.showAllButton setTitle:@"显示全部宝贝" forState:UIControlStateNormal];
//    }
    
}



//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [navigationView.customSearchBar resignFirstResponder];

    NSString *content=navigationView.customSearchBar.text;
    
    APPDELEGATE.searchKey=content;
    
    if (indexPath.section==0) {
        SYJTableViewStoreCell *cell=(SYJTableViewStoreCell *)[tableView cellForRowAtIndexPath:indexPath];
        int storeId=(int)(cell.tag-storeTag);
        
        SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
        storeVC.storeId=storeId;
        [self.navigationController pushViewController:storeVC animated:YES];
        
    }else{
        SYJTableViewGoodCell *cell=(SYJTableViewGoodCell *)[tableView cellForRowAtIndexPath:indexPath];
        int goodId=(int)(cell.tag-goodTag);
        //跳转到宝贝页面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
        SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
        vcc.idd = [NSString stringWithFormat:@"%d",goodId];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vcc animated:YES];
    }
}

//后退
-(void)backImageGoBack{
    [navigationView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//销毁页面之前移除视图
-(void)viewWillDisappear:(BOOL)animated{
    [navigationView removeFromSuperview];
    //显示tabBar
    self.tabBarController.tabBar.hidden=NO;
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
