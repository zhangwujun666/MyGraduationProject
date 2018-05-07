//
//  SaveAdressView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SaveAdressView.h"

@implementation SaveAdressView

- (IBAction)SaveButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"save" object:nil];
}


@end
