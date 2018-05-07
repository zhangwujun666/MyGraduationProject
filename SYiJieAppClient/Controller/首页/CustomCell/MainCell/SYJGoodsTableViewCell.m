//
//  SYJGoodsTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJGoodsTableViewCell.h"
#import "SYJGoodsCollectionViewCell.h"
#import "SYJDetailTableViewController.h"
#define kCellNum 2//每行显示的单元格数目
@implementation SYJGoodsTableViewCell{
    NSArray * homeClassifyImagesArray;
}

- (void)awakeFromNib {
    [self getDataSource];
    // Initialization code
}


#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/getLowGoods",SYJHTTP];
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
    //初始化有几个商品
    self.goodsNum = 20.0;
    
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.showsVerticalScrollIndicator = NO;//是否显示滚动条
    //self.goodsCollectionView.alwaysBounceVertical = YES;
    self.goodsCollectionView.scrollEnabled =NO; // 是否可滚动
    //self.goodsCollectionView.
    //    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scroll!%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y < 0.5) {
//        
//        //self.mainTableView.scrollEnabled =NO;
//        self.goodsCollectionView.scrollEnabled = NO;
//        if ([self.delegate  respondsToSelector:@selector(SYJGoodsTableViewCellDelegateLoadMoreData)]) {
//            [self.delegate SYJGoodsTableViewCellDelegateLoadMoreData];
//        }
//    }
//
//}
//

#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return [homeClassifyImagesArray count];
    if (self.goodsNum > [homeClassifyImagesArray count]) {
        return [homeClassifyImagesArray count];
    }
    return self.goodsNum;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodscell" forIndexPath:indexPath];
    
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPGOODIMG,dic[@"goods_image"]]];
    [cell.goodsImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    cell.goodsName.text = dic[@"goods_name"];
    cell.goodsName.textColor = cellTextColor;
    cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",dic[@"goods_price"]];
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJGoodsTableViewCellDelegateWithGoodId:)]) {
        [self.delegate SYJGoodsTableViewCellDelegateWithGoodId:dic[@"goods_id"]];
    }
    /*
     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SYJDetailTableViewController *vcc= [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
     vcc.babyid=[idarr objectAtIndex:current];
     [self.navigationController pushViewController:vcc animated:YES];
     */
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width - 20 - (kCellNum-1)*5)/kCellNum;
    return CGSizeMake(cellSize, 235);
}

//cell和cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0 ;
}


//section距离容器四周边界距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
    //上、左、下、右
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
