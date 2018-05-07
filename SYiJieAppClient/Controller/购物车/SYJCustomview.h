//
//  SYJCustomview.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJCustomvDeleate<NSObject>

@end
@interface SYJCustomview : UIView
@property (weak,nonatomic) id<SYJCustomvDeleate>deleate;
@property (weak, nonatomic) IBOutlet UILabel *alltatolButton;
@property (weak, nonatomic) IBOutlet UIButton *selelcallButton;
@property (weak, nonatomic) IBOutlet UILabel *test;

@property (weak, nonatomic) IBOutlet UIButton *GoPlayMoney;
@end