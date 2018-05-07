//
//  SYJShareTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/17.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJCommentDelegate <NSObject>

-(void)likeClicked:(int)cellTag andLikeLabel:(UILabel *)likeLabel andImageView:(UIImageView *)imageView;//点赞按钮
-(void)commentClicked:(int)cellTag;//评论按钮

-(void)recommendButtonClicked:(NSString *)goodsId;//连接按钮
-(void)showOtherPlace:(int)cellTag;//转发按钮
-(void)imageClicked:(UITapGestureRecognizer *)gesture;//图片的点击事件

@end

@interface SYJShareTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary * dataDic;
@property (strong, nonatomic) UIView * shareImageView;
@property (strong, nonatomic) UIButton * recommendButton;
@property (strong, nonatomic) UILabel *repeatLabel;//显示转发心情的label
@property (strong, nonatomic) NSString * goodsId;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *shareName;//名字
@property (weak, nonatomic) IBOutlet UILabel *shareTime;//时间

@property (weak, nonatomic) IBOutlet UIButton *collectButton;//收藏
@property (strong,nonatomic) UILabel *shareContent;//内容

@property (weak, nonatomic) IBOutlet UILabel *decollatorRightLable;
@property (weak, nonatomic) IBOutlet UILabel *decollatorLiftLable;
@property (weak, nonatomic) IBOutlet UILabel *decollatorHeadLable;

@property (weak, nonatomic) IBOutlet UIImageView *transmitImage;//转发
@property (weak, nonatomic) IBOutlet UILabel *transmitName;

@property (weak, nonatomic) IBOutlet UIImageView *commentImage;//评论
@property (weak, nonatomic) IBOutlet UILabel *commentName;

@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *likeName;

@property (weak, nonatomic) IBOutlet UIView *handleView;



@property (nonatomic,weak) id<SYJCommentDelegate> delegate;//声明代理
-(void)getDataSource;
- (CGFloat)getCellHight;
@end
