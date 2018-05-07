//
//  SYJMainTabViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJMainTabViewController.h"

@interface SYJMainTabViewController ()

@end

@implementation SYJMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetTabBar];
}
- (void)SetTabBar{
    //设置tabbar的title字体选中时颜色
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateSelected];
    //模式tabbar图标选中时的描边颜色
    [self.tabBar setTintColor:[UIColor redColor]];
    self.tabBar.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Do any additional setup after loading the view.
    //向Tabbar中添加第一个页面
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取storyboard的初始页面
    UIViewController *mainVC = [mainStoryBoard instantiateInitialViewController];
    [self addViewController:mainVC andTitle:@"首页" andImage:@"tabBar_home_press@2x"];
    //向Tabbar中添加第二个页面
    UIViewController *classifyVC = [[UIStoryboard storyboardWithName:@"Classify" bundle:nil] instantiateInitialViewController];
    
    [self addViewController:classifyVC andTitle:@"分类" andImage:@"tabBar_category_press@2x"];

    //向Tabbar中添加第三个页面
    UIViewController *carGoodsVC = [[UIStoryboard storyboardWithName:@"CarGoods" bundle:nil] instantiateInitialViewController];
    
    [self addViewController:carGoodsVC andTitle:@"购物车" andImage:@"tabBar_cart_press@2x"];
    //abBar_cart_normal
    //向Tabbar中添加第四个页面
    UIViewController *communityVC = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateInitialViewController];
    [self addViewController:communityVC andTitle:@"社区" andImage:@"tabBar_find_press@2x"];
    
    //向Tabbar中添加第五个页面
    UIViewController *personVC = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateInitialViewController];
    [self addViewController:personVC andTitle:@"我的" andImage:@"tabBar_myJD_press@2x"];

    
    //设置TabBar默认显示页面（不设置默认为0）
    self.selectedIndex = 0;
}
#pragma mark-添加vc到tabbar中，并设置tabbaritem属性
-(void)addViewController:(UIViewController *)vc andImage:(NSString *)imageName{
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    [self addChildViewController:vc];
    
}
-(void)addViewController:(UIViewController *)vc andTitle:(NSString *)title andImage:(NSString *)imageName{
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    [self addChildViewController:vc];
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
