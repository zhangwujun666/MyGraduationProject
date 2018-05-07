//
//  SYJHeadView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/14.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJHeadView.h"

@implementation SYJHeadView
-(void)awakeFromNib{
    self.one.tag = 101;
    self.two.tag = 102;
    self.stree.tag=103;
    self.fore.tag=104;
    self.i=40;
    self.line.tag = self.one.tag;
   self.view=[[UIView alloc]initWithFrame:CGRectMake(15, 40, 58, 2)];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.view];
   
}
- (IBAction)One:(UIButton *)sender {
  [self move:sender];
   
   
}

- (void)move:(UIButton *)sender{
    if(sender.tag==101){
         [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        [self.two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.stree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.fore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if([self.delegate respondsToSelector:@selector(requestt)]){
            [self.delegate requestt];
        }
        [UIView animateWithDuration:0.3 animations:^{
        
         self.view.frame=CGRectMake(15, 40, 58, 2);
                    
        }];
    }
    else if (sender.tag==102){
         [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        [self.stree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.fore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(requesttwo)]) {
            [self.delegate requesttwo];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame=CGRectMake(95, 40, 58, 2);
            
        }];
    }
    else if (sender.tag==103)
      {
   [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
          [self.fore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [self.two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [self.one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(requeststree)]) {
        [self.delegate requeststree];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame=CGRectMake(175, 40, 58, 2);
        
    }];
  }
    else{
        [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        [self.stree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(requestfore)]) {
            [self.delegate requestfore];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame=CGRectMake(255, 40, 58, 2);
            
        }];
    }

}


@end
