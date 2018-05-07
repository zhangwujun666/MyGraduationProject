//
//  SYJStoreViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJStoreViewController.h"
#import "SYJNavigationView.h"
#import "SYJStoreHeaderCollectionReusableView.h"
#import "SYJStoreCollectionViewCell.h"
#import "SYJStoreGoodTypeCollectionViewCell.h"
#import "AFNetworking.h"
#import "SYJStoreCollectionViewFlowLayout.h"
#import "SYJSearchViewController.h"
#import "SYJMapViewController.h"
#import "MJRefresh.h"
#import "SYJBaybyTableViewController.h"
#import "AppDelegate.h"
#import "SYJStoreHeader.h"

//static const CGFloat MJDuration = 2.0;//定义静态的变量

#define HeaderIdentifer @"SYJStoreHeaderCollectionReusableView"
#define CellIdentifer @"SYJStoreCollectionViewCell"
#define CellDesc @"CellDesc"
#define TypeIdentifer @"SYJStoreGoodTypeCollectionViewCell"
#define TypeCell @"TypeCell"
#define kCellNum 2//每行显示单元格的数目
#define menuCellNum 5//设置衣服的种类
#define menuSelectedColor [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]
#define menuCellSelectedColor [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0]



@interface SYJStoreViewController ()<SearchDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,storeControllerDelegate,UISearchBarDelegate>
{
    SYJNavigationView *naviagtionView;//声明自定义导航的view
    UISearchBar *bar;//声明自定义的searchBar
    SYJStoreHeaderCollectionReusableView *headerView;
    NSDictionary *storeHeaderData;//存储店铺的Header中的数据
    NSDictionary *typeDic;//获取店铺中的类别
    int isSelected;//是否选中全部商品
    NSMutableArray *goodsArray;//存放全部商品的数组
    NSString *selectType;//设置当前商品的类别
    NSMutableArray *reloadArray;//更新商品种类的cell
    SYJStoreCollectionViewFlowLayout *updateLayout;//设置新的flowLayout布局
    NSMutableArray *refreshGoods;//获取
    int refreshCount;//记录刷新次数
    NSString *clickedBtnName;//点击的按钮名称
    SYJStoreHeader *storeHeader;//定义一个头视图的模型
    NSIndexPath *selectedIndexPath;//定义一个indexPath用来存储选中的cell
}
@property (weak, nonatomic) IBOutlet UICollectionView *storeCollectionView;


@end

@implementation SYJStoreViewController

#pragma mark-headerView的头部刷新

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    isSelected=0;
    refreshCount=1;//刷新0次
    selectType=@"%";//查询出所有类型
    clickedBtnName=@"全部商品";//初始化选中的按钮名称
    selectedIndexPath=[NSIndexPath indexPathForItem:-1 inSection:-1];//选中的cell的indexPath
    
    reloadArray=[NSMutableArray array];
    updateLayout=[[SYJStoreCollectionViewFlowLayout alloc] init];
    self.storeCollectionView.collectionViewLayout=updateLayout;
    self.storeCollectionView.showsVerticalScrollIndicator=NO;
    refreshGoods=[NSMutableArray array];
    
    
    //注册一个Header文件
    [self.storeCollectionView registerNib:[UINib nibWithNibName:HeaderIdentifer bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifer];
    
    //注册一个cell
//    UINib *nib=[UINib nibWithNibName:CellIdentifer bundle:nil];
    [self.storeCollectionView registerNib:[UINib nibWithNibName:@"SYJStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellDesc];

    //注册另外一个cell
//    UINib *typeNib=[UINib nibWithNibName:TypeIdentifer bundle:nil];
    [self.storeCollectionView registerNib:[UINib nibWithNibName:@"SYJStoreGoodTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TypeCell];
    
    //设置代理对象
    self.storeCollectionView.dataSource=self;
    self.storeCollectionView.delegate=self;
    
    //获取店铺数据
    [self setUpStore];
    
    //获取店铺中的商品类别
    [self setUpGoodType];
    
    //获取店铺中的宝贝
    [self setUpGoodShow];
    
    //设置自动刷新
    [self refreshFooter];
}

#pragma mark-自动刷新
-(void)refreshFooter{
    __weak __typeof(self) weakSelf=self;
    
    //下拉加载
    self.storeCollectionView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //重新去请求店铺的数据和宝贝的数据
        [weakSelf setUpStore];
        [weakSelf.storeCollectionView.header endRefreshing];
    }];
    
    
    
    //上拉刷新
    self.storeCollectionView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //获取刷新数据
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter=[[NSDictionary alloc] init];
        NSString *url=@"";
        
        if ([clickedBtnName isEqualToString:@"全部商品"]) {
            parameter=@{
                      @"store_id":[NSNumber numberWithInt:self.storeId],
                      @"goods_type":selectType,
                      @"minNum":@(0),
                      @"maxNum":@(4+4*refreshCount)
                      };
            url=[NSString stringWithFormat:@"%@Shop/getGoodByOrder",SYJHTTP];
        }else if ([clickedBtnName isEqualToString:@"上新"]){
            parameter=@{
                      @"store_id":[NSNumber numberWithInt:self.storeId],
                      @"minNum":@(0),
                      @"maxNum":@(4+4*refreshCount)
                      };
            url=[NSString stringWithFormat:@"%@Shop/getNewGood",SYJHTTP];
        }else{
            parameter=@{
                      @"store_id":[NSNumber numberWithInt:self.storeId],
                      @"minNum":@(0),
                      @"maxNum":@(4+4*refreshCount)
                      };
            url=[NSString stringWithFormat:@"%@Shop/getPromotionGoods",SYJHTTP];
        }
        
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic=(NSDictionary *)responseObject;
            NSString *code=dic[@"code"];
            if ([code isEqualToString:@"200"]) {
                goodsArray=dic[@"data"];
                
                if (4*refreshCount>=goodsArray.count) {
                    //self.storeCollectionView.footer.hidden=YES;
                    [weakSelf.storeCollectionView.footer noticeNoMoreData];
                    return ;
                }
                
                NSMutableArray *indexArray=[NSMutableArray array];
                for (int i=4*refreshCount; i<goodsArray.count; i++) {
                    NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:1];
                    [indexArray addObject:path];
                }
                
                NSArray *tempArray=[indexArray copy];
                //刷新当前的商品数组
                //NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:1];
                //[self.storeCollectionView reloadItemsAtIndexPaths:[indexArray copy]];
                [self.storeCollectionView insertItemsAtIndexPaths:tempArray];
                
                //改变刷新次数
                refreshCount++;
                
                //关闭刷新
                [weakSelf.storeCollectionView.footer endRefreshing];
                
            }else{
                NSLog(@"获取网络数据失败,请重试。");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"网络设置有问题,请检查网络设置.");
        }];
        
        
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //刷新数据显示在collectionView上
//            [weakSelf.storeCollectionView reloadData];
//            //结束footer的刷新
//            
//        });
    }];
    
    //首先默认隐藏footer
    self.storeCollectionView.footer.hidden=YES;
    
}

#pragma mark-显示地图
-(void)showMap{
    NSLog(@"显示地图。。。");
    SYJMapViewController *mapViewController=[[SYJMapViewController alloc] initWithNibName:@"SYJMapViewController" bundle:nil];
//    self.navigationItem=@"返回";
    mapViewController.storeId=self.storeId;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark-实现点击全部商品的代理方法
/**
 *  当点击全部商品时
 *  改变section0的cell的高度，让cell的内容显示出来
 *
 */
-(void)allGoodClicked{
    //初始化refreshCount
    refreshCount=1;
    //设置选中按钮的名称
    clickedBtnName=@"全部商品";
    //重新设置
    [self.storeCollectionView.footer resetNoMoreData];
    //重新设置选中的indexPath
    selectedIndexPath=[NSIndexPath indexPathForItem:-1 inSection:-1];
    //设置全部商品label的颜色
    storeHeader.allgoodcolor=[UIColor redColor];
    storeHeader.upnewgoodcolor=cellTextColor;
    storeHeader.promotegoodcolor=cellTextColor;
    
    //设置选中标志并且刷新数据
    if (isSelected==0) {
        isSelected=1;
        if ([reloadArray count]>0) {
            [self.storeCollectionView deleteItemsAtIndexPaths:reloadArray];
            [reloadArray removeAllObjects];
        }
        
        for (int i=0; i<typeDic.count; i++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            [reloadArray addObject:indexPath];
        }
        
        [self.storeCollectionView insertItemsAtIndexPaths:reloadArray];
        selectType=@"%";
        [self setUpGoodShow];
    }else{
        [self removeTypeCell];
    }
}

#pragma mark-实现点击上新的代理方法
-(void)upNewGoodClicked{
    //初始化refreshCount
    refreshCount=1;
    //设置选中的按钮的标题
    clickedBtnName=@"上新";
    //重新设置
    [self.storeCollectionView.footer resetNoMoreData];
    //设置全部商品的颜色
    storeHeader.allgoodcolor=cellTextColor;
    storeHeader.upnewgoodcolor=[UIColor redColor];
    storeHeader.promotegoodcolor=cellTextColor;
    
    //先移除section0中的cell,获取网络资源刷新数据
    [self removeTypeCell];
    //获得最新上架商品
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{
                              @"store_id":[NSNumber numberWithInt:self.storeId],
                              @"minNum":@(0),
                              @"maxNum":@(4)
                              };
    NSString *url=[NSString stringWithFormat:@"%@Shop/getNewGood",SYJHTTP];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        //NSString *code=dic[@"code"];
        
            goodsArray=dic[@"data"];
            //刷新当前的商品数组
            NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:1];
            [self.storeCollectionView reloadSections:indexSet];
        
        //显示当前的footer
        if (goodsArray.count>=4) {
            self.storeCollectionView.footer.hidden=NO;
        }
        
        if (goodsArray.count==0||goodsArray==nil||goodsArray.class==[NSNull class]) {
            self.storeCollectionView.footer.hidden=NO;
            [self.storeCollectionView.footer noticeNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络设置有问题,请检查网络设置.");
    }];
}

#pragma mark-实现点击促销的代理方法
-(void)promotionGoodClicked{
    //初始化refreshCount
    refreshCount=1;
    //设置选中按钮的标题
    clickedBtnName=@"促销";
    //重新设置
    [self.storeCollectionView.footer resetNoMoreData];
    //设置全部label的颜色
    storeHeader.allgoodcolor=cellTextColor;
    storeHeader.upnewgoodcolor=cellTextColor;
    storeHeader.promotegoodcolor=[UIColor redColor];
    
    [self removeTypeCell];
    //获得促销商品
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{
                              @"store_id":[NSNumber numberWithInt:self.storeId],
                              @"minNum":@(0),
                              @"maxNum":@(4)
                              };

    NSString *url=[NSString stringWithFormat:@"%@Shop/getPromotionGoods",SYJHTTP];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        //NSString *code=dic[@"code"];
            
        goodsArray=dic[@"data"];
        //刷新当前的商品数组
        NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:1];
        [self.storeCollectionView reloadSections:indexSet];
        
        //显示当前的footer
        if (goodsArray.count>=4) {
            self.storeCollectionView.footer.hidden=NO;
        }
        
        if (goodsArray.count==0||goodsArray==nil||goodsArray.class==[NSNull class]) {
            self.storeCollectionView.footer.hidden=NO;
            [self.storeCollectionView.footer noticeNoMoreData];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络设置有问题,请检查网络设置.");
    }];
}

#pragma mark-移除Section0中的分类cell
-(void)removeTypeCell{
    isSelected=0;
    if ([reloadArray count]>0) {
        [self.storeCollectionView deleteItemsAtIndexPaths:reloadArray];
        [reloadArray removeAllObjects];
    }
}

#pragma mark-设置店铺的数据
-(void)setUpStore{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //显示加载指示符
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameter=@{
                              @"store_id":[NSNumber numberWithInt:self.storeId],
                              @"userId":@(APPDELEGATE.user.userID)
                              };
//    NSString *url=[NSString stringWithFormat:@"http://localhost:8888/SYJ/index.php/home/shop/getShopById?store_id=%d",self.storeId];
    NSString *url=[NSString stringWithFormat:@"%@Shop/getShopById",SYJHTTP];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            storeHeaderData=dic[@"data"];
            //初始化店铺的头部
            storeHeader=[[SYJStoreHeader alloc] init];
            storeHeader.storeName=storeHeaderData[@"store_name"];
            storeHeader.likeCount=[storeHeaderData[@"collections"] intValue];
            
            //设置全部商品，上新和促销商品的数量
            storeHeader.allgood=@"全部商品";
            storeHeader.allgoodcount=storeHeaderData[@"goodCount"];
            storeHeader.allgoodcolor=cellTextColor;
            
            storeHeader.upnewgood=@"上新";
            storeHeader.upnewgoodcount=storeHeaderData[@"earlyCount"];
            storeHeader.upnewgoodcolor=cellTextColor;
            
            storeHeader.promotegood=@"促销";
            storeHeader.promotegoodcount=storeHeaderData[@"promotionCount"];
            storeHeader.promotegoodcolor=cellTextColor;
            
            //保存店铺关注的图片
            if ([storeHeaderData[@"islike"] intValue]==1) {
                storeHeader.likeImage=[UIImage imageNamed:@"didlikeStore.png"];
            }else{
                storeHeader.likeImage=[UIImage imageNamed:@"likeStore.png"];
            }
            
            //设置店名和店铺的图片
            self.storeName=storeHeaderData[@"store_name"];
            
            //使用GCD获取店铺图片更新
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               //创建URL对象
               NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SYJHTTPSHOPIMG,storeHeaderData[@"store_logo"]]];
                NSData *data=[[NSData alloc] initWithContentsOfURL:url];
                UIImage *img=[[UIImage alloc] initWithData:data];
                
                //保存店铺的logo
                storeHeader.storelogo=img;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.storeImage=img;
                    //只刷新第一个section
                    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
                    [self.storeCollectionView reloadSections:indexSet];
                });
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络数据获取失败,请重试."];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络有问题,请检查网络连接."];
    }];
}

#pragma mark-获取店铺中商品的类别
-(void)setUpGoodType{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{@"store_id":[NSNumber numberWithInt:self.storeId]};
    NSString *url=[NSString stringWithFormat:@"%@Shop/getGoodType",SYJHTTP];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            typeDic=dic[@"data"];
//            NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
//            //刷新第0个section
//            [self.storeCollectionView reloadSections:indexSet];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络数据获取失败!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接有问题,请检查网络连接."];
    }];
}

#pragma mark-获取店铺中的商品,按销量排名
-(void)setUpGoodShow{
    //初始化数组
    goodsArray=[NSMutableArray array];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{
                              @"store_id":[NSNumber numberWithInt:self.storeId],
                              @"goods_type":selectType,
                              @"minNum":@(0),
                              @"maxNum":@(4)
                              };
    NSString *url=[NSString stringWithFormat:@"%@Shop/getGoodByOrder",SYJHTTP];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            goodsArray=dic[@"data"];
            //刷新当前的商品数组
            NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:1];
            [self.storeCollectionView reloadSections:indexSet];
            
            //显示当前的footer
//            if (goodsArray.count>=4) {
//                self.storeCollectionView.footer.hidden=NO;
//            }
//            
//            if (goodsArray.count==0||goodsArray==nil||goodsArray.class==[NSNull class]) {
//                self.storeCollectionView.footer.hidden=NO;
//                [self.storeCollectionView.footer noticeNoMoreData];
//            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取网络数据失败,请重试。"];
            //显示当前的footer
            if (goodsArray.count>=4) {
                self.storeCollectionView.footer.hidden=NO;
            }
            
            if (goodsArray.count==0||goodsArray==nil||goodsArray.class==[NSNull class]) {
                self.storeCollectionView.footer.hidden=NO;
                [self.storeCollectionView.footer noticeNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络设置有问题,请检查网络设置."];
    }];
    
    [SVProgressHUD dismiss];
}


#pragma mark-返回每一个cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    //注册一个cell
//    UINib *nib=[UINib nibWithNibName:CellIdentifer bundle:[NSBundle mainBundle]];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifer];
//    
//    //注册另外一个cell
//    UINib *typeNib=[UINib nibWithNibName:TypeIdentifer bundle:[NSBundle mainBundle]];
//    [collectionView registerNib:typeNib forCellWithReuseIdentifier:TypeIdentifer];
    
    if (indexPath.section==0) {
        SYJStoreGoodTypeCollectionViewCell *typeCell=(SYJStoreGoodTypeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TypeCell forIndexPath:indexPath];
        
        NSString *key=[NSString stringWithFormat:@"type%u",(int)indexPath.row];
        if (typeDic.count>0) {
           typeCell.goodTypeLabel.text=[typeDic valueForKey:key];
        }
        
        typeCell.layer.cornerRadius=5.0;
        typeCell.layer.backgroundColor=[tableViewColor CGColor];
        typeCell.goodTypeLabel.textColor=btnColor;
        
        //将上次选中的cell再重新选中
        if (indexPath.row==selectedIndexPath.row) {
            typeCell.layer.backgroundColor=[menuSelectedColor CGColor];
        }
        
        return typeCell;
    }else{
        SYJStoreCollectionViewCell *cell=(SYJStoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellDesc forIndexPath:indexPath];
        
        if (cell.collectionImageView.image!=nil) {
            cell.collectionImageView.image=nil;
        }
        if (cell.goodNameLabel.text!=nil) {
            cell.goodNameLabel.text=@"";
        }
        if (cell.priceLabel.text!=nil) {
            cell.priceLabel.text=@"";
        }
        if (cell.goodCountLabel.text!=nil) {
            cell.goodCountLabel.text=@"";
        }
        
        if (goodsArray.count!=0) {
            NSDictionary *dic=[goodsArray objectAtIndex:indexPath.row];
            cell.tag=[dic[@"goods_id"] intValue]+goodTag;
            //NSURL *goodUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPGOODIMAGE,dic[@"goods_image"]]];
            NSURL *goodUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@goodimg/%@",SYJHTTPIMG,dic[@"goods_image"]]];
            [cell.collectionImageView sd_setImageWithURL:goodUrl];
            cell.goodNameLabel.text=dic[@"goods_name"];
            cell.priceLabel.text=[NSString stringWithFormat:@"¥%.2f",[dic[@"goods_price"] floatValue]];
            cell.priceLabel.textColor=[UIColor redColor];
            cell.goodCountLabel.text=[NSString stringWithFormat:@"销量:%@",dic[@"goods_sales"]];
        }else{
                self.storeCollectionView.footer.hidden=NO;
                [self.storeCollectionView.footer noticeNoMoreData];
        }
        
        cell.backgroundColor=tableViewColor;
        
        return cell;
    }

}

#pragma mark-添加头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
            UICollectionReusableView *reuseView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifer forIndexPath:indexPath];
            headerView=(SYJStoreHeaderCollectionReusableView *)reuseView;
            headerView.delegate=self;
            headerView.storeNameLabel.adjustsFontSizeToFitWidth=YES;
    
            UIImage *image=[UIImage imageNamed:@"store.jpg"];
            if (indexPath.section==0) {
                headerView.backgroundImageView.image=image;
                headerView.backgroundColor=[UIColor clearColor];
                headerView.storeNameLabel.text=self.storeName;
                headerView.storeImage.image=self.storeImage;
                
                if (storeHeader!=nil) {
                    headerView.likeCount.text=[NSString stringWithFormat:@"%d人关注",storeHeader.likeCount];
                    [headerView.likeButton setImage:storeHeader.likeImage forState:UIControlStateNormal];
                    
                    headerView.allGoodLabel.text = storeHeader.allgood;
                    headerView.allGoodLabel.textColor = storeHeader.allgoodcolor;
                    headerView.allGoodCountLabel.text = storeHeader.allgoodcount;
                    headerView.allGoodCountLabel.textColor = storeHeader.allgoodcolor;
                    
                    headerView.upNewGoodLabel.text = storeHeader.upnewgood;
                    headerView.upNewGoodLabel.textColor = storeHeader.upnewgoodcolor;
                    headerView.upNewGoodCountLabel.text = storeHeader.upnewgoodcount;
                    headerView.upNewGoodCountLabel.textColor = storeHeader.upnewgoodcolor;
                    
                    headerView.promotionGoodLabel.text = storeHeader.promotegood;
                    headerView.promotionGoodLabel.textColor = storeHeader.promotegoodcolor;
                    headerView.promotionGoodCountLabel.text = storeHeader.promotegoodcount;
                    headerView.promotionGoodCountLabel.textColor = storeHeader.promotegoodcolor;
                    
                    //headerView.allGoodCountLabel.text=storeHeaderData[@"goodCount"];
                    //headerView.upNewGoodCountLabel.text=storeHeaderData[@"earlyCount"];
                    //headerView.promotionGoodCountLabel.text=storeHeaderData[@"promotionCount"];
                    
//                    if (isSelected==1) {
//                        headerView.allGoodLabel.textColor=[UIColor redColor];
//                        headerView.allGoodCountLabel.textColor=[UIColor redColor];
//                    }else{
//                        headerView.allGoodLabel.textColor=cellTextColor;
//                        headerView.upNewGoodLabel.textColor=cellTextColor;
//                        headerView.promotionGoodLabel.textColor=cellTextColor;
//                        headerView.allGoodCountLabel.textColor=cellTextColor;
//                    }
                }
            }
    
            if (indexPath.section>0) {
                if (headerView.backgroundImageView.image!=nil) {
                    headerView.backgroundImageView.image=nil;
                }
                //239 237 244
                UIColor *sectionColor=[UIColor colorWithRed:239.0/255 green:237.0/255 blue:244.0/255 alpha:1];
                headerView.backgroundColor=sectionColor;
            }

            return headerView;
}

#pragma mark-设置头视图的宽和高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(320, 150);
    }else if (section==1){
        return CGSizeMake(320, 5);
    }else{
        return CGSizeMake(0,0);
    }
}

#pragma mark-设置Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

#pragma mark-设置Cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //设置艉部控件的显示和隐藏
    //self.storeCollectionView.footer.hidden=goodsArray.count>4;
    if (goodsArray.count>=4) {
        self.storeCollectionView.footer.hidden=NO;
    }else{
        self.storeCollectionView.footer.hidden=YES;
    }
    
    if (section==0) {
        if (isSelected==1) {
            if(typeDic.count>0){
                return typeDic.count;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
    if (goodsArray.count==0) {
        return 0;
    }else{
        return goodsArray.count;
    }
    
}

#pragma mark-每一个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect=[[UIScreen mainScreen] bounds];
    int cellSize=(rect.size.width-10-(kCellNum-1)*5)/kCellNum;
    if (indexPath.section==0) {
        if (isSelected==1) {
            int typeCellSize=(rect.size.width-10-(menuCellNum-1)*5)/menuCellNum;
            return CGSizeMake(typeCellSize,25);
        }else{
            return CGSizeMake(0.001,0.001);
        }
    }
    return CGSizeMake(cellSize,220);
}
#pragma mark-将要绘制cell时执行的方法
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //self.storeCollectionView.collectionViewLayout=updateLayout;
}

#pragma mark-选中cell时执行的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        SYJStoreGoodTypeCollectionViewCell *cell=(SYJStoreGoodTypeCollectionViewCell *)[self.storeCollectionView cellForItemAtIndexPath:indexPath];
        cell.layer.backgroundColor=[menuSelectedColor CGColor];
//        isSelected=0;
        selectType=cell.goodTypeLabel.text;
        [self setUpGoodShow];
        //记录选中的cell
        selectedIndexPath=indexPath;
        
        refreshCount=1;
        //重新设置
        [self.storeCollectionView.footer resetNoMoreData];
    }else{
        //跳转到宝贝页面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
        SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
        SYJStoreCollectionViewCell *cell=(SYJStoreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        int goodId=(int)(cell.tag-goodTag);
        vcc.idd =[NSString stringWithFormat:@"%d",goodId];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vcc animated:YES];
    }
}

#pragma mark-取消选中cell
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        SYJStoreGoodTypeCollectionViewCell *cell=(SYJStoreGoodTypeCollectionViewCell *)[self.storeCollectionView cellForItemAtIndexPath:indexPath];
        cell.layer.backgroundColor=[tableViewColor CGColor];
    }
}


//#pragma mark-cell与cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    return 5;
}

#pragma mark-距离容器四周边界的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5,5);
}


-(void)viewWillAppear:(BOOL)animated{
    //隐藏TabBar
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
    [self setNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    //移除navgationView
    [naviagtionView removeFromSuperview];
    //显示TabBar
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
}

#pragma mark-设置导航
-(void)setNavigation{
    //添加一个自定义view
    naviagtionView=[[[NSBundle mainBundle] loadNibNamed:@"SYJNavigationView" owner:self options:nil] objectAtIndex:0];
    naviagtionView.frame=CGRectMake(0, 0, 320, 64);
    
    //设置searchBar为白色
    UIView *backgroundView=[[[naviagtionView.customSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
    [backgroundView removeFromSuperview];
    [naviagtionView.searchButton removeFromSuperview];
    [naviagtionView.customSearchBar removeFromSuperview];
    
    bar=[[UISearchBar alloc] initWithFrame:CGRectMake(24, 20, 290, 44)];
    bar.searchBarStyle=UISearchBarStyleDefault;
    bar.delegate=self;
    
    UIView *barView=[bar.subviews objectAtIndex:0];
    UIView *subView0=[barView.subviews objectAtIndex:0];
    [subView0 removeFromSuperview];
    
    
    bar.tintColor=cellTextColor;
    
    [naviagtionView addSubview:bar];
    
//    [naviagtionView.searchButton setBackgroundImage:[UIImage imageNamed:@"class.png"] forState:UIControlStateNormal];
//    [naviagtionView.searchButton setTitle:@"" forState:UIControlStateNormal];
//    naviagtionView.searchButton.frame=CGRectMake(272, 28, 24, 24);
    naviagtionView.backgroundColor=navigationViewBgcolor;
    
    [self.navigationController.view addSubview:naviagtionView];
    naviagtionView.delegate=self;
}

//加关注
-(void)addLike:(UIButton *)button andLabel:(UILabel *)label{
    //1.先网络请求获得数据，判断用户是否点过赞
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //NSString *path=@"http://localhost:8888/SYJ/index.php/home/shop/addlike";
    NSString *path=[NSString stringWithFormat:@"%@Shop/addlike",SYJHTTP];
    NSDictionary *parameter=@{
                              @"userId":@(APPDELEGATE.user.userID),
                              @"storeId":@(self.storeId)
                              };
    [manager GET:path parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSString *state=dic[@"state"];
            if ([state isEqualToString:@"已关注"]) {
                [button setImage:[UIImage imageNamed:@"didlikeStore.png"] forState:UIControlStateNormal];
                storeHeader.likeImage=[UIImage imageNamed:@"didlikeStore.png"];
                [label setText:[NSString stringWithFormat:@"%d人关注",[dic[@"currentlikecount"] intValue]]];
                storeHeader.likeCount=[dic[@"currentlikecount"] intValue];
            }else{
                [button setImage:[UIImage imageNamed:@"likeStore.png"] forState:UIControlStateNormal];
                storeHeader.likeImage=[UIImage imageNamed:@"likeStore.png"];
                [label setText:[NSString stringWithFormat:@"%d人关注",[dic[@"currentlikecount"] intValue]]];
                storeHeader.likeCount=[dic[@"currentlikecount"] intValue];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络数据请求不成功..."];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接有问题,请检查网络连接..."];
    }];
    //2.置换关注按钮的背景图片
    //3.改变关注Label的内容
}

//搜索框获取焦点时，跳转到搜索界面
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SYJSearchViewController *searchViewController=[[SYJSearchViewController alloc] initWithNibName:@"SYJSearchViewController" bundle:nil];
    [naviagtionView removeFromSuperview];
    [self.navigationController pushViewController:searchViewController animated:YES];
    return YES;
}



#pragma mark-返回到上一页
-(void)backImageGoBack{
    [naviagtionView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
