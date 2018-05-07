//
//  SYJClassifyViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//
//分类页，根据区域对店铺进行分类

#import "SYJClassifyViewController.h"
#import "AFNetworking.h"
#import "SYJCollectionViewCell.h"
#import "SYJHeaderCollectionReusableView.h"
#import "SYJStoreViewController.h"
#import "SYJNavigationView.h"
#import "SYJSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kCellNum 2//每行显示的单元格数目
#define headerIdentifer @"SYJHeaderCollectionReusableView"
@interface SYJClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
{
    UISearchBar *bar;
    SYJNavigationView *navgationView;
}
@property (weak, nonatomic) IBOutlet UITableView *MenuTable;
@property (weak, nonatomic) IBOutlet UICollectionView *ShopCollection;
@property (strong, nonatomic) NSMutableArray *areaArray;//存放所有地区的数组
@property (copy, nonatomic) NSString *areaName;//collectionView当前应该显示的哪个区的数据
@property (strong, nonatomic)NSMutableArray *dataArray;//存放所有店铺的logo和名称
@property (assign, nonatomic)int isSelected;//0:tableView第一次载入数据，用户没有点击任何cell，用户没有上下滑动tableView，此时让tableView选中第一个cell；1:用户点击了cell或者用户滑动了tableView
@property (assign,nonatomic) int selectRow;

@end

@implementation SYJClassifyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置tableView上面的空白消失
    self.automaticallyAdjustsScrollViewInsets =NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden=YES;
    
    //设置cell非人为点击
    self.isSelected=0;
    
    #pragma mark-让分割线置顶
    if ([self.MenuTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.MenuTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.MenuTable respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.MenuTable setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    //设置collectionView载入时显示的分类
    self.areaName=@"全    部";
    
    #pragma mark-注册头视图文件
    [self.ShopCollection registerNib:[UINib nibWithNibName:headerIdentifer bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifer];
    
    #pragma mark-设置tableView的headerView
    self.MenuTable.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, 82, 0.001)];
    //self.MenuTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 568, 82, 0.001)];
    
    #pragma mark-给tableView设置值
    [self setUpDataSourceForTableView];
    
    
    #pragma mark-给collectionView设置数据源
    self.ShopCollection.delegate=self;
    self.ShopCollection.dataSource=self;
    [self setUpDataSourceForCollectionView];
}

//搜索框获取焦点的时候
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SYJSearchViewController *vc=[[SYJSearchViewController alloc] initWithNibName:@"SYJSearchViewController" bundle:nil];
    [navgationView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    //隐藏系统自带的导航
    self.navigationController.navigationBar.hidden=YES;
    
    //设置导航栏
    navgationView=[[[NSBundle mainBundle] loadNibNamed:@"SYJNavigationView" owner:self options:nil] objectAtIndex:0];
    [navgationView.backImage removeFromSuperview];
    [navgationView.customSearchBar removeFromSuperview];
    [navgationView.searchButton removeFromSuperview];
    //设置搜索框的大小
    bar=[[UISearchBar alloc] initWithFrame:CGRectMake(10, 20, 300, 44)];
    bar.delegate=self;
    bar.searchBarStyle=UISearchBarStyleDefault;
    bar.tintColor=cellTextColor;
    
    //获取searchBar中的backgroundView,并移除这个view
    UIView *backgroundview=[[[bar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
    [backgroundview removeFromSuperview];
    
    [navgationView addSubview:bar];
    navgationView.backgroundColor=navigationViewBgcolor;
    //设置搜索按钮
    navgationView.searchButton .titleLabel.font=titleFont;
    [navgationView.searchButton setTitleColor:btnColor forState:UIControlStateNormal];

    [self.navigationController.view addSubview:navgationView];
}

//隐藏导航栏
-(void)viewWillDisappear:(BOOL)animated{
    [navgationView removeFromSuperview];
    self.navigationController.navigationBar.hidden=NO;
}

-(void)setUpDataSourceForTableView{
    //开始显示指示符
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //[SVProgressHUD show];
    [SVProgressHUD show];
    
    self.MenuTable.delegate=self;
    self.MenuTable.dataSource=self;
    self.MenuTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(self.MenuTable.frame.origin.x, self.MenuTable.frame.size.height-30, 82, 30)];
    self.MenuTable.backgroundColor=tableViewColor;
    
    
    //多线程去获取资源
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    NSString *url= [NSString stringWithFormat:@"%@Classification/getAreas",SYJHTTP];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            self.areaArray=dic[@"data"];
            [self.MenuTable reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络数据获取失败!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接有问题，请检查网络连接。"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    //设置cell的文字颜色
    if (indexPath.row==self.selectRow) {
        cell.textLabel.textColor=[UIColor redColor];
    }else{
        cell.textLabel.textColor=cellTextColor;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.areaArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%d",(int)indexPath.row]];

    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%d",(int)indexPath.row]];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"全    部";
    }else{
        if (indexPath.row<[self.areaArray count]) {
            NSDictionary *dic=[self.areaArray objectAtIndex:(indexPath.row-1)];
            cell.textLabel.text=dic[@"store_area"];
        }
    }
    
    #pragma mark-设置textLabel的属性
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.font=textFont;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=cellTextColor;
    
    #pragma mark-设置cell选中的背景视图
    cell.selectedBackgroundView=[[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=cellSelectedColor;
    
    #pragma mark-tableView载入数据时，第一个cell显示红色
    if (indexPath.row==0&&self.isSelected==0) {
        cell.textLabel.textColor=[UIColor redColor];
        cell.tag=10000;
    }
    
    #pragma mark-载入视图的时候，选中第一个cell
    if ([self.areaArray count]>10&&self.isSelected==0) {
        [self selectForFirst];
    }
    
    return cell;
}

#pragma mark-设置cell行的缩进量
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark-点击cell的时候，将相应的区域id传递给collectionView并刷新内容
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.isSelected=1;
    
    self.selectRow=(int)indexPath.row;
    
    [self.MenuTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    UITableViewCell *cell=[self.MenuTable cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor redColor];
    
    //根据不同的label上的值获取不同的店铺的信息
    self.areaName=cell.textLabel.text;
    [self setUpDataSourceForCollectionView];
}

#pragma mark-取消选中cell时执行
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.MenuTable cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=cellTextColor;
}

#pragma mark-滑动tableView时执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.isSelected=1;
}

#pragma mark-选中tableView的第一个cell的执行方法
-(void)selectForFirst{
    NSInteger selectedIndex=0;
    self.selectRow=0;
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.MenuTable selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark-设置collectionView的各个属性值

#pragma mark-获取店铺的数据
-(void)setUpDataSourceForCollectionView{

    //使用URL地址获取相应的数据
    NSString *url= [NSString stringWithFormat:@"%@Classification/getshop",SYJHTTP];
    //NSString *url=@"http://localhost:8888/SYJ/index.php/home/Classification/getshop";
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{@"address":self.areaName};
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=[dic valueForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            self.dataArray=[dic valueForKey:@"data"];
            [self.ShopCollection reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取网络数据失败，请重试。"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络设置有问题，请检查网络设置。"];
    }];
    
    [SVProgressHUD dismiss];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataArray count]>10) {
        return 10;
    }else{
        return [self.dataArray count];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark-设置collectionView的cell
/**
 *  显示分类页中右边店铺的cell
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"MyCell";
    SYJCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([self.dataArray count]!=0) {
        NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
        NSString *textDesc=dic[@"store_name"];
        if ([textDesc length]>4) {
            NSString *subString=[textDesc stringByReplacingOccurrencesOfString:@" " withString:@""];
            subString=[subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            subString=[textDesc substringToIndex:4];
            cell.collLabel.text=subString;
        }else{
            cell.collLabel.text=textDesc;
        }
        cell.collLabel.font=textFont;
        cell.collLabel.textColor=cellTextColor;
        cell.collLabel.lineBreakMode=NSLineBreakByCharWrapping;
        cell.tag=[dic[@"store_id"] intValue]+storeTag;
        NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPSHOPIMG,dic[@"store_logo"]]];
        [cell.collImageView sd_setImageWithURL:url];
    }
    return cell;
}

#pragma mark-每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect=self.ShopCollection.bounds;
    int cellSize=(rect.size.width-10-(kCellNum-1)*5)/kCellNum;
    return CGSizeMake(cellSize,cellSize);
}

#pragma mark-设置collectionView的头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *resuview=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifer forIndexPath:indexPath];
        SYJHeaderCollectionReusableView *view=(SYJHeaderCollectionReusableView *)resuview;
        view.titleLabel.text=self.areaName;
        view.titleLabel.textColor=collectionViewHeaderTextColor;
        view.titleLabel.textAlignment=NSTextAlignmentCenter;
        view.titleLabel.font=titleFont;
        return view;
    }else{
        return nil;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SYJCollectionViewCell *cell=(SYJCollectionViewCell *)[self.ShopCollection cellForItemAtIndexPath:indexPath];
    SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
    storeVC.storeId=(int)cell.tag-storeTag;
    //NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
    //storeVC.storeName=dic[@"store_name"];
    //storeVC.storeImage=cell.collImageView.image;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark-定义头视图的高和宽
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(252, 32);
}

#pragma mark-cell与cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

#pragma mark-section距离四边容器的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5,38, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
