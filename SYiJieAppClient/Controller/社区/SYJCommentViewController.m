//
//  SYJCommentViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/22.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCommentViewController.h"
#import "SYJcommentTableViewCell.h"
#import "SYJAddShareViewController.h"
#import "SYJShareTableViewCell.h"
#import "SYJShareDetailCell.h"
#import "SYJBaybyTableViewController.h"

#define kStatusTableViewCellTextFontSize 12

@interface SYJCommentViewController ()<UITableViewDataSource,UITableViewDelegate,SYJcommentTableViewCellDelegate>{
    NSMutableArray * commentListArray;
    NSMutableArray * commentCellHightArray;
}

@end

@implementation SYJCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    
    //添加一个新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSource) name:@"SYJCommentViewControllerNC" object:nil];
    
}

//-(void)viewWillAppear{
//    self.commentTableView.tableHeaderView=self.tableHeaderView;
//}

//添加评论
- (IBAction)addCommentClicked:(UIButton *)sender {
    UIStoryboard *storyBoard = self.storyboard;
    SYJAddShareViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"addshareview"];
    vcc.source = @"comment";
    vcc.shareId = self.shareId;
    self.navigationController.navigationBar.hidden =NO;
    [self.navigationController pushViewController:vcc animated:YES];
}

//返回到上一页
- (IBAction)breakClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 添加二级评论跳转代理
-(void)addCommentTowSharecommentId:(NSString *)SharecommentId andSharecommentName:(NSString *)SharecommentName{
    UIStoryboard *storyBoard =self.storyboard;
     
    SYJAddShareViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"addshareview"];
    vcc.source = @"commenttow";
    vcc.commentId = SharecommentId;
    vcc.shareId = self.shareId;
    vcc.commentTowToName = SharecommentName;
    self.navigationController.navigationBar.hidden =NO;
    [self.navigationController pushViewController:vcc animated:YES];
}





- (void)setUpInit{
    //关闭导航栏
    self.navigationController.navigationBar.hidden =YES;
    //关闭底部导航栏
    //self.tabBarController.tabBar.hidden=YES;

    //获取数据资源
    [self getDataSource];
    //设置tableview的代理
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.showsVerticalScrollIndicator = NO;
    self.commentTableView.separatorStyle = NO;
    
    [self.commentTableView reloadData];
}
#pragma mark - 获取数据资源和配置
- (void)getDataSource{
    NSString *urlPath = [NSString stringWithFormat:@"%@Share/getCommentList?shareid=%d",SYJHTTP,[self.shareId intValue]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        commentListArray = dicdescription[@"data"];
        NSLog(@"dic=%@",commentListArray);
        
        [self getCellHight];
        [self.commentTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
}

-(void)getCellHight{
    commentCellHightArray = [[NSMutableArray alloc]init];
    
    if (commentListArray.count==0) {
        [commentCellHightArray addObject:[NSString stringWithFormat:@"%d",40]];
    }else{
        for (int i = 0; i<[commentListArray count]; i++) {
            NSDictionary * commentlist= [commentListArray objectAtIndex:i];
            NSString * text = [NSString stringWithFormat:@"%@：%@" ,commentlist[@"sharecomment_name"],commentlist[@"sharecomment_content"] ];
            
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            //将获取的长宽高设置到控件中去
            CGFloat h1 = textSize.height+5*((int)textSize.height/14)+10;
            CGFloat h2 = 0;
            NSMutableArray * commentTow = commentlist[@"sharecomment_towcomment"];
            for (int j = 0; j < [commentTow count]; j++) {
                NSDictionary * commentTowDic = [commentTow objectAtIndex:j];
                NSString * commentTowtext = [NSString stringWithFormat:@"%@回复%@：%@",commentTowDic[@"sharecommenttow_name"],commentTowDic[@"sharecommenttow_toname"],commentTowDic[@"sharecommenttow_content"] ];
                
                CGSize textTowSize = [commentTowtext boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                h2  = h2 + textTowSize.height + 5*((int)textTowSize.height/14);
            }
            [commentCellHightArray addObject:[NSString stringWithFormat:@"%f",h1 + h2]];
        }
    }
}

#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.commentTableView reloadData];
}

#pragma mark - 退出时执行
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
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
    return 2;
}
#pragma mark - 设置TableView每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        if (commentListArray.count==0) {
            return 1;
        }else{
            return [commentListArray count];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"评论列表";
    }else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //UITableViewCell *cell=[[UITableViewCell alloc] init];
        //cell.textLabel.text=@"11111";
        //SYJShareDetailCell *cell=(SYJShareDetailCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareDetailCell"];
        
        SYJShareDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"shareDetailCell"];
        cell.height=self.sharecell.height;//设置cell的高度
        [cell.headerImageView setImage:self.sharecell.shareImage.image];//设置cell的用户头像
        cell.usernameLabel.text=self.sharecell.shareName.text;//设置cell的用户昵称
        cell.timeLabel.text=self.sharecell.shareTime.text;//设置cell的发布时间
        
        if ([self.sharecell.repeatLabel.text isEqualToString:@""]||self.sharecell.repeatLabel.text==nil){
            //设置分享的内容
            if (cell.shareContent==nil) {
                cell.shareContent=[[UILabel alloc] init];
            }
            CGFloat textX=10;
            CGFloat textY=cell.headerImageView.frame.size.height+20;
            CGFloat textWidth=cell.frame.size.width-2*10;
            //根据内容长度判断label的高度
            NSString *text=self.sharecell.shareContent.text;
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
            cell.shareContent.text=self.sharecell.shareContent.text;
            //将获取的长宽设置到控件中去
            [cell.shareContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+5*(int)textSize.height/14)];
            cell.shareContent.font=[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
            //设置显示任意行
            cell.shareContent.numberOfLines=0;
            //调整文本框中的行间距
            NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc] initWithString:self.sharecell.shareContent.text];
            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5.0];//调整行间距
            
            [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.shareContent.text length])];
            cell.shareContent.attributedText=attributeString;
            //将label添加到cell当中
            [cell.contentView addSubview:cell.shareContent];
        }else{
            //设置转发的心情
            if (cell.repeatLabel == nil) {
                cell.repeatLabel = [[UILabel alloc] init];
            }
            CGFloat repeatLabelX = 10;
            CGFloat repeatLabelY = cell.headerImageView.frame.size.height+20;
            CGFloat repeatLabelWidth = cell.frame.size.width-2*10;
            //根据内容长度判断Label高度
            NSString *repeatLabelText=self.sharecell.repeatLabel.text;
            CGSize repeatTextSize = [repeatLabelText boundingRectWithSize:CGSizeMake(repeatLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
            //设置显示的内容
            cell.repeatLabel.text = self.sharecell.repeatLabel.text;
            //将获得的长度设置到控件中去
            [cell.repeatLabel setFrame:CGRectMake(repeatLabelX, repeatLabelY, repeatLabelWidth, repeatTextSize.height+5*((int)repeatTextSize.height/14))];
            //设置文本框的字体
            cell.repeatLabel.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
            //设置显示任意行
            cell.repeatLabel.numberOfLines=0;
            //调整文本框中的行间距
            NSMutableAttributedString *repeatAttributeString = [[NSMutableAttributedString alloc] initWithString:self.sharecell.repeatLabel.text];
            NSMutableParagraphStyle *repeatParagraphStyle=[[NSMutableParagraphStyle alloc] init];
            [repeatParagraphStyle setLineSpacing:5.0];
            [repeatAttributeString addAttribute:NSPaperMarginDocumentAttribute value:repeatParagraphStyle range:NSMakeRange(0, [cell.repeatLabel.text length])];
            cell.repeatLabel.attributedText=repeatAttributeString;
            //将Label添加到视图中
            [cell.contentView addSubview:cell.repeatLabel];
            
            //设置分享内容
            if (cell.shareContent == nil) {
                cell.shareContent=[[UILabel alloc] init];
            }
            CGFloat textX = 10;
            CGFloat textY = cell.repeatLabel.frame.origin.y + cell.repeatLabel.frame.size.height;
            CGFloat textWidth = cell.frame.size.width - 2*10;
            //根据内容长度判断label高度
            NSString *text = self.sharecell.shareContent.text;
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
            //设置显示的内容
            cell.shareContent.text=text;
            //将获取到的长宽高设置到控件中去
            [cell.shareContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+5*((int)textSize.height/14))];
            //设置文本框的字体
            cell.shareContent.font=[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
            //设置显示任意行
            cell.shareContent.numberOfLines=0;
            //调整文本框中的行间距
            NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:text];
            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5.0];//调整行间距
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.shareContent.text length])];
            cell.shareContent.attributedText=attributedString;
            [cell.contentView addSubview:cell.shareContent];
        }

        
        //创建链接按钮
        UIButton *recommendButton=[[UIButton alloc] init];
        CGFloat recommendButtonX = 6;
        CGFloat recommendButtonY = cell.shareContent.frame.size.height+cell.shareContent.frame.origin.y+0;
        CGFloat recommendButtonHeight = 20.0;
        CGFloat recommendButtonWidth = [UIScreen mainScreen].bounds.size.width-20;
        [recommendButton setFrame:CGRectMake(recommendButtonX, recommendButtonY, recommendButtonWidth, recommendButtonHeight)];
        //添加点击事件
        [recommendButton addTarget:self action:@selector(recommendButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //边框宽度
        [recommendButton.layer setBorderWidth:0.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30.0/255, 144.0/255, 255.0/255, 0.8 });
        //边框颜色
        [recommendButton.layer setBorderColor:colorref];
        //边框弧度
        recommendButton.layer.cornerRadius = 4.0f;
        //设置字体大小
        recommendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        //设置字体颜色
        [recommendButton setTitleColor:[[UIColor alloc] initWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];
        //宝贝链接
        [recommendButton setTitle:self.sharecell.recommendButton.titleLabel.text forState:UIControlStateNormal];
        //设置tag值为商品id
        [recommendButton setTag:self.sharecell.recommendButton.tag];
        self.goodId=(int)self.sharecell.recommendButton.tag;
        //设置宝贝链接按钮的文字对齐方式是左对齐
        recommendButton.titleLabel.textAlignment=NSTextAlignmentLeft;
        
        if ([self.sharecell.recommendButton.titleLabel.text isEqualToString:@"宝贝链接：nil"]) {
            [recommendButton setFrame:CGRectMake(0, recommendButtonY, 0, 0)];
        }else{
            [cell.contentView addSubview:recommendButton];
        }
        
        //设置分享的图片
        UIView *shareImagesView=[[UIView alloc] init];
        //设置尺寸
        CGFloat shareCollectionX=10.0;
        CGFloat shareCollectionY=recommendButton.frame.size.height+recommendButton.frame.origin.y+3;
        CGFloat shareCollectionWidth=cell.frame.size.width-2*10;
        CGFloat shareCollectionHeight=0.0;
        
        NSMutableArray *imgsArray=[NSMutableArray array];
        for (UIView *view in self.sharecell.shareImageView.subviews) {
            if (view.class==[UIImageView class]) {
                UIImageView *tempImageView=(UIImageView *)view;
                [imgsArray addObject:tempImageView.image];
            }
        }
        
        if (imgsArray.count==0) {
            shareCollectionHeight = 0;
        }
        if (imgsArray.count>0&&imgsArray.count<4) {
            shareCollectionHeight = 150.0;
        }
        if (imgsArray.count>=4&&imgsArray.count<7) {
            shareCollectionHeight = 300.0;
        }
        if (imgsArray.count>=7&&imgsArray.count<10) {
            shareCollectionHeight = 450.0;
        }
        
        //设置shareImagesView的位置和大小
        [shareImagesView setFrame:CGRectMake(shareCollectionX, shareCollectionY, shareCollectionWidth, shareCollectionHeight)];
        [shareImagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //显示图片
        for (int i=0; i<[imgsArray count]; i++) {
            UIImageView *image=[[UIImageView alloc] init];
            [image setContentMode:UIViewContentModeScaleAspectFit];
            //设置图片
            [image setImage:[imgsArray objectAtIndex:i]];
            CGFloat imageX=90*(i%3)+(i%3)*10;
            CGFloat imageY=140*(i/3)+(i/3)*7;
            CGFloat imageWidth=90.0;
            CGFloat imageHeight=140.0;
            [image setFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
            
            //为每一个UIImageView添加一个手势
            UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
            image.userInteractionEnabled=YES;
            [image addGestureRecognizer:recognizer];
            
            //让UIView添加多个UIImageView
            [shareImagesView addSubview:image];
        }
        
        //将shareImageView添加到cell的视图中
        if (imgsArray.count!=0) {
            [cell.contentView addSubview:shareImagesView];
        }
        
        //设置cell选中时的样式
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        if (commentListArray.count==0) {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font=[UIFont systemFontOfSize:12];
            cell.textLabel.text=@"暂无评论，去添加一个吧！";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            SYJcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commenttableviewcell"];
            cell.delegate = self;
            //[cell.commentCellTableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            cell.dataDic= [commentListArray objectAtIndex:indexPath.row];
            cell.tableHight=[[commentCellHightArray objectAtIndex:indexPath.row] doubleValue]-2;
            //cell.backgroundColor = [UIColor redColor];
            [cell setUpInit];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

#pragma mark - 宝贝连接跳转事件处理
-(void)recommendButtonClicked:(NSString *)goodsId{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BabyDetail" bundle:nil];
    SYJBaybyTableViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"baby"];
    //设置宝贝的id
    vcc.idd = [NSString stringWithFormat:@"%d",self.goodId];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vcc animated:YES];
}

-(void)clicked:(UITapGestureRecognizer *)gesture{
    //获得存放所有图片的view
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return self.sharecell.frame.size.height-30;
    }else{
        if (commentListArray.count==0) {
            return 40;
        }else{
            return [[commentCellHightArray objectAtIndex:indexPath.row] floatValue];
        }
    }
}

#pragma mark - 每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dataDic= [commentListArray objectAtIndex:indexPath.row];
    NSLog(@"%d",[dataDic[@"sharecomment_id"] intValue]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
