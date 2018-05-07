//
//  SYJStoreCollectionViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJStoreCollectionViewCell.h"

@implementation SYJStoreCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    //设置字体的大小和颜色
    self.goodNameLabel.font=textFont;
    self.goodNameLabel.textColor=cellTextColor;
    self.priceLabel.font=textFont;
    self.goodCountLabel.font=textFont;
    self.goodCountLabel.textColor=cellTextColor;
}

@end
