//
//  SYJScrollTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJScrollTableViewCell.h"

@implementation SYJScrollTableViewCell{
    NSArray * homeScrollImagesArray;
    NSTimer *timer;
}

- (void)awakeFromNib {
    [self getScrollImage];
    // Initialization code
}
#pragma mark - 发送POST请求,获取商品信息
-(void)getScrollImage{
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/scrollimage",SYJHTTP];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *info=@{@"homescrollimage_type":@"1"
                              };
    
    [manager POST:urlPath parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        homeScrollImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",homeScrollImagesArray);
        [self setScrollImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    
    
}
#pragma mark - 设置商品详情页面
- (void) setScrollImage{
    //获取scorllView的尺寸
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    //添加图到ScorllView中
    for (int i=0; i<[homeScrollImagesArray count]; i++) {
        // 设置frame
        CGFloat imageX = i * imageW;
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //UIViewContentModeScaleToFill
        imageView.contentMode = UIViewContentModeScaleToFill;
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        //获取图片相对路径
        NSDictionary * dic = [homeScrollImagesArray objectAtIndex:i];
        //获取图片路径
        NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPHOME,dic[@"homescrollimage_path"]]];
        [imageView sd_setImageWithURL:urlPath placeholderImage:nil] ;
        //给image添加点击事件
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *gersture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageCliked:)];
        [imageView addGestureRecognizer:gersture];
        //将图片加入到scrollView中
        [self.scrollView addSubview:imageView];
    }
    // 2.设置内容尺寸
    CGFloat contentW = [homeScrollImagesArray count] * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, imageH);
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    //设置代理
    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
    self.scrollPageControl.numberOfPages = [homeScrollImagesArray count];
    
    // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
    
}
//点击
-(void)imageCliked:(UITapGestureRecognizer *)recognizer{
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"infor" message:[NSString stringWithFormat:@"hi %d",(int)recognizer.view.tag] delegate:nil cancelButtonTitle:@"oK" otherButtonTitles: nil];
//    
//    [alert show];
}
-(void) addTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //设置多线程。
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}
- (void)removeTimer
{
    [timer invalidate];
    timer = nil;
}

-(void) nextImage{
    NSInteger page = 0;
    if (self.scrollPageControl.currentPage == [homeScrollImagesArray count]-1) {
        page = 0;
    }
    else{
        page = self.scrollPageControl.currentPage +1;
    }
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}




#pragma mark - 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.scrollPageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
