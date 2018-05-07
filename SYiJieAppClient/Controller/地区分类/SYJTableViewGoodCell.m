//
//  SYJTableViewGoodCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/6.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJTableViewGoodCell.h"

@implementation SYJTableViewGoodCell

- (void)awakeFromNib {
    // Initialization code
    self.salesLabel.textColor=btnColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
