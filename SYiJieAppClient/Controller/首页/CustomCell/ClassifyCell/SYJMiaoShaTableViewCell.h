//
//  SYJMiaoShaTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/5.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJMiaoShaTableViewCellDelegate <NSObject>

-(void)SYJMiaoShaTableViewCellDelegateWithGoodId:(NSString *)goodsId;

@end


@interface SYJMiaoShaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak , nonatomic)id<SYJMiaoShaTableViewCellDelegate>delegate;

@property (strong, nonatomic)NSString * type;
- (void)getDataSourceWithNum:(int)Num;
@end
