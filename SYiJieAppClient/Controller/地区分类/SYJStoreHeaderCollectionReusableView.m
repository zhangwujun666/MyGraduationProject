//
//  SYJStoreHeaderCollectionReusableView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJStoreHeaderCollectionReusableView.h"

@implementation SYJStoreHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    //创建一个单击手势，加到第一个区域上
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstClicked)];
    self.allGoodView.userInteractionEnabled=YES;
    [self.allGoodView addGestureRecognizer:tapGestureRecognizer];

    //创建第二个手势,加到第二个区域上
    UITapGestureRecognizer *upNewTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondClicked)];
    self.upNewGoodView.userInteractionEnabled=YES;
    [self.upNewGoodView addGestureRecognizer:upNewTapGestureRecognizer];
    
    //创建第三个手势,加到第三个区域上
    UITapGestureRecognizer *promotionTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promotionClicked)];
    self.promotionView.userInteractionEnabled=YES;
    [self.promotionView addGestureRecognizer:promotionTapGestureRecognizer];
}

//第一个回调方法
-(void)firstClicked{
    //改变颜色
    self.allGoodCountLabel.textColor=[UIColor redColor];
    self.allGoodLabel.textColor=[UIColor redColor];
    
    self.upNewGoodCountLabel.textColor=[UIColor blackColor];
    self.upNewGoodLabel.textColor=cellTextColor;
    
    self.promotionGoodCountLabel.textColor=[UIColor blackColor];
    self.promotionGoodLabel.textColor=cellTextColor;
    
    if ([self.delegate respondsToSelector:@selector(allGoodClicked)]) {
        [self.delegate allGoodClicked];
    }
}

//第二个回调方法
-(void)secondClicked{
    //改变颜色
    self.allGoodCountLabel.textColor=[UIColor blackColor];
    self.allGoodLabel.textColor=cellTextColor;
    
    self.upNewGoodCountLabel.textColor=[UIColor redColor];
    self.upNewGoodLabel.textColor=[UIColor redColor];
    
    self.promotionGoodCountLabel.textColor=[UIColor blackColor];
    self.promotionGoodLabel.textColor=cellTextColor;
    
    if ([self.delegate respondsToSelector:@selector(upNewGoodClicked)]) {
        [self.delegate upNewGoodClicked];
    }
}

//第三个回调方法
-(void)promotionClicked{
    //改变颜色
    self.allGoodCountLabel.textColor=[UIColor blackColor];
    self.allGoodLabel.textColor=cellTextColor;
    
    self.upNewGoodCountLabel.textColor=[UIColor blackColor];
    self.upNewGoodLabel.textColor=cellTextColor;
    
    self.promotionGoodCountLabel.textColor=[UIColor redColor];
    self.promotionGoodLabel.textColor=[UIColor redColor];
    
    if ([self.delegate respondsToSelector:@selector(promotionGoodClicked)]) {
        [self.delegate promotionGoodClicked];
    }
}

//加关注点击
- (IBAction)likeClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addLike:andLabel:)]) {
        [self.delegate addLike:self.likeButton andLabel:self.likeCount];
    }
}

- (IBAction)goToStore:(UIButton *)sender {
    //显示地图
    if ([self.delegate respondsToSelector:@selector(showMap)]) {
        [self.delegate showMap];
    }
}
@end
