//
//  CarView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "CarView.h"
#import "AppDelegate.h"
@implementation CarView
-(void)awakeFromNib{
    self.GoShop.layer.cornerRadius=8;
    self.AddCar.layer.cornerRadius=8;
    self.carnumberview.layer.cornerRadius=self.carnumberview.frame.size.width/2;
}
#pragma mark 立即购买
- (IBAction)BuyButton:(UIButton *)sender {
      [[NSNotificationCenter defaultCenter]postNotificationName:@"addcar" object:nil];
 
}
#pragma mark 加入购物车
- (IBAction)addCarButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"name" object:nil];
    
}

@end
