//
//  SYJPersondata.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/31.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJPersondata.h"

@implementation SYJPersondata

- (IBAction)BlackButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"personname" object:nil];
}

@end
