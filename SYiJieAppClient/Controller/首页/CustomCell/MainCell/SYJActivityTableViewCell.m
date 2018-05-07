//
//  SYJActivityTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJActivityTableViewCell.h"
#import "SYJActivityCollectionViewCell.h"
#import "SYJActivityCellViewController.h"
#import "SYJHomeViewController.h"
#define kCellNum 4//每行显示的单元格数目
@implementation SYJActivityTableViewCell{
    NSArray * homeClassifyImagesArray;
}

- (void)awakeFromNib {
    [self getDataSource];
    // Initialization code
}
#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/homemiaoshaactivityimage",SYJHTTP];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        homeClassifyImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",homeClassifyImagesArray);
        [self setUpClassifyCollection];
        [self.activityCollenctionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.activityCollenctionView.delegate = self;
    self.activityCollenctionView.dataSource = self;
    self.activityCollenctionView.showsHorizontalScrollIndicator = NO;
//    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
}
-(void)setUpClassifyCollection{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ((((int)scrollView.contentOffset.x)%84) < 42) {
        CGFloat page = ((int)scrollView.contentOffset.x)/84;
        CGFloat offsetX = page * 84;
        CGPoint offset = CGPointMake(offsetX, 0);
        [scrollView setContentOffset:offset animated:YES];
    }
    else{
        CGFloat page = ((int)scrollView.contentOffset.x)/84;
        CGFloat offsetX = (page+1) * 84;
        CGPoint offset = CGPointMake(offsetX, 0);
        [scrollView setContentOffset:offset animated:YES];
    }
    NSLog(@"end!%f",scrollView.contentOffset.x);
    
}
#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"activitygoods" forIndexPath:indexPath];
    
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPHOME,dic[@"miaoshaactivityimage_path"]]];
    [cell.activityImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    cell.activityImage.layer.cornerRadius = cell.activityImage.frame.size.width/15.0;
    cell.activityImage.layer.masksToBounds=YES;
    cell.goodsnameLabel.text = dic[@"miaoshaactivityimage_price"];
    cell.goodsnameLabel.textColor = [UIColor redColor];
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJActivityTableViewCellDelegateWithGoodId:)]) {
        [self.delegate SYJActivityTableViewCellDelegateWithGoodId:dic[@"goods_id"]];
    }    /*
    //第一步：找到storyboard对象
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //第二步：从storyboard对象根据StoryboardID找到mainViewController对象
    SYJActivityCellViewController *ActivityCellMV = (SYJActivityCellViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ActivityCellMV"];
    
    //第三步:传递参数
    //mainVc.name = self.accountTextField.text;
    
    //第四步：跳转
    SYJHomeViewController * a = [[SYJHomeViewController alloc]init];
    [a presentViewController:ActivityCellMV animated:YES completion:nil];

    */
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width - 30 - (kCellNum-1)*1)/kCellNum;
    return CGSizeMake(cellSize, 100);
}

//cell和cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}


//section距离容器四周边界距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
