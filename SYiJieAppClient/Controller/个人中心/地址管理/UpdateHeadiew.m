//
//  UpdateHeadiew.m
//  SYiJieAppClient
//
//  Created by administrator on 15/9/2.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "UpdateHeadiew.h"

@implementation UpdateHeadiew

- (IBAction)ReturnButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateHeadiew" object:nil];
}

@end
