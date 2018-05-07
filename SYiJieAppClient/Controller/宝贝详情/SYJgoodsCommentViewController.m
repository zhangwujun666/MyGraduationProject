//
//  SYJCommentViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/19.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//


#import "SYJgoodsCommentViewController.h"
#import "SYJShouCommentTableViewCell.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SYJBaybyTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SYJgoodsCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SYJShouCommentTableViewCell *cell;
    NSMutableArray *arr;
    int i;
    NSMutableArray* commentimagearr;
    int hegiht;
    int tagg;
    int celltag;
    UIImageView *imgviewbig;
    int imgandgesttag;
    NSMutableArray *imgarr;
    UIImageView *imgviewobj;
    NSString *sizee;
    NSString *colourr;
    NSString *commenttime;
    
    __weak IBOutlet UIActivityIndicatorView *loadClict;
    
}
@end

@implementation SYJgoodsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableviewShow.delegate=self;
    self.tableviewShow.dataSource=self;
    arr=[NSMutableArray array];
    NSLog(@"%@",self.babyid);
    [self rquest];
    tagg=120;
    celltag=120;
    self.navigationController.navigationBar.hidden=YES;
    
    imgandgesttag=50;
    
    imgarr=[NSMutableArray array];
    [loadClict startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rquest{
    NSString *str=[NSString stringWithFormat:@"%@%@",kbabycomment,self.babyid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        NSDictionary *dic=(NSDictionary *)responseObject;
        arr=[dic objectForKey:@"data"];
        NSLog(@"%@",dic);
        [self.tableviewShow reloadData];
        [loadClict stopAnimating];
        loadClict.hidden=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    commentimagearr=[[NSMutableArray alloc]init];
    
    cell=[tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
    NSDictionary *infodic=[arr objectAtIndex:indexPath.row];
    cell.Commentcontent.text=[infodic objectForKey:@"babycomment_content"];
    cell.CommentTime.text=[infodic objectForKey:@"babycommen_time"];
    cell.commentxingji.titleLabel.text=[infodic objectForKey:@"babycomment_star"];
    sizee=[infodic objectForKey:@"babycomment_size"];
    colourr=[infodic objectForKey:@"babycomment_colour"];
    NSString *star=[NSString stringWithFormat:@"%@xing.png",[infodic objectForKey:@"babycomment_star"]];
    commenttime=[infodic objectForKey:@"babycommen_time"];
    
    commentimagearr=[infodic objectForKey:@"comment_imgs"];
    if(cell.footimageview==nil){
        cell.footimageview=[[UIView alloc]init];
        
        
    }
    
    if(commentimagearr.count>0){
        cell.footimageview.frame=CGRectMake(9, 60, 320, 50);
    }  else{
        cell.footimageview.frame=CGRectMake(0, 0, 0, 0);
    }
    [cell addSubview:cell.footimageview];
    
    [cell.footimageview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (int k=0; k<commentimagearr.count; k++) {
        UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTapEventt:)];
        
        UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0+k*55, 10, 50, 60)];
        
        NSDictionary *Sqlimg=[commentimagearr objectAtIndex:k];
        NSString *str=[NSString stringWithFormat:@"%@%@",kdetailcommentimage,[Sqlimg objectForKey:@"goodscommentimage_name"]];
        NSURL *url=[NSURL URLWithString:str];
      [imgview sd_setImageWithURL:url placeholderImage:nil];
        [imgview addGestureRecognizer:Gesture];
        imgview.userInteractionEnabled=YES;
        
        //将图片加到cell上
        [cell.footimageview addSubview:imgview];
        
        imgview.tag=imgandgesttag;
        imgandgesttag++;
        [imgarr addObject:imgview];
    }
    
    
    if(cell.footView == nil){
        cell.footView = [[UIView alloc]init];
    }
    [cell.footView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self creatlable];
    [cell addSubview:cell.footView];
    
    [cell.commentxingji setImage:[UIImage imageNamed:star] forState:UIControlStateNormal];
    
    NSDictionary * userarr=[infodic objectForKey:@"user_info"];
    cell.userName.text=[userarr objectForKey:@"user_name"];
    NSString *imgpath=[NSString stringWithFormat:@"%@%@",kheader,[userarr objectForKey:@"user_image"]];
    NSURL *url=[NSURL URLWithString:imgpath];
    cell.userimager.contentMode=UIViewContentModeScaleAspectFill;
    cell.userimager.layer.cornerRadius=cell.userimager.frame.size.width/2;
    cell.userimager.layer.masksToBounds=YES;
    cell.userimager.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    cell.tag=tagg;
    celltag++;
  [cell.userimager sd_setImageWithURL:url placeholderImage:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([commentimagearr count]>0){
        return 170;
    }
    else {
        return 105;
    }
}
- (IBAction)Return:(UIButton *)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)creatlable{
    hegiht=0;
    
    if(commentimagearr.count>0){
        [cell.footView setFrame:CGRectMake(0, 145, 320, 20)];
        
        hegiht=100;
        UILabel *size;
        UILabel *colour;
        UILabel *time;
        if(size==nil){
            size=[[UILabel alloc]initWithFrame:CGRectMake(155, 0, 55, 20)];
            size.text=[NSString stringWithFormat:@"尺码：%@",sizee];
            size.font=[UIFont systemFontOfSize:12];
            [cell.footView addSubview:size];
            size.tag=tagg;
        }
        if(colour==nil){
            colour=[[UILabel alloc]initWithFrame:CGRectMake(220, 0, 75, 20)];
            colour.text=[NSString stringWithFormat:@"颜色：%@",colourr];
            colour.font=[UIFont systemFontOfSize:12];
            
            [cell.footView addSubview:colour];
        }
        if(time==nil){
            time=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
            int turntime=[commenttime intValue];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//初始化时间格式
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:turntime];//时间戳转时间
            NSString* dateString = [formatter stringFromDate:confromTimesp];//给时间设置格式
            
            time.text=dateString;
            time.font=[UIFont systemFontOfSize:12];
            [cell.footView addSubview:time];
        }
        
    }
    
    else {
        [cell.footView setFrame:CGRectMake(0, 80, 320, 20)];
        
        
        UILabel *size;
        UILabel *colour;
        UILabel *time;
        if(size==nil){
            size=[[UILabel alloc]initWithFrame:CGRectMake(155, 0, 55, 20)];
            
            size.text=[NSString stringWithFormat:@"尺码：%@",sizee];
            size.font=[UIFont systemFontOfSize:12];
            [cell.footView addSubview:size];
            size.tag=tagg;
        }
        if(colour==nil){
            colour=[[UILabel alloc]initWithFrame:CGRectMake(220, 0, 75, 20)];
            
            colour.text=[NSString stringWithFormat:@"颜色：%@",colourr];
            colour.font=[UIFont systemFontOfSize:12];
            
            [cell.footView addSubview:colour];
        }
        if(time==nil){
            time=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
            int turntime=[commenttime intValue];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//初始化时间格式
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:turntime];//时间戳转时间
            NSString* dateString = [formatter stringFromDate:confromTimesp];//给时间设置格式
            
            time.text=dateString;
            time.font=[UIFont systemFontOfSize:12];
            [cell.footView addSubview:time];
        }
    }
    
    tagg++;
    
}

-(void)gestureTapEventt:(UITapGestureRecognizer *)gesture{
    
    //    for ( imgviewobj in imgarr) {
    //        if(imgviewobj.tag==gesture.view.tag){
    //
    //            imgviewbig=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    //
    //
    //            [imgviewbig setContentMode:UIViewContentModeScaleAspectFit];
    //            imgviewbig.backgroundColor=[UIColor blackColor];
    //
    //            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changsmall)];
    //             imgviewbig.userInteractionEnabled=YES;
    //            [imgviewbig addGestureRecognizer:tap];
    //
    //            [UIView animateWithDuration:0.8 animations:^{
    //                 imgviewbig.image=imgviewobj.image;
    //
    //                imgviewbig.frame=self.view.frame;
    //                imgviewbig.alpha=1;
    //
    //            }];
    //
    //
    //
    //        [self.navigationController.view addSubview:imgviewbig];
    //        }
    //    }
    //获得cell的view
    UIView *shareImageView=gesture.view.superview;
    
    //创建一个数组将UIImageView添加到数组中
    NSMutableArray *picArray=[NSMutableArray array];
    
    //创建一个变量存储当前点的是第几个
    int signal=0;
    int j=0;//用来记录是第几个UIImageView
    
    //将UIImageView都添加到数组中,并记录当前点击的是第几张图片
    for (UIView *view in shareImageView.subviews) {
        NSLog(@"子view----%@",view);
        
        if (view.class==[UIImageView class]) {
            [picArray addObject:view];
            if ((gesture.view.frame.origin.x==view.frame.origin.x)&&(gesture.view.frame.origin.y==view.frame.origin.y)) {
                signal=j;
            }
            j++;
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
    
    for (int m=0; m<picArray.count; m++) {
        //创建UIImageView
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x+m*width,y,width,height)];
        //取出数组中的UIImageView
        UIImageView *customImageView=[picArray objectAtIndex:m];
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
        //将pageControl添加到UIView中
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

-(void)changsmall{
    [imgviewbig removeFromSuperview ];
}

@end
