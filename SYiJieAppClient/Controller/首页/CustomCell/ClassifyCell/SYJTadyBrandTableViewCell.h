//
//  SYJTadyBrandTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义代理协议
@protocol SYJTadyBrandTableViewCellDelegate <NSObject>

-(void)SYJTadyBrandTableViewCellDelegateWithshopId:(NSString *)shopId;

@end

@interface SYJTadyBrandTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *tadyBrandCollectionView;
@property (strong, nonatomic)NSString * type;

@property (weak , nonatomic)id<SYJTadyBrandTableViewCellDelegate>delegate;

-(void)getDataSource;
@end
