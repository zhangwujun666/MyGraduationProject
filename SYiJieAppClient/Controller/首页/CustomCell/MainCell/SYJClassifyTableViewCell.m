//
//  SYJClassifyTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJClassifyTableViewCell.h"
#import "SYJClassifyCollectionViewCell.h"
#import "SYJClassifyCellViewController.h"
#import "SYJHomeViewController.h"
#define kCellNum 4//每行显示的单元格数目
@implementation SYJClassifyTableViewCell{
    NSArray * homeClassifyImagesArray;

}

- (void)awakeFromNib {
    [self getDataSource];
    //[self.classifyCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"classifytableviewcell"];

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
        homeClassifyImagesArray = dicdescription[@"data"];
        NSLog(@"dic=%@",homeClassifyImagesArray);
        [self.classifyCollection reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    self.classifyCollection.delegate = self;
    self.classifyCollection.dataSource = self;
}

#pragma mark -UICollectionViewDataSource
#pragma mark -一共有几个网格
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
#pragma mark -每个网格显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SYJClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifycollectionviewcell" forIndexPath:indexPath];
    
    NSDictionary *dic = [homeClassifyImagesArray objectAtIndex:[indexPath row]];
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPHOME,dic[@"classifyimage_path"]]];
    [cell.classifyImage sd_setImageWithURL:urlPath placeholderImage:nil];

    cell.classifyImage.layer.cornerRadius=cell.classifyImage.frame.size.width/2.50;
    cell.classifyImage.layer.masksToBounds=YES;
    cell.classifyName.text = dic[@"classifyimage_name"];
    
    cell.classifyName.textColor = cellTextColor;
    return cell;
}

#pragma mark -UICollectionViewDelegate
#pragma mark - 点击每个网格后产生的事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //让代理执行操作，同时传递参数
    if ([self.delegate respondsToSelector:@selector(SYJClassifyTableViewCellDelegateWithName:)]) {
        [self.delegate SYJClassifyTableViewCellDelegateWithName:[NSString stringWithFormat:@"%lu",indexPath.row+2]];
        //+2是因为数据库中的需要。
    }

    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    int cellSize = (rect.size.width - 10 - (kCellNum-1)*5)/kCellNum;
    return CGSizeMake(cellSize, 57);
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
