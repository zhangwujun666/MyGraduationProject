//
//  SYJHotGoodsTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/5.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJHotGoodsTableViewCell.h"
#import "SYJHotGoodsCollectionViewCell.h"
#define kCellNum 2//每行显示的单元格数目
@implementation SYJHotGoodsTableViewCell
{
    NSArray * homeClassifyImagesArray;
}
- (void)awakeFromNib {
    self.goodsNum = 10;
    self.goodsCollectionView.allowsMultipleSelection = YES;

    // Initialization code
}



#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    NSArray *typeArr = @[@"女装",@"男装",@"童装",@"家居服",@"上衣",@"裤子",@"内衣"];
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/getClassifyHotGoods",SYJHTTP];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *info=@{@"goods_sort":typeArr[[self.type intValue]-2],
                         @"goods_promotion":@"1"
                         };
    [manager POST:urlPath parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    self.goodsCollectionView.showsVerticalScrollIndicator = NO;
    self.goodsCollectionView.alwaysBounceVertical = YES;
    self.goodsCollectionView.scrollEnabled =NO;
    //self.goodsCollectionView.
    //    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
}
#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.goodsNum > [homeClassifyImagesArray count]) {
        return [homeClassifyImagesArray count];
    }
    return self.goodsNum;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJHotGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotgoodscell" forIndexPath:indexPath];
    
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
