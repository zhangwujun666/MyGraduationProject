//
//  SYJBaybyTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJBaybyTableViewController.h"
#import "SYJbabyhead.h"
#import "SYJOrdderTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "CarView.h"
#import "UIImageView+AFNetworking.h"
#import "SYJCanshuView.h"
#import "SYJSizeselect.h"
#import "SYJgoodsCommentViewController.h"
#import "UIImageView+AFNetworking.h"
#import "babyheadview.h"
#import "SYJShopdetailTableViewController.h"
#import "SYJCarGoodsTableViewController.h"
#import "SYJMapViewController.h"
#import "SYJStoreViewController.h"
#import "SYJStore.h"
#import "SYJGood.h"
#import "SYJLoginViewController.h"
#import "SYJAddAddressTableViewController.h"
#import "SYJShowimageCollectionViewControllerCell.h"
#import "UMSocial.h"
@interface SYJBaybyTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UMSocialUIDelegate>
{
    
   
    NSIndexPath *scrollIndexPath;
    SYJbabyhead *VCHead;
    SYJOrdderTableViewController *vc;
    __weak IBOutlet UIPageControl *Pag;
    NSMutableDictionary *Detaildic;
    NSMutableArray *imagearr;
    NSMutableArray *sizearr;
    NSMutableArray *colourarr;
    CarView *CarVc;
    NSDictionary *dic;
    UIImageView *imagevieww;
    NSDictionary *addressdic;
    SYJCanshuView *CanShuVc;
    SYJSizeselect *vvc;
    UIView *view;
    UIButton *bt;
    UIButton *Bttwo;
    int d;
    int d1;
    int d3;
    int d4;
    int j;
    int n;
    NSString *Babysize;
    NSString *Babycolour;
    NSMutableArray *commentarr;
    NSMutableArray *goodimagearr;
    NSDictionary *commentdic;
    NSDictionary *dicbaby;
    NSString *img;
    babyheadview *headvc;
    UIButton *btt;
    UIButton *twobt;
    UIButton *fenxiangButton;
    NSString *store;
   NSMutableDictionary *storedic;
    UIScrollView *ScrollVc;
    NSMutableArray *oldimage;
    UIPageControl *pagg;
    
    __weak IBOutlet UIActivityIndicatorView *loadclict;
}
@end

@implementation SYJBaybyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CollectionShowimage.delegate=self;
    self.CollectionShowimage. dataSource=self;
   CarVc=[[[NSBundle mainBundle]loadNibNamed:@"CarView" owner:self options:nil]objectAtIndex:0];
    CarVc.frame=CGRectMake(0, [[UIScreen mainScreen]bounds].size.height-50, [[UIScreen mainScreen]bounds].size.width, 100);
    self.tabBarController.tabBar.hidden=YES;
    
   [self.navigationController.view addSubview:CarVc];
    
    Detaildic=[[NSMutableDictionary alloc]init];
    dic=[[NSDictionary alloc]init];
    imagearr=[NSMutableArray array];
    sizearr=[NSMutableArray array];
    colourarr=[NSMutableArray array];
    Babysize=[[NSString alloc]init];
    Babycolour=[[NSString alloc]init];
    commentarr=[NSMutableArray array];
    commentdic=[[NSDictionary alloc]init];
    storedic=[[NSMutableDictionary alloc]init];
    dicbaby=[[NSMutableDictionary alloc]init];
    addressdic=[[NSDictionary alloc]init];
    goodimagearr=[NSMutableArray array];
    img=[[NSString alloc]init];
    //[self creatbuttontwo];
    [self Requestdetail];
    [self rquest];
    [self headimagee];
    [self creatbabyhead];
    [self creatfenxiangButton];
    //[self creatbuttontwo];
    d=0;
    j=1;
    n=1;
    APPDELEGATE.isaddress=NO;
    APPDELEGATE.Stateone=NO;
    APPDELEGATE.ColourctState=NO;
    APPDELEGATE.outrightplay=NO;
    self.detailimage.scrollEnabled=YES;
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectSize) name:@"name" object:nil];//加入购物车
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatView) name:@"namee" object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadd) name:@"nameee" object:nil];
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addcar) name:@"addcar" object:nil];//立刻购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SureSizeSelect) name:@"sure" object:nil];//确定购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gostore) name:@"gostore" object:nil];
    [self creatbutton];
    scrollIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    self.tableView.showsVerticalScrollIndicator=NO;
    [self requersCarnumber];
    self.CollectionShowimage.showsVerticalScrollIndicator=NO;
    [loadclict startAnimating];
}
-(void)creatbutton{
    btt=[[UIButton alloc]initWithFrame:CGRectMake(20, 27, 30, 30)];
    
    [btt setImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [btt addTarget:self action:@selector(Return) forControlEvents:UIControlEventTouchUpInside];
 
    btt.layer.cornerRadius=btt.frame.size.width/2;
    [btt setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view addSubview:btt];
    
}
-(void)creatbuttontwo{
    twobt=[[UIButton alloc]initWithFrame:CGRectMake(200, 27, 30, 30)];
    
    [twobt setImage:[UIImage imageNamed:@"ll.png"] forState:UIControlStateNormal];
    [twobt addTarget:self action:@selector(YMShar) forControlEvents:UIControlEventTouchUpInside];
    
    twobt.layer.cornerRadius=twobt.frame.size.width/2;
    [twobt setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view addSubview:twobt];
    
}
-(void)creatfenxiangButton{
    fenxiangButton=[[UIButton alloc]initWithFrame:CGRectMake(225, 30, 30, 30)];
    
   // [fenxiangButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
   
    [self.navigationController.view addSubview:fenxiangButton];
}
-(void)YMShar{
    [self Um];
}
-(void)Return{
    [self.navigationController popViewControllerAnimated:YES];
    [btt removeFromSuperview];
}

-(void)headimagee{
    self.userheadimg.contentMode=UIViewContentModeScaleAspectFill;
    self.userheadimg.layer.cornerRadius=self.userheadimg.frame.size.width/2;
    self.userheadimg.layer.masksToBounds=YES;
    self.userheadimg.layer.borderColor=[[UIColor whiteColor]CGColor];
    
}
#pragma mark 宝贝详情内容
-(void)Requestdetail{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    oldimage=[NSMutableArray array];
    NSString *str=[NSString stringWithFormat:@"%@%@",kbabytail,self.idd];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        dic=(NSDictionary *)responseObject;
        Detaildic=[dic objectForKey:@"detail"];
        storedic=[dic objectForKey:@"storeInfo"];
        goodimagearr=[dic objectForKey:@"detailimage"];//商品详情内的图片
        if(goodimagearr.count>0){
            [ self.CollectionShowimage reloadData ];
        }
        self.BabyName.text=[Detaildic objectForKey:@"goods_name"];
        NSString *price=[NSString stringWithFormat:@"￥%@.00",[Detaildic objectForKey:@"goods_price"]];
        self.babyPrice.text=price;
        self.babySales.text=[NSString stringWithFormat:@"销量%@件",[Detaildic objectForKey:@"goods_sales"]];
        
        self.StoreAddress.text=[Detaildic objectForKey:@"goods_address"];
       store=[Detaildic objectForKey:@"goods_shop_id"];
        
        sizearr=[dic objectForKey:@"size"];
        
        colourarr=[dic objectForKey:@"colour"];
        
       
        NSMutableArray *arr=[dic objectForKey:@"t_scrollimage"];
        for(int i=0;i<arr.count;i++){
            NSDictionary *dicimgname=[arr objectAtIndex:i];
            
            NSString *strimgname=[dicimgname objectForKey:@"scrollimage_name"];
        NSString *str=[NSString stringWithFormat:@"%@%@",kscrollview,strimgname];
        NSURL *url=[NSURL URLWithString:str];
        NSData *data=[NSData dataWithContentsOfURL:url];
        UIImage *imgg=[UIImage imageWithData:data];
            [oldimage addObject:imgg];
        
            self.ShowScrollView.delegate=self;
            self.ShowScrollView.pagingEnabled=YES;
            self.ShowScrollView.showsHorizontalScrollIndicator=NO;
            

            int with=self.ShowScrollView.frame.size.width;
            int height=self.ShowScrollView.frame.size.height;
            self.ShowScrollView.contentSize=CGSizeMake(arr.count*with, height);
            UIImageView *imageview=[[UIImageView alloc]init];
            imageview.image=imgg;
           
            imageview.frame=CGRectMake(i*with, 0, with, self.ShowScrollView.frame.size.height);//表示第i个图片的imagerview宽度，宽度是不断变化的
            [self.ShowScrollView setContentMode:UIViewContentModeScaleAspectFit];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            [self.ShowScrollView addSubview:imageview];
            
            UITapGestureRecognizer *Gest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changsize:)];
            
            [self.ShowScrollView addGestureRecognizer:Gest];
            //[self requestdetailimage];
            [loadclict stopAnimating];
            loadclict.hidden=YES;
            n++;
        }
        Pag.numberOfPages= arr.count;
        Pag.currentPage=0;
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    
}
#pragma mark 放大浏览的事件
-(void)changsize:(UITapGestureRecognizer *)gesture{
    ScrollVc=[[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.navigationController.view addSubview:ScrollVc];
    [ScrollVc setBackgroundColor:[UIColor blackColor]];
    pagg=[[UIPageControl alloc]initWithFrame:CGRectMake(160, [UIScreen mainScreen].bounds.size.height-50, 100,20 )];
    for(int m=0;m<oldimage.count;m++){
        UIImageView *imgview=[[UIImageView alloc]initWithFrame:self.view.frame];
       // [imgview setImageWithURL:url];
        imgview.image=[oldimage objectAtIndex:m];
        int with=[UIScreen mainScreen].bounds.size.width;
        imgview.frame=CGRectMake(m*with, 0, with,[UIScreen mainScreen].bounds.size.height);
        ScrollVc.contentSize=CGSizeMake(oldimage.count*with, [UIScreen mainScreen].bounds.size.height);
        ScrollVc.contentOffset=CGPointMake(Pag.currentPage*with, 0);
        [ScrollVc addSubview:imgview];
        
        ScrollVc.showsVerticalScrollIndicator=NO;
        ScrollVc.pagingEnabled=YES;
        [imgview setContentMode:UIViewContentModeScaleAspectFit];
        UITapGestureRecognizer *tapGst=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeview)];
        [ScrollVc addGestureRecognizer:tapGst];
    }
    
    
}
-(void)removeview{
    [ScrollVc removeFromSuperview];
}
#pragma mark 宝贝详情页内图片展示
-(void)requestdetailimage{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
     NSMutableArray *arr=[dic objectForKey:@"detailimage"];
    for(int i=0;i<[arr count];i++){
        NSDictionary *dicc=[arr objectAtIndex:i];
        NSString *str=[dicc objectForKey:@"image_iamgeaddress"];
        NSString *path=[NSString stringWithFormat:@"%@%@",kscrollview,str];
        NSURL *url=[NSURL URLWithString:path];
        //NSData *data=[NSData dataWithContentsOfURL:url];
        //UIImage *imggg=[UIImage imageWithData:data];
        
      
        self.detailimage.showsHorizontalScrollIndicator=NO;
       self.detailimage.pagingEnabled=YES;
      
        self.detailimage.showsVerticalScrollIndicator=NO;//去掉线
        int with=self.detailimage.frame.size.width;
        int height=self.detailimage.frame.size.height;
        self.detailimage.contentSize=CGSizeMake(with, arr.count*height);
        UIImageView *imgview=[[UIImageView alloc]init];
        //imgview.image=imggg;
        [imgview sd_setImageWithURL:url];
        
           UIColor *customColor=[UIColor colorWithRed:223.0/225 green:223.0/225  blue:223.0/225  alpha:1.0];
        imgview.backgroundColor =customColor;
        imgview.backgroundColor=[UIColor blackColor];
        imgview.frame=CGRectMake(0, i*height, with, height-20);
        [imgview setContentMode:UIViewContentModeScaleAspectFit];
        [self.detailimage addSubview:imgview];
    }
    
    [SVProgressHUD dismiss];
}
#pragma mark 请求购物篮数量
-(void)requersCarnumber{
    APPDELEGATE.Carnumber=0;
    NSUInteger IDD=APPDELEGATE.user.userID;
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
            
            for (int m=0; m<storeCount; m++) {
                //获得店铺的名字
                //获得店铺的宝贝数量
                NSString *storeGoodCountKey=[NSString stringWithFormat:@"store_good_count%d",m];
                int storeGoodCount=[dicbaby[storeGoodCountKey] intValue];
                APPDELEGATE.Carnumber+=storeGoodCount;
          
            }
            if(APPDELEGATE.Carnumber==0){
                CarVc.Carview.hidden=YES;
            }
            CarVc.numberLable.text=[NSString stringWithFormat:@"%d",APPDELEGATE.Carnumber];
        }else{
            NSLog(@"请求网络数据失败....");
        }
        NSLog(@"%d",APPDELEGATE.Carnumber);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题....");
    }];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==2){
    VCHead=[[[NSBundle mainBundle]loadNibNamed:@"SYJbabyhead" owner:self options:nil]objectAtIndex:0];
    VCHead.frame=CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 60);
            VCHead.two.layer.cornerRadius=10;
            VCHead.one.layer.cornerRadius=10;
        VCHead.Enterstore.layer.cornerRadius=10;
    }
    return VCHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2){
    return 40;
   }
    else if (section==0){
        return 0;
    }
   else{
        return 15;
   }
    
}
-(void)GO{
    imagevieww=[[UIImageView alloc]init];
    imagevieww.frame=CGRectMake(0, self.tableView.contentOffset.y, 300, 200);
    [self.view addSubview:imagevieww];
    NSMutableArray *arr=[dic objectForKey:@"t_scrollimage"];
    NSDictionary *onename=[arr objectAtIndex:0];
    
    NSString *strimgname=[onename objectForKey:@"scrollimage_name"];
    NSString *str=[NSString stringWithFormat:@"%@%@",kscrollview,strimgname];
    NSURL *url=[NSURL URLWithString:str];
    
    [imagevieww  sd_setImageWithURL:url placeholderImage:nil];
}
-(void)selectSize{
    self.Stateone=YES;
    [self addcarr];
    
}
-(void)animationbaby{

    [self GO];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(remeberlable) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1 animations:^{
       imagevieww.frame=CGRectMake(40, 530+self.tableView.contentOffset.y, 0, 0);
    } completion:^(BOOL finished) {
        NSLog(@"s");
        CarVc.hidden=NO;
        APPDELEGATE.Carnumber++;
        
CarVc.numberLable.text=[NSString stringWithFormat:@"%d",APPDELEGATE.Carnumber];
    }];
    
}
-(void)remeberlable{
    //提醒标签
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"已添加至购物车！";
    //lbl.font=[UIFont systemFontOfSize:13];
    lbl.frame = CGRectMake(90, self.tableView.contentOffset.y+480, 150, 25);
    
    lbl.backgroundColor = [UIColor blackColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.alpha = 0.7;
    lbl.font=[UIFont systemFontOfSize:12];
    
    //lbs设置为圆角？？
    
    //label添加到父视图中显示
    [self.view addSubview:lbl];
    
    //简单动画：2秒内让lable的alpha从1变为0，实现渐变效果
    
    [UIView animateWithDuration:1 animations:^{
        //动画内容
        lbl.alpha = 0;
        
    } completion:^(BOOL finished) {
        //从父视图中移除lable
        [lbl removeFromSuperview];
    }];

}

-(void)creatView{
    [CanShuVc removeFromSuperview];
    
    CanShuVc=[[[NSBundle mainBundle]loadNibNamed:@"SYJCanShuView" owner:nil options:nil]objectAtIndex:0];
    CanShuVc.frame=CGRectMake(0, 522, [UIScreen mainScreen].bounds.size.width, 480);
    CanShuVc.backgroundColor=[UIColor whiteColor];
    [self.tableView addSubview:CanShuVc];
    
}
-(void)reloadd{
    [CanShuVc removeFromSuperview];
    [VCHead.one.titleLabel setTextColor:[UIColor redColor]];
   
    CanShuVc.hidden=YES;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%lf",self.ShowScrollView.contentOffset.x);
   if(self.tableView.contentOffset.y>-200&&self.tableView.contentOffset.y<300){
        headvc.alpha=self.tableView.contentOffset.y/120;
       
    }
   else if(self.tableView.contentOffset.y>390){
       if(CanShuVc==nil){
        VCHead.one.titleLabel.textColor=[UIColor redColor];
     
       }
[[self tableView]scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
   
    else {
        [[self tableView]scrollToRowAtIndexPath:scrollIndexPath
                               atScrollPosition:UITableViewScrollPositionNone animated:YES];
        VCHead.one.titleLabel.textColor=[UIColor blackColor];
        
    }
    
if ((int)self.ShowScrollView.contentOffset.x % (int)self.ShowScrollView    .frame.size.width == 0){
        Pag.currentPage=(int)scrollView.contentOffset.x / (int)scrollView.frame.size.width;
    }
}

-(void)chang{
    
    [self.detailimage removeFromSuperview];

    
}
#pragma mark 加入购物车后的数据库操作
-(void)addrequest{
    NSMutableArray *imgadd=[dic objectForKey:@"t_scrollimage"];
    NSDictionary *onename=[imgadd objectAtIndex:0];
    
    NSString *strimgname=[onename objectForKey:@"scrollimage_name"];
    NSNumber *ber=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
   
    int longth=(int)[self.babyPrice.text length]-1;
    NSString *price=[self.babyPrice.text substringWithRange:NSMakeRange(1, longth)];
    int storeid=[store intValue];
    NSNumber *nm=[NSNumber numberWithInteger:storeid];
    NSString *storename=[storedic objectForKey:@"store_name"];
    NSDictionary *info=@{@"car_cargoods_id":self.idd,
                         @"car_namegoods":self.BabyName.text,
                         @"car_imagegoods":strimgname,
                         @"car_pricegoods":price,
                         @"car_colourgood":Babycolour,
                         @"car_sizegood":Babysize,
                         @"car_store_id":nm,
                         @"car_user_id":ber,
                         @"car_numbercar":APPDELEGATE.shopnumber,
                         @"car_store_name":storename};

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager POST:kaddcar parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [loadclict stopAnimating];
        loadclict.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
#pragma mark 立刻购买
-(void)addcar{
    [self request];
    self.Stateone=NO;
   vvc=[[[NSBundle mainBundle]loadNibNamed:@"SIzeselect" owner:self options:nil]objectAtIndex:0];
    
    vvc.frame=CGRectMake(0, 600, [[UIScreen mainScreen]bounds].size.width, 400);
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
   
   
    
    UITapGestureRecognizer*   singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
    
    [view addGestureRecognizer:singleRecognizer];
    [self creatbt];
    [self creatBttwo];

   [self.navigationController.view addSubview:view];
    [self.tabBarController.view addSubview:vvc];
    
    [vvc sizeanimate];
}
#pragma mark  加入购物车
-(void)addcarr{
    
    vvc=[[[NSBundle mainBundle]loadNibNamed:@"SIzeselect" owner:self options:nil]objectAtIndex:0];
    
    vvc.frame=CGRectMake(0, 600, [[UIScreen mainScreen]bounds].size.width, 400);
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
    
    [view addGestureRecognizer:singleRecognizer];
    [self creatbt];
    [self creatBttwo];
    [self.navigationController.view addSubview:view];
    [self.tabBarController.view addSubview:vvc];
    
    [vvc sizeanimate];//往上的动画
    [self  request];
}
-(void)creatbt{
    d=0;
    d1=0;
    for (int i=0; i<sizearr.count; i++) {
        NSDictionary *sizedic=[sizearr objectAtIndex:i];
       NSString *size=[sizedic objectForKey:@"size_goodssize"];
        
        if(i<3){
            
                       bt=[[UIButton alloc]initWithFrame:CGRectMake(40+i*100, 42,80, 20)];
          bt.titleLabel.font=[UIFont systemFontOfSize:13];
            [bt setTitle:size forState:UIControlStateNormal];
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bt addTarget:self action:@selector(SenderEvent:) forControlEvents:UIControlEventTouchDown ];
            bt.tag=j;
        
            [bt setBackgroundImage:[UIImage imageNamed:@"NoSizeimage.jpg"] forState:UIControlStateNormal ];
            [vvc addSubview:bt];
        }
        else {
            if(i<6){
                bt=[[UIButton alloc]initWithFrame:CGRectMake(40+d*100, 75,80, 20)];
               
                [bt setTitle:size forState:UIControlStateNormal];
                bt.titleLabel.font=[UIFont systemFontOfSize:13];
                [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                d++;
                [bt addTarget:self action:@selector(SenderEvent:) forControlEvents:UIControlEventTouchDown ];
                bt.tag=j;
                 [bt setBackgroundImage:[UIImage imageNamed:@"NoSizeimage.jpg"] forState:UIControlStateNormal ];
                [vvc addSubview:bt];
            }
            else if (i<9){
                bt=[[UIButton alloc]initWithFrame:CGRectMake(40+d1*100, 108,80, 20)];
                bt.backgroundColor=[UIColor yellowColor];
                [bt setTitle:size forState:UIControlStateNormal];
                bt.titleLabel.font=[UIFont systemFontOfSize:13];
                [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                d1++;
                bt.tag=j;
                [bt addTarget:self action:@selector(SenderEvent:) forControlEvents:UIControlEventTouchDown ];
                 [bt setBackgroundImage:[UIImage imageNamed:@"NoSizeimage.jpg"] forState:UIControlStateNormal ];
                [vvc addSubview:bt];
            }
            
        }
        j ++;
    }
}
-(void)creatBttwo{
    d3=0;
    for(int i=0;i<colourarr.count;i++){
        NSDictionary *colourdic=[colourarr objectAtIndex:i];
        NSString *colour=[colourdic objectForKey:@"colour_goodscolour"];
        if(i<4){
            Bttwo=[[UIButton alloc]initWithFrame:CGRectMake(50+60*i, 128, 40, 20)];
           
            [Bttwo setTitle:colour forState:UIControlStateNormal];
            Bttwo.titleLabel.font=[UIFont systemFontOfSize:13];
            [Bttwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Bttwo addTarget:self action:@selector(SenderColourEvent:) forControlEvents:UIControlEventTouchDown ];
            [Bttwo setBackgroundImage:[UIImage imageNamed:@"NoColour.jpg"] forState:UIControlStateNormal];
            [vvc addSubview:Bttwo];
        }
        else if (i<8){
            Bttwo=[[UIButton alloc]initWithFrame:CGRectMake(50+60*d3, 158, 40, 20)];
           
            [Bttwo setTitle:colour forState:UIControlStateNormal];
            Bttwo.titleLabel.font=[UIFont systemFontOfSize:13];
            [Bttwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Bttwo addTarget:self action:@selector(SenderColourEvent:) forControlEvents:UIControlEventTouchDown ];
            [Bttwo setBackgroundImage:[UIImage imageNamed:@"NoColour.jpg"] forState:UIControlStateNormal];
            [vvc addSubview:Bttwo];
        }
    }
    
}
-(void)cancel{
      [view removeFromSuperview];
    vvc.frame=CGRectMake(0,350, [[UIScreen mainScreen]bounds].size.width, 200);
       [vvc removeFromSuperview];
    
}
#pragma mark 去店铺
-(void)gostore{
    SYJStoreViewController *storeViewController=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
    storeViewController.storeId=[store intValue];
    [self.navigationController pushViewController:storeViewController animated:YES];
}
-(void)request{
    NSString *str=[NSString stringWithFormat:@"%@%lu",kaddress,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        addressdic=(NSDictionary*)responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
#pragma mark 选择颜色尺码后的确定
-(void)SureSizeSelect{
    NSString *code=[addressdic objectForKey:@"code"];
    if([[APPDELEGATE.defaults objectForKey:@"isLogin"] isEqualToString:@"1"]&&[code isEqualToString:@"200"]){
       
    if(self.Stateone==YES){
    [self animationbaby];//飞入购物车的动画
        [self addrequest];
    }
    else{
        
        SYJShopdetailTableViewController *shopvc=[self.storyboard instantiateViewControllerWithIdentifier:@"shoptwo"];
        shopvc.goodsid=self.idd;
        shopvc.size=Babysize;
        shopvc.colour=Babycolour;
        int nm= [APPDELEGATE.shopnumber intValue];
        int price=[[Detaildic objectForKey:@"goods_price"] intValue];
    
        int tatil=nm+price;
        APPDELEGATE.orderprice=[NSString stringWithFormat:@"%d",tatil];
        
        [self.navigationController pushViewController:shopvc animated:YES];
    }
  }
    else if ([[APPDELEGATE.defaults objectForKey:@"isLogin"] isEqualToString:@"1"]&&[code isEqualToString:@"500"]){
        SYJAddAddressTableViewController *address=[[UIStoryboard storyboardWithName:@"Personal" bundle:nil]instantiateViewControllerWithIdentifier:@"addaddress"];
        [self.navigationController pushViewController:address animated:YES];
        APPDELEGATE.isaddress=YES;
    }
    else{
        APPDELEGATE.outrightplay=YES;
        SYJLoginViewController *login=[[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"tijiao"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)SenderEvent:(UIButton *)sender{
    APPDELEGATE.Stateone=YES;
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt setBackgroundImage:nil forState:UIControlStateNormal];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"Sizeimage.jpg"] forState:UIControlStateNormal ];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSLog(@"%@",sender.titleLabel.text);
    Babysize=sender.titleLabel.text;
    bt=sender;
    
}
#pragma mark给尺码颜色按钮添加的事件
-(void)SenderColourEvent:(UIButton *)sender{
  
    APPDELEGATE.ColourctState=YES;
    [Bttwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Bttwo setBackgroundImage:nil forState:UIControlStateNormal];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"Sizeimage.jpg"] forState:UIControlStateNormal ];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSLog(@"%@",sender.titleLabel.text);
    Babycolour=sender.titleLabel.text;
    Bttwo=sender;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark添加手势事件.点击背景，尺码选择视图消失
- (void)handleBackgroundTap:(UITapGestureRecognizer*)sender
{

    [UIView animateWithDuration:0.5 animations:^{
        vvc.frame = CGRectMake(0, 650, [[UIScreen mainScreen]bounds].size.width, 300);
           }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
        }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SYJgoodsCommentViewController *babyVc=(SYJgoodsCommentViewController *)segue.destinationViewController;
    babyVc.babyid=self.idd;
}
#pragma mark 商品评论请求
-(void)rquest{
    NSString *str=[NSString stringWithFormat:@"%@%@",kbabycomment,self.idd];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
       commentdic=(NSDictionary *)responseObject;
        commentarr=[commentdic objectForKey:@"data"];
        NSDictionary *babydic=[[commentarr objectAtIndex:0]objectForKey:@"user_info"];
        self.usercontent.text=[[commentarr objectAtIndex:0]objectForKey:@"babycomment_content"];
        self.username.text=[babydic objectForKey:@"user_name"];
        if([[[commentarr objectAtIndex:0]objectForKey:@"babycomment_star"] isEqualToString:@"3"]){
            self.xing.image=[UIImage imageNamed:@"3xing.png"];
        }
        img=[NSString stringWithFormat:@"%@",[babydic objectForKey:@"user_image"]];
        NSString *number=[NSString stringWithFormat:@"(%lu)",commentarr.count];
        self.Commentnuber.text=number;
        NSString *path=[NSString stringWithFormat:@"%@%@",kheader,img];
        NSURL *url=[NSURL URLWithString:path];
        
        [self.userheadimg sd_setImageWithURL:url];
        if(commentarr.count==0){
            [self creatNocommentView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
#pragma mark  创建中间的三个按钮
-(void)creatbabyhead{
   headvc=[[[NSBundle mainBundle]loadNibNamed:@"babyheadview" owner:self options:nil]objectAtIndex:0];
    headvc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66);
    self.navigationController.navigationBar.hidden=YES;
   [self.navigationController.view addSubview:headvc];
//    [self.navigationController.navigationBar addSubview:headvc];
}
- (IBAction)mapButton:(UIButton *)sender {
    SYJMapViewController *mapViewController=[[SYJMapViewController alloc] initWithNibName:@"SYJMapViewController" bundle:nil];
    mapViewController.storeId=[store intValue];
    [self.navigationController pushViewController:mapViewController animated:YES];
}
- (IBAction)SelectColourAndSize:(UIButton *)sender {
    [self addcar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    headvc.hidden=NO;
    btt.hidden=NO;
    fenxiangButton.hidden=NO;
    CarVc.hidden=NO;
  self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    headvc.hidden=YES;
    btt.hidden=YES;
    fenxiangButton.hidden=YES;
    CarVc.hidden=YES;
}
-(void)creatNocommentView{
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(65, 430, 320, 60)];
    lable.alpha=0.8;
    lable.text=@"本件商品暂无评论";
    lable.font=[UIFont systemFontOfSize:13];
    [self.tableView addSubview:lable ];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return goodimagearr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     SYJShowimageCollectionViewControllerCell *CollectCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectview" forIndexPath:indexPath];
    NSDictionary *imagenamedic=[goodimagearr objectAtIndex:indexPath.row];
    NSString *str=[imagenamedic objectForKey:@"image_iamgeaddress"];
    NSString *path=[NSString stringWithFormat:@"%@%@",kscrollview,str];
        NSURL *url=[NSURL URLWithString:path];
   
    
  [CollectCell.goodsimage setContentMode:UIViewContentModeScaleAspectFill];
    [CollectCell.goodsimage sd_setImageWithURL:url];
    return CollectCell;
}

-(void)Um{
    NSString *str=[NSString stringWithFormat:@"http://10.204.1.31:8887/SYiJieAppServicer/index.php/home/babydetail/detaill?id=%@",self.idd];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55d7ed8967e58e9cf10076a4"
                                      shareText:str
                                     shareImage:[UIImage imageNamed:@"back1.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToQzone,nil]
                                       delegate:self];
}
@end

