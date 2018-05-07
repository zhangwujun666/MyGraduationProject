//
//  SYJCollectTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCollectTableViewCell.h"
#import "SYJCollectTableViewCell.h"
#import "AppDelegate.h"
@implementation SYJCollectTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Cancel:(UIButton *)sender {
    
    APPDELEGATE.CollectStoreid=(int)sender.tag;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancel" object:nil];
}

@end
