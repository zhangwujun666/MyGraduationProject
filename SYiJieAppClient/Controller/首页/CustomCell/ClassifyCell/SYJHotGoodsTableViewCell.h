//
//  SYJHotGoodsTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/5.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义代理协议
@protocol SYJHotGoodsTableViewCellDelegate <NSObject>
-(void)SYJGoodsTableViewCellDelegateWithGoodId:(NSString *)goodsId;

@end

@interface SYJHotGoodsTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic)NSString * type;
@property (weak , nonatomic)id<SYJHotGoodsTableViewCellDelegate>delegate;
@property (nonatomic)int goodsNum;
-(void)getDataSource;
@end
