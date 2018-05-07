//
//  SYJsex.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SexViewDelegate <NSObject>

-(void)selectMan;//点击按钮调用
-(void)selectWoman;//点击按钮调用
@end
@interface SYJsex : UIView
@property (nonatomic, retain) UIControl *controlForDismiss;
@property (weak, nonatomic) IBOutlet UIButton *ManButton;
@property (weak, nonatomic) IBOutlet UIButton *WomanButton;
@property(weak,nonatomic) id<SexViewDelegate>delegate;
@end
