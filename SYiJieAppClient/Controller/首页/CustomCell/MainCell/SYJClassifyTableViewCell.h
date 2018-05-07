//
//  SYJClassifyTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义代理协议
@protocol SYJClassifyTableViewCellDelegate <NSObject>

-(void)SYJClassifyTableViewCellDelegateWithName:(NSString *)name;

@end


@interface SYJClassifyTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollection;

@property (weak , nonatomic)id<SYJClassifyTableViewCellDelegate>delegate;

@end
