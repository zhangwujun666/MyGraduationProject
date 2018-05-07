//
//  SYJAdddizhi.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJAdddizhi.h"

@implementation SYJAdddizhi

-(void)awakeFromNib {
 
}

- (IBAction)addressBUtton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"address" object:nil];
}


@end
