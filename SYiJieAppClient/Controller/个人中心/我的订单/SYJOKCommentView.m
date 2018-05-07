//
//  SYJOKCommentView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/15.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJOKCommentView.h"
#import "AppDelegate.h"
@implementation SYJOKCommentView
-(void)awakeFromNib{
    [self.SelectButton setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
}
- (IBAction)SelectButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"niming" object:nil];
    APPDELEGATE.niming=YES;
}

- (IBAction)OKCommentButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"comment" object:nil];
}

@end
