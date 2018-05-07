//
//  SYJCollectView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCollectView.h"

@implementation SYJCollectView

- (IBAction)ReturnButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReturnButton" object:nil];
}


@end
