//
//  SYJCommentView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/9/2.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCommentView.h"

@implementation SYJCommentView

- (IBAction)ReturnButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SYJCommentView" object:nil];
}

@end
