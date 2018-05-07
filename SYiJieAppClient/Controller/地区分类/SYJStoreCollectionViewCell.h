//
//  SYJStoreCollectionViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJStoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;

@end
