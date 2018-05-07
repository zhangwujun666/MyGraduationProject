//
//  SYJGoodsTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJHomeViewController.h"
@protocol SYJGoodsTableViewCellDelegate <NSObject>

-(void)SYJGoodsTableViewCellDelegateWithGoodId:(NSString *)goodsId;
-(void)SYJGoodsTableViewCellDelegateLoadMoreData;
@end

@interface SYJGoodsTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (weak , nonatomic)id<SYJGoodsTableViewCellDelegate>delegate;
@property (nonatomic) CGFloat goodsNum;

@end
