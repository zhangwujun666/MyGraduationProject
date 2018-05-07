//
//  SYJbabyhead.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJbabyhead.h"
#import "SYJOrdderTableViewController.h"
@implementation SYJbabyhead

- (IBAction)oneBUtton:(UIButton *)sender {
    [ self.Enterstore.titleLabel setTintColor:[UIColor redColor]];
   [[NSNotificationCenter defaultCenter]postNotificationName:@"nameee" object:nil];
    [self.one setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.one.layer.cornerRadius=10;
    [self.two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   
    self.two.layer.cornerRadius=10;
    [self.Enterstore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
}
- (IBAction)twoButton:(UIButton *)sender {
    
   
    //[self.two.titleLabel setTextColor:[UIColor redColor]];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"namee" object:nil];
    [self.two setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Enterstore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 
}
- (IBAction)Enterstore:(UIButton *)sender {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"gostore" object:nil];
    [self.two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Enterstore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  
}

@end
