//
//  SYJActivityTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJActivityTableViewCellDelegate <NSObject>

-(void)SYJActivityTableViewCellDelegateWithGoodId:(NSString *)goodsId;

@end
@interface SYJActivityTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *activityCollenctionView;

@property (weak , nonatomic)id<SYJActivityTableViewCellDelegate>delegate;

@end
