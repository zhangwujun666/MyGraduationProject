//
//  SYJcommentTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJcommentTableViewCellDelegate <NSObject>

-(void)addCommentTowSharecommentId:(NSString *)SharecommentId andSharecommentName:(NSString *)SharecommentName;//添加二级评论


@end

@interface SYJcommentTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)NSDictionary *dataDic;
@property (strong, nonatomic)NSString * sharecomment_id;
@property (weak, nonatomic) IBOutlet UITableView *commentCellTableView;

@property (nonatomic) CGFloat tableHight;
@property (nonatomic,weak) id<SYJcommentTableViewCellDelegate> delegate;//声明代理
- (void)setUpInit;
@end
