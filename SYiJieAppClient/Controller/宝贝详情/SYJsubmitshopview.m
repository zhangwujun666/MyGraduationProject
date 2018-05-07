//
//  SYJsubmitshopview.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJsubmitshopview.h"
#import "AppDelegate.h"
@implementation SYJsubmitshopview
-(void)awakeFromNib{
    self.sumbiltButton.layer.cornerRadius=8;
   
}
- (IBAction)submit:(UIButton *)sender {
     
      [[NSNotificationCenter defaultCenter]postNotificationName:@"submits" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"twosubmits" object:nil];
}


@end
