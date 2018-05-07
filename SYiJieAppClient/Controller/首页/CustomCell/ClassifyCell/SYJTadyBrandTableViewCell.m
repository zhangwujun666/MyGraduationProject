//
//  SYJTadyBrandTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJTadyBrandTableViewCell.h"
#import "SYJTadyBrandCollectionViewCell.h"
#define kCellNum 3//每行显示的单元格数目
@implementation SYJTadyBrandTableViewCell{
    NSArray * tadyBrandImagesArray;
}

- (void)awakeFromNib {
    //[self getDataSource];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/gettadybrand",SYJHTTP];
    NSDictionary *info=@{@"goods_istadybrand":self.type
                         };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        tadyBrandImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",tadyBrandImagesArray);
        [self.tadyBrandCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.tadyBrandCollectionView.delegate = self;
    self.tadyBrandCollectionView.dataSource = self;
    self.tadyBrandCollectionView.showsVerticalScrollIndicator = NO;
    self.tadyBrandCollectionView.alwaysBounceVertical = YES;
    self.tadyBrandCollectionView.scrollEnabled =NO;
    //self.goodsCollectionView.
    //    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
}
#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJTadyBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = [tadyBrandImagesArray objectAtIndex:[indexPath row]];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@goodimg/%@",korderimage,dic[@"goods_image"]]];
    [cell.image sd_setImageWithURL:urlPath placeholderImage:nil] ;
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [tadyBrandImagesArray objectAtIndex:[indexPath row]];
    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJTadyBrandTableViewCellDelegateWithshopId:)]) {
        [self.delegate SYJTadyBrandTableViewCellDelegateWithshopId:dic[@"store_id"] ];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width - 10 - (kCellNum-1))/kCellNum;
    return CGSizeMake(cellSize, 210);
}

//cell和cell之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0 ;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

//section距离容器四周边界距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1.0, 5.0, 5.0, 5.0);
    //上、左、下、右
}
@end
