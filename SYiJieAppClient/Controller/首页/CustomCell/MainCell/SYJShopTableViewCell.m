//
//  SYJShopTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJShopTableViewCell.h"
#import "SYJShopCollectionViewCell.h"
#define kCellNum 4//每行显示的单元格数目
@implementation SYJShopTableViewCell{
    NSArray * homeClassifyImagesArray;
}

- (void)awakeFromNib {
    [self getDataSource];
    // Initialization code
}
#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/getHotShops",SYJHTTP];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        homeClassifyImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",homeClassifyImagesArray);
        [self.goodsCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.showsHorizontalScrollIndicator = NO;
    //    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
}
#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopcell" forIndexPath:indexPath];
    
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPSHOPIMG,dic[@"store_logo"]]];
    [cell.goodsImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    cell.goodsImage.layer.cornerRadius=cell.goodsImage.frame.size.width/10.0;
    cell.goodsImage.layer.masksToBounds=YES;
    cell.goodsNameLabel.text = dic[@"store_name"];
    cell.goodsNameLabel.textColor = cellTextColor;
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    UIImageView * imageView = [[UIImageView alloc]init];
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPSHOPIMG,dic[@"store_logo"]]];
    [imageView sd_setImageWithURL:urlPath placeholderImage:nil];
    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJShopTableViewCellDelegateWithId:andName:andImage:)]) {
        [self.delegate SYJShopTableViewCellDelegateWithId:dic[@"store_id"] andName:dic[@"store_name"] andImage:imageView];
    }
//    if ([self.delegate respondsToSelector:@selector(SYJShopTableViewCellDelegateWithId:andName:andImage:)]) {
//        
//        //+2是因为数据库中的需要。:[NSString stringWithFormat:@"%lu",indexPath.row+2]
//    }
    
    
    /*
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
    
    /*
     SYJStoreViewController *storeVC=[[SYJStoreViewController alloc] initWithNibName:@"SYJStoreViewController" bundle:nil];
     storeVC.storeId=(int)cell.tag-storeTag;
     NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
     storeVC.storeName=dic[@"store_name"];
     storeVC.storeImage=cell.collImageView.image;
     [self.navigationController pushViewController:storeVC animated:YES];
     */
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width - 20 - (kCellNum-1)*5)/kCellNum;
    return CGSizeMake(cellSize, 90);
}

//cell和cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}


//section距离容器四周边界距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
