//
//  ScorllViewViewController.m
//  引导页面之ScrollView
//
//  Created by administrator on 15/7/4.
//  Copyright (c) 2015年 wanderer. All rights reserved.
//

#import "ScorllViewViewController.h"


@interface ScorllViewViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *pagingScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *enterButton;
@property (nonatomic,strong) NSArray *imagesNames;
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *customView;

@end

@implementation ScorllViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建scrollView视图
    self.pagingScrollView=[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.pagingScrollView.delegate=self;
    self.pagingScrollView.pagingEnabled=YES;
    self.pagingScrollView.showsHorizontalScrollIndicator=NO;
    
    //将scrollView添加到当前视图中
    [self.view addSubview:self.pagingScrollView];
    
    self.view.backgroundColor=[UIColor redColor];
    
    //初始化数组
    self.imagesNames=[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png", nil];
    
    //获取当前view的大小
    CGRect frame=[[UIScreen mainScreen] bounds];
    //创建imageView对象，并添加到scrollView中
    for (int i=0; i<[self.imagesNames count]; i++) {
        NSString *name=[self.imagesNames objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageView.frame=CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height);
        imageView.tag=i+1;
        [self.pagingScrollView addSubview:imageView];
    }
    
    self.pagingScrollView.contentSize=CGSizeMake([self.imagesNames count]*frame.size.width, frame.size.height);
    
    //创建page
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 0)];
    self.pageControl.numberOfPages=[self.imagesNames count];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    
    [self.view addSubview:self.pageControl];
    
    //进入按钮
    if (!self.enterButton) {
        self.enterButton=[[UIButton alloc] init];
        [self.enterButton setTitle:@"立即启用" forState:UIControlStateNormal];
        self.enterButton.layer.borderWidth=0.5;
        self.enterButton.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    
    [self.enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    
    self.enterButton.frame=CGRectMake(50, frame.size.height-100, frame.size.width-100, 50);
    
    self.enterButton.alpha=0;
    
//    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayButton) userInfo:nil repeats:YES];
//    [self.timer fire];
    
    [self.view addSubview:self.enterButton];
}


//scrollView滚动的时候触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((int)scrollView.contentOffset.x%(int)scrollView.frame.size.width==0) {
        self.pageControl.currentPage=(int)scrollView.contentOffset.x/(int)scrollView.frame.size.width;
        if (scrollView.contentOffset.x==scrollView.frame.size.width*([self.imagesNames count]-1)) {
            //self.enterButton.alpha=1;
            [UIView animateWithDuration:1.5 animations:^{
                self.enterButton.alpha=1.0;
            }];
        }else{
                self.enterButton.alpha=0;
        }
    }
}


-(void)enter:(UIButton *)sender{
    //调用block块
    self.didSelectedEnter();
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
