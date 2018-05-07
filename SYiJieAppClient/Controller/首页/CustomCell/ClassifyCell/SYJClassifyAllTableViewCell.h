//
//  SYJClassifyAllTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJClassifyAllTableViewCellDelegate <NSObject>

-(void)SYJClassifyAllTableViewCellDelegateWithClassifyId:(NSString *)classifyId;

@end

@interface SYJClassifyAllTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;
@property (weak , nonatomic)id<SYJClassifyAllTableViewCellDelegate>delegate;
@end
