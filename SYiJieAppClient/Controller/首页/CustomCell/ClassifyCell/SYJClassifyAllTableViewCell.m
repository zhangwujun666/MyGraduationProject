//
//  SYJClassifyAllTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJClassifyAllTableViewCell.h"
#import "SYJClassifyAllCollectionViewCell.h"
#define kCellNum 4//每行显示的单元格数目
@implementation SYJClassifyAllTableViewCell{
    NSArray * ClassifyImagesArray;
}
- (void)awakeFromNib {
    [self getDataSource];
    
    //self.goodsCollectionView.allowsMultipleSelection = YES;
    
    // Initialization code
}



#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    
    
    NSString *urlPath = [NSString stringWithFormat:@"%@Index/homeclassifyimage",SYJHTTP];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        ClassifyImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",ClassifyImagesArray);
        [self.classifyCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.classifyCollectionView.delegate = self;
    self.classifyCollectionView.dataSource = self;
    
    self.classifyCollectionView.showsVerticalScrollIndicator = NO;
    self.classifyCollectionView.alwaysBounceVertical = YES;
    self.classifyCollectionView.scrollEnabled =NO;
}
#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [ClassifyImagesArray count]-8;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJClassifyAllCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifyallcell" forIndexPath:indexPath];
    //获取数据库中第几张以后的图片名
    NSDictionary *dic = [ClassifyImagesArray objectAtIndex:[indexPath row]+8];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPHOME,dic[@"classifyimage_path"]]];
    [cell.classifyImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    
    cell.classifyImage.layer.cornerRadius = cell.classifyImage.frame.size.width/3;
    cell.classifyImage.layer.masksToBounds=YES;
    cell.classifyImage.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.classifyNameLabel.text = dic[@"classifyimage_name"];
    cell.classifyNameLabel.textColor = cellTextColor;
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int classifyId[16] = {2,3,4,6,7,8,2,5,2,2,2,2,2,2,2,2};
    //让代理执行操作，同时传递参数
    if ([self.delegate  respondsToSelector:@selector(SYJClassifyAllTableViewCellDelegateWithClassifyId:)]) {
        [self.delegate SYJClassifyAllTableViewCellDelegateWithClassifyId:[NSString stringWithFormat:@"%u",classifyId[indexPath.row] ]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width  - (kCellNum-1)*1)/kCellNum;
    return CGSizeMake(cellSize, 92);
}

//cell和cell之间的间隔
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 1.0;
//}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
//    minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 1.0;
//}
//
////section距离容器四周边界距离
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0.001, 0.001, 0.001, 0.001);
//    //上、左、下、右
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
