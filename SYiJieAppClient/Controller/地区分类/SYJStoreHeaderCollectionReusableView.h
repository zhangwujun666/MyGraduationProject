//
//  SYJStoreHeaderCollectionReusableView.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol storeControllerDelegate<NSObject>
    -(void)allGoodClicked;//全部商品
    -(void)upNewGoodClicked;//上新
    -(void)promotionGoodClicked;//促销
    -(void)showMap;//显示地图
    -(void)addLike:(UIButton *)button andLabel:(UILabel *)label;//加关注点击事件
@end

@interface SYJStoreHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *allGoodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allGoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *upNewGoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionGoodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionGoodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *allGoodView;
@property (weak, nonatomic) IBOutlet UIView *upNewGoodView;
@property (weak, nonatomic) IBOutlet UIView *promotionView;

@property (weak, nonatomic) id<storeControllerDelegate> delegate;

@end
