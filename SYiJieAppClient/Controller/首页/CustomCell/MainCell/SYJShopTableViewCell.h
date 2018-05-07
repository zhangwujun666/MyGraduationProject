//
//  SYJShopTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义代理协议
@protocol SYJShopTableViewCellDelegate <NSObject>

-(void)SYJShopTableViewCellDelegateWithId:(NSString *)Id andName:(NSString *)Name andImage:(UIImageView *)Image;

@end


@interface SYJShopTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;

@property (weak , nonatomic)id<SYJShopTableViewCellDelegate>delegate;
@end
