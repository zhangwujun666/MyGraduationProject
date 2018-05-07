//
//  SYJAreaViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJAreaViewController.h"
#import "UINavigationItem+CustomItem.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "AppDelegate.h"

//#import "PushView.h"
@interface SYJAreaViewController (){
    NSDictionary *_namesDic;
    NSArray *_keysArray;
    NSMutableArray *_filteredNames;
    BOOL _isSearching;
    //UISearchBar * _areaSearchBar;
    //UISearchDisplayController * _areaSearchDisplayController;
}

@end

@implementation SYJAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    
    // Do any additional setup after loading the view.
}
- (void)setUpInit{
    //打开头
    self.navigationController.navigationBar.hidden = NO;
    //设置当前不是搜索模式
    _isSearching = NO;
    //设置头标题
    [self.headNavigationItem setItemWithTitle:@"地区选择" textColor:cellTextColor fontSize:19 itemType:center];
    //获取地区数据地址
    NSString *path = [[NSBundle mainBundle]pathForResource:@"citydict" ofType:@"plist"];
    //获取数据到_nameDic中
    _namesDic = [NSDictionary dictionaryWithContentsOfFile:path];
    //获取数据每个地区的首字母
    NSArray *titleArray = [_namesDic allKeys];
    //排序
    _keysArray =  [titleArray sortedArrayUsingSelector:@selector(compare:) ];
    //searchBarTableView设置代理
    self.searchBarTableView.dataSource = self;
    self.searchBarTableView.delegate =self;
    self.areaSearchBar.delegate = self;
    //初始化查找到的数据存在_filteredNames
    _filteredNames = [NSMutableArray array];
    
    [self.areaSearchBar setPlaceholder:@"搜索城市"];
    
}
- (IBAction)blackButtonItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (_isSearching) {
        return 1;
    }
    return [_keysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (_isSearching) {
        return [_filteredNames count];
    }
    NSString *key = [_keysArray objectAtIndex:section];
    NSArray *names = [_namesDic objectForKey:key];
    return [names count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (_isSearching) {
        cell.textLabel.text = [_filteredNames objectAtIndex:[indexPath row]];
    }
    else{
        //确定是哪个分区
        NSString *key = [_keysArray objectAtIndex:[indexPath section]];
        
        //确定是当前分区中的哪个元素
        NSArray *group = [_namesDic objectForKey:key];
        cell.textLabel.text = [group objectAtIndex:[indexPath row]];
    }
    
    return cell;
}
#pragma mark - 定义每个section的header标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearching) {
        return nil;
    }
    return [_keysArray objectAtIndex:section];
}

#pragma mark - 添加索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isSearching) {
        return nil;
    }
    return _keysArray;
}
//- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

//{
//    
//   // NSString *key = [keys objectAtIndex:index];
//    
//    NSLog(@"sectionForSectionIndexTitle key");
////    
////    if (key == UITableViewIndexSearch) {
////        
////        [table setContentOffset:CGPointZero animated:NO];
//    
//        return NSNotFound;
//        
////    }
//    
//    
//    
//    return index;
//    
//}
#pragma mark - 添加动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView animateWithDuration:0.7 animations:^{
        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

#pragma mark - UISearchBarDelegate协议方法实现
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    //根据关键字查询，显示查询结果
    if (searchText.length == 0) {
        _isSearching = NO;
        [self.searchBarTableView reloadData];
        return;
    }
    _filteredNames = nil;
    _filteredNames = [[NSMutableArray alloc]init];
    if (self.areaSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.areaSearchBar.text]) {
        for ( NSString *key in _keysArray) {
            NSArray * dataArray = _namesDic[key];
            for (int i=0; i<dataArray.count; i++) {
                
                if ([ChineseInclude isIncludeChineseInString:dataArray[i]]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.areaSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_filteredNames addObject:dataArray[i]];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.areaSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [_filteredNames addObject:dataArray[i]];
                    }
                }
                else {
                    NSRange titleResult=[dataArray[i] rangeOfString:self.areaSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_filteredNames addObject:dataArray[i]];
                    }
                }
            }

        }
    }
    else if (self.areaSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.areaSearchBar.text]) {
        for ( NSString *key in _keysArray) {
            NSArray * dataArray = _namesDic[key];
            for (NSString *tempStr in dataArray) {
                NSRange titleResult=[tempStr rangeOfString:self.areaSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_filteredNames addObject:tempStr];
                }
            }
        }

    }
    _isSearching = YES;
    
    [self.searchBarTableView reloadData];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    APPDELEGATE.areaName=cell.textLabel.text;
    if (APPDELEGATE.areaName) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
