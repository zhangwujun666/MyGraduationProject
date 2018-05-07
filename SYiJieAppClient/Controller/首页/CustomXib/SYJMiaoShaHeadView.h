//
//  SYJSYJMiaoShaHeadView.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJMiaoShaHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (strong ,nonatomic)NSString *date;
- (void)setInit;
@end
