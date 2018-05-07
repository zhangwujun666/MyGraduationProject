//
//  SYJcommentTowTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJcommentTowTableViewCell : UITableViewCell
@property (strong, nonatomic)UILabel * commentContent;
@property (strong, nonatomic)NSDictionary *dataDic;
- (void)setUpInitOne;
- (void)setUpInitTow;
@end
