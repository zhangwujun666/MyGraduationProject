//
//  SYJsex.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJsex.h"
#import "SYJPersondataTableViewController.h"
#import "SYJPersonalTableViewController.h"
@interface SYJsex()<SexViewDelegateee>

@end
@implementation SYJsex
{
    SYJPersondataTableViewController *dataview;
}
@synthesize controlForDismiss = _controlForDismiss;
-(void)awakeFromNib{
    
    //    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    
}
- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha= 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            
        }
    }];
}

- (IBAction)ManButton:(id)sender {
    if([self.delegate respondsToSelector:@selector(selectMan)]){
        [self.delegate selectMan];
    }
    [self animatedOut];
    dataview.view.backgroundColor=[UIColor redColor];
    dataview.view.alpha=1;
}

- (IBAction)WomanButton:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(selectMan)]){
        [self.delegate selectWoman];
    }
    [self animatedOut];
    dataview.view.backgroundColor=[UIColor redColor];
    dataview.view.alpha=1;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
    
}
-(void)appear{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha= 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            
        }
    }];
}
@end
