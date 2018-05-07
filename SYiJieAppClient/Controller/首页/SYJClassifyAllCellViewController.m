//
//  SYJClassifyAllCellViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/6.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJClassifyAllCellViewController.h"
#import "SYJClassifyAllScrollTableViewCell.h"
#import "SYJClassifyAllTableViewCell.h"
#import "SYJClassifyCellViewController.h"
@interface SYJClassifyAllCellViewController ()

@end

@implementation SYJClassifyAllCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    // Do any additional setup after loading the view.
}
- (void)setUpInit{
    //关闭导航栏
    self.navigationController.navigationBar.hidden =YES;
    //设置头的颜色
    self.titleView.backgroundColor = titleColor;
     /* [self.homeHeadView setFrame:CGRectMake(0, 0, 320, 64)];
     [self.goodsSearchBar setBackgroundColor:homeViewHead];
     [self.goodsSearchBar setTintColor:homeViewHead];
     
     */
    
    //设置tableview的代理为本视图
    self.ClassifyAllTableView.delegate =self;
    self.ClassifyAllTableView.dataSource = self;
    //设置TableView不显示分割线，不显示滚动条
    self.ClassifyAllTableView.separatorStyle = NO;
    self.ClassifyAllTableView.showsVerticalScrollIndicator = NO;
    self.ClassifyAllTableView.scrollEnabled = NO;
    
    
    //self.classifyCellTableView.scrollEnabled = NO;
}
#pragma mark -返回
- (IBAction)backClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分类代理的跳转协议
-(void)SYJClassifyAllTableViewCellDelegateWithClassifyId:(NSString *)classifyId
{
    //第一步：找到storyboard对象
    UIStoryboard *storyBoard =self.storyboard;

        //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
    SYJClassifyCellViewController *ClassifyCellMV = (SYJClassifyCellViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ClassifyCell"];
        
        //第三步:传递参数
    ClassifyCellMV.type = classifyId;
        //第四步：跳转
    [self.navigationController pushViewController:ClassifyCellMV animated:NO];
        //[self presentViewController:ActivityCellMV animated:YES completion:nil];

    
}

#pragma mark - 返回时执行
-(void)viewWillAppear:(BOOL)animated{
    //关闭head
    self.navigationController.navigationBar.hidden = YES;
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
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row ==1){

        SYJClassifyAllScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyallscrolltableviewcell"];
        cell.type =self.type;
        
        [cell getScrollImage];
        return cell;
    }
    else if (indexPath.row ==2){
        SYJClassifyAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyalltableviewcell" forIndexPath:indexPath];
        cell.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int size[3]={1,80,423};
    return size[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0003f;
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
