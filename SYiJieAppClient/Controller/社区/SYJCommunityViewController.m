//
//  SYJCommunityViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/17.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCommunityViewController.h"
#import "SYJCommentViewController.h"
#import "AppDelegate.h"
#import "SYJUser.h"
#import "SYJShareTableViewCell.h"
#import "SYJSelectGoodsViewController.h"
#import "SYJBaybyTableViewController.h"
//#import "UMSocial.h"
#import "SYJAddShareViewController.h"
#import "SYJShare.h"
#import "SYJShareRepeat.h"
#import "SYJLoginViewController.h"

static const CGFloat MJDuration = 2.0;
//,UMSocialDataDelegate,UMSocialUIDelegate，SYJCommentDelegate
@interface SYJCommunityViewController ()<SYJCommentDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray * shareArray;
    NSMutableArray * shareCellHightArray;
    NSInteger goodsNum;
    NSMutableArray *allShare;
}

@end

@implementation SYJCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化存放所有分享的一个数组
    allShare=[NSMutableArray array];
    [self setUpInit];
    // Do any additional setup after loading the view.
}

- (void)reloadPersonInfo{
    //设置个人信息
    self.userNameLable.text = APPDELEGATE.user.username;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url=[NSString stringWithFormat:@"%@%@",kheader,APPDELEGATE.user.headImage];
        NSURL *path=[NSURL URLWithString:url];
        [self.userImage sd_setImageWithURL:path];
        //        NSData *data=[NSData dataWithContentsOfURL:path];
        //        UIImage *img=[UIImage imageWithData:data];
        //        [self.userImage setImage:img];
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
        self.userImage.layer.masksToBounds=YES;
        self.userImage.layer.borderColor=[[UIColor whiteColor]CGColor];
        
    });
}

- (void)dealloc{
    NSLog(@"SYJCommunityViewController被销毁了...");
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadPersonImage" object:nil];
}

- (void)setUpInit{
    //关闭导航栏
    self.navigationController.navigationBar.hidden =YES;
    //设置个人信息
    self.userNameLable.text = APPDELEGATE.user.username;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url=[NSString stringWithFormat:@"%@%@",kheader,APPDELEGATE.user.headImage];
        NSURL *path=[NSURL URLWithString:url];
        [self.userImage sd_setImageWithURL:path];
//        NSData *data=[NSData dataWithContentsOfURL:path];
//        UIImage *img=[UIImage imageWithData:data];
//        [self.userImage setImage:img];
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
        self.userImage.layer.masksToBounds=YES;
        self.userImage.layer.borderColor=[[UIColor whiteColor]CGColor];
    });
    
    //给self.userImage添加一个观察者
    NSNotificationCenter *noteForImage = [NSNotificationCenter defaultCenter];
    [noteForImage addObserver:self selector:@selector(reloadPersonInfo) name:@"reloadPersonImage" object:nil];
    
    
    //[self.shareTableView setTableHeaderView:self.headView];
    [self.headView removeFromSuperview];
    //获取数据资源
    [self getDataSource];
    //设置tableview的代理
    self.shareTableView.delegate = self;
    self.shareTableView.dataSource = self;
    
    self.shareTableView.showsVerticalScrollIndicator = NO;
    self.shareTableView.separatorStyle = NO;
    //设置一次加载的评论条数
    goodsNum = 10;
    //上拉刷新、下拉加载
    [self loadNew];
    [self loadMore];
}
#pragma mark - 宝贝连接跳转代理
-(void)recommendButtonClicked:(NSString *)goodsId{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = goodsId;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
}

#pragma mark - 添加分享
- (IBAction)addCommentClicked:(UIButton *)sender {
    /**
     SYJLoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"tijiao"];
     [self.navigationController pushViewController:login animated:YES];
     */
    if ([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"是否选择宝贝连接"
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        SYJLoginViewController *login = [board instantiateViewControllerWithIdentifier:@"tijiao"];
        //SYJLoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"tijiao"];
        //[self.navigationController pushViewController:login animated:YES];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - 点击添加分享的按钮触发选择宝贝连接
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIStoryboard *storyBoard = self.storyboard;
        SYJSelectGoodsViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:@"selectsharegoods"];
        [vc getFinshGoodsData];
        //self.navigationController.navigationBar.hidden =NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIStoryboard *storyBoard = self.storyboard;
        SYJAddShareViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"addshareview"];
        vcc.source = @"compose";
        vcc.goodsId = @"3";
        vcc.goodsName = @"nil";
        self.navigationController.navigationBar.hidden =NO;
        [self.navigationController pushViewController:vcc animated:YES];
    }
}
#pragma mark - 获取数据资源和配置
- (void)getDataSource{
    NSString *urlPath = [NSString stringWithFormat:@"%@Share/getComments?userId=%lu",SYJHTTP,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        shareArray = dicdescription[@"data"];
        NSLog(@"dic=%@",shareArray);
        
        //将字典转换成模型
//        for (NSDictionary *dic in shareArray) {
//            SYJShare *share=[[SYJShare alloc] initWithDic:dic];
//            [allShare addObject:share];
//        }
        
        
        [self getCellHight];
        [self.shareTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    
    
}
/**
 *  计算cell的高度
 */
-(void)getCellHight{
    shareCellHightArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[shareArray count]; i++) {
        NSDictionary * dataDic= [shareArray objectAtIndex:i];
        //NSString * text = [NSString stringWithFormat:@"   %@" ,self.dataDic[@"share_content"] ];
        CGSize textSize = [dataDic[@"share_content"] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        //将获取的长宽高设置到控件中去
        CGFloat h1 = textSize.height+5*((int)textSize.height/14);
        
        CGFloat h4=0.0;
        if ([dataDic[@"share_repeat_content"] isEqualToString:@""]) {
            h4=0.0;
        }else{
            CGSize repeatTextSize = [dataDic[@"share_repeat_content"] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            h4 = repeatTextSize.height+5*((int)textSize.height/14);
        }
        
        CGFloat h2 = 0;
        CGFloat h3 = 20.0;
        /*if ([dataDic[@"share_imagenumber"] intValue] != 0) {
            h2 = 150*(1 + [dataDic[@"share_imagenumber"] intValue]/4);
        }*/
        if([dataDic[@"share_imagenumber"] intValue] == 0){
            h2 = 0;
        }
        if([dataDic[@"share_imagenumber"] intValue] > 0 && [dataDic[@"share_imagenumber"] intValue] < 4){
            h2 = 150.0;
        }
        if([dataDic[@"share_imagenumber"] intValue] >= 4 && [dataDic[@"share_imagenumber"] intValue] < 7){
            h2 = 300.0;
        }
        if([dataDic[@"share_imagenumber"] intValue] >= 7 && [dataDic[@"share_imagenumber"] intValue] < 10){
            h2 = 450.0;
        }
        NSString *goodsname = dataDic[@"share_goodsname"];
        if ([goodsname isEqualToString:@"nil"]) {
            h3 = 0.0;
        }
        [shareCellHightArray addObject:[NSString stringWithFormat:@"%f",h1 + h2 + h3 + h4 + 95.0]];//+95.0是头尾高度、h3是连接地址高度。
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    //[self.shareTableView reloadData];
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
    if (goodsNum > [shareArray count]) {
        return [shareArray count]*2;
    }
    return goodsNum*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2==0){
        SYJShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sharecelltableviewcell"];
        if (cell != nil) {
            [cell.shareImageView removeFromSuperview];
            
        }
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.dataDic= [shareArray objectAtIndex:indexPath.row/2];
        cell.delegate = self;
        [cell getDataSource];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.shareImageView.backgroundColor = [UIColor blackColor];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linebetween"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0) {
        return [[shareCellHightArray objectAtIndex:indexPath.row/2] floatValue];
    }
    return 2;
}


//每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSLog(@"%lu",indexPath.row);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    vcc.idd = @"2";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];*/
    //选中的时候需要跳转
    UIStoryboard *storyBoard = self.storyboard;
    SYJCommentViewController *vcc=[storyBoard instantiateViewControllerWithIdentifier:@"comment"];
    SYJShareTableViewCell *cell=(SYJShareTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    vcc.shareId=[NSString stringWithFormat:@"%ld",cell.tag-commentTag];
    vcc.sharecell=cell;
    [self.navigationController pushViewController:vcc animated:YES];
}

/**
 if ([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"]) {
 
 }else{
 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
 SYJLoginViewController *login = [board instantiateViewControllerWithIdentifier:@"tijiao"];
 [self.navigationController pushViewController:login animated:YES];
 }
 */
#pragma mark-SYJShareTableViewCell的代理事件
//点击转发按钮的代理事件
-(void)showOtherPlace:(int)cellTag{
    
    if ([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"]) {
        SYJShareRepeat *repeatVC=[self.storyboard instantiateViewControllerWithIdentifier:@"shareRepeat"];
        repeatVC.shareId=cellTag;
        NSArray *visableCells = self.shareTableView.visibleCells;
        for (SYJShareTableViewCell *cell in visableCells) {
            if (cell.tag-commentTag==cellTag) {
                repeatVC.shareCell=cell;
            }
        }
        
        NSLog(@"this is from %@",repeatVC.shareCell.shareName.text);
        
        if ([[APPDELEGATE.defaults valueForKey:@"username"] isEqualToString:repeatVC.shareCell.shareName.text]) {
            [SVProgressHUD showErrorWithStatus:@"自己不能转发自己的帖子!"];
        }else{
            [self.navigationController pushViewController:repeatVC animated:YES];
        }
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        SYJLoginViewController *login = [board instantiateViewControllerWithIdentifier:@"tijiao"];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}


//点击评论按钮跳转
-(void)commentClicked:(int)cellTag{
    if ([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"]) {
        //跳转返回
        UIStoryboard *storyBoard = self.storyboard;
        SYJCommentViewController *vcc = (SYJCommentViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"comment"];
        vcc.shareId = [NSString stringWithFormat:@"%d",cellTag];
        NSArray *visableCells = self.shareTableView.visibleCells;
        for (SYJShareTableViewCell *cell in visableCells) {
            if (cell.tag-commentTag==cellTag) {
                vcc.sharecell=cell;
            }
        }
        [self.navigationController pushViewController:vcc animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        SYJLoginViewController *login = [board instantiateViewControllerWithIdentifier:@"tijiao"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

//点赞的代理事件
- (void)likeClicked:(int)cellTag andLikeLabel:(UILabel *)likeLabel andImageView:(UIImageView *)imageView{
    
    if ([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        //获取当前的userId和评论的Id
        NSString *url=[NSString stringWithFormat:@"%@Share/addLike",SYJHTTP];
        NSDictionary *parameter=@{
                                  @"shareId":[NSNumber numberWithInt:cellTag],
                                  @"userId":@(APPDELEGATE.user.userID)
                                  };
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic=(NSDictionary *)responseObject;
            NSString *code=dic[@"code"];
            if ([code isEqualToString:@"200"]) {
                NSString *data=dic[@"data"];
                likeLabel.text=[NSString stringWithFormat:@"点赞 %d",[dic[@"likecount"] intValue]];
                //设置UIImageView的背景图片
                
                if ([data isEqualToString:@"点赞成功"]) {
                    UIImage *img=[UIImage imageNamed:@"market_icon_liked.png"];
                    [imageView setImage:img];
                    //imageView.tintColor=[UIColor orangeColor];
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        CGRect oldRect=imageView.frame;
                        imageView.frame=CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width+10, oldRect.size.height+10);
                        
                    }];
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        CGRect oldRect=imageView.frame;
                        imageView.frame=CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width-10, oldRect.size.height-10);
                    }];
                }
                
                if ([data isEqualToString:@"取消点赞成功"]) {
                    UIImage *img=[UIImage imageNamed:@"market_icon_dislike.png"];
                    [imageView setImage:img];
                    //imageView.tintColor=[UIColor orangeColor];
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        CGRect oldRect=imageView.frame;
                        imageView.frame=CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width+10, oldRect.size.height+10);
                        
                    }];
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        CGRect oldRect=imageView.frame;
                        imageView.frame=CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width-10, oldRect.size.height-10);
                    }];
                }
                
                // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    // 刷新表格
//                    [self.shareTableView reloadData];
//                    [self getDataSource];
//                    // 拿到当前的下拉刷新控件，结束刷新状态
//                    [self.shareTableView.header endRefreshing];
//                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getDataSource];
                    [self.shareTableView reloadData];
                });
                
            }else{
                NSLog(@"获取网络数据失败,请重试。");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"网络连接有问题,请检查网络连接。");
        }];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        SYJLoginViewController *login = [board instantiateViewControllerWithIdentifier:@"tijiao"];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}


//点击UIImageView的代理事件
-(void)imageClicked:(UITapGestureRecognizer *)gesture{
    //获得cell的view
    UIView *shareImageView=gesture.view.superview;
    
    //创建一个数组将UIImageView添加到数组中
    NSMutableArray *picArray=[NSMutableArray array];
    
    //创建一个变量存储当前点的是第几个
    int signal=0;
    int i=0;//用来记录是第几个UIImageView
    
    //将UIImageView都添加到数组中,并记录当前点击的是第几张图片
    for (UIView *view in shareImageView.subviews) {
        NSLog(@"子view----%@",view);
        
        if (view.class==[UIImageView class]) {
            [picArray addObject:view];
            if ((gesture.view.frame.origin.x==view.frame.origin.x)&&(gesture.view.frame.origin.y==view.frame.origin.y)) {
                signal=i;
            }
            i++;
        }
    }
    
    //先创建一个背景为黑色的UIView
    self.blackView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.blackView.backgroundColor=[UIColor colorWithRed:10.0/255 green:10.0/255 blue:10.0/255 alpha:1.0];
    [self.tabBarController.view addSubview:self.blackView];
    
    //创建一个ScrollView
    CGRect rect1=[[UIScreen mainScreen] bounds];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height-30)];
    
    //获得frame的长宽高
    int x=self.scrollView.frame.origin.x;
    int y=self.scrollView.frame.origin.y;
    int width=self.scrollView.frame.size.width;
    int height=self.scrollView.frame.size.height;
    
    //设置UIScrollView的contentsize
    self.scrollView.contentSize=CGSizeMake(width*picArray.count, height);
    //为UIScrollView设置分页翻滚
    self.scrollView.pagingEnabled=YES;
    //隐藏UIScrollView的横向滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    //设置代理对象
    self.scrollView.delegate=self;
    
    for (int i=0; i<picArray.count; i++) {
        //创建UIImageView
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x+i*width,y,width,height)];
        //取出数组中的UIImageView
        UIImageView *customImageView=[picArray objectAtIndex:i];
        //给新创建的UIImageView赋值
        imageView.image=customImageView.image;
        
        //设置UIImageView的图片模式
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        imageView.backgroundColor=[UIColor colorWithRed:10.0/255 green:10.0/255 blue:10.0/255 alpha:1.0];
        
        //设置UIImageView的交互功能是否开启
        imageView.userInteractionEnabled=YES;
        //给UIImageView添加手势
        UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearView:)];
        [imageView addGestureRecognizer:recognizer];
        
        //将新创建的UIImageView添加到ScrollView中
        [self.scrollView addSubview:imageView];
    }
    
    if (picArray.count>1) {
        self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,height+10,width,10)];
        self.pageControl.numberOfPages=picArray.count;
        self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
        
        //设置分页控件的偏移量
        self.pageControl.currentPage=signal;
        
        [self.blackView addSubview:self.pageControl];
    }
    
    //设置scrollView偏移量
    self.scrollView.contentOffset=CGPointMake(width*signal, y);
    //将scrollView添加到页面view上
    [self.blackView addSubview:self.scrollView];
    
    self.blackView.alpha=0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha=1.0;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView!=nil) {
        if ((int)self.scrollView.contentOffset.x%(int)self.scrollView.frame.size.width==0) {
            self.pageControl.currentPage=(int)self.scrollView.contentOffset.x/(int)self.scrollView.frame.size.width;
        }
    }
}

- (void)clearView:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha=0;
    }];
    [self.blackView removeFromSuperview];
}

//转发的代理事件
//-(void)showOtherPlace{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:nil
//                                      shareText:@"这里的衣服很不错,大家都可以过来购买哦--尚衣街"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
//                                       delegate:self];
//}

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
    self.shareTableView.header = header;
}
#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.shareTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
        [self.shareTableView reloadData];
        [self getDataSource];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.shareTableView.header endRefreshing];
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
        [self.shareTableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.shareTableView.footer endRefreshing];
    });
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





