//
//  SYJSizeselect.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/10.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSizeselect.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
@implementation SYJSizeselect
-(void)awakeFromNib{
    
    self.sure.layer.cornerRadius=7;
    self.i=1;
     APPDELEGATE.shopnumber=[NSString stringWithFormat:@"1"];
}
-(void)sizeanimate{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0,275, [[UIScreen mainScreen]bounds].size.width, 400);
    }];
}
-(void)sizeanimatetwo{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 300, [[UIScreen mainScreen]bounds].size.width, 100);
    }];
}
- (IBAction)cancelButton:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 650, [[UIScreen mainScreen]bounds].size.width, 200);
    }
     completion:^(BOOL finished) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"cancel" object:nil];
         APPDELEGATE.Stateone=NO;
         APPDELEGATE.ColourctState=NO;
     
    }];


}

- (IBAction)SureButton:(UIButton *)sender {
    if(APPDELEGATE.ColourctState==NO&&APPDELEGATE.Stateone==YES){
        UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:@"尺码选择" message:@"请选择颜色" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tishi show];
    }
    if(APPDELEGATE.Stateone==NO&&APPDELEGATE.ColourctState==YES){
        UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:@"尺码选择" message:@"请选择尺码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tishi show];
    }
    if(APPDELEGATE.ColourctState==YES&&APPDELEGATE.Stateone==YES){
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 650, [[UIScreen mainScreen]bounds].size.width, 200);
    }
                     completion:^(BOOL finished) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"sure" object:nil];
                     }];
        APPDELEGATE.ColourctState=NO;
        APPDELEGATE.Stateone=NO;
    }
    
   
}

- (IBAction)Add:(UIButton *)sender {
    self.i++;
    self.number.text=[NSString stringWithFormat:@"%d",self.i];
    APPDELEGATE.shopnumber=[NSString stringWithFormat:@"%d",self.i];
}

- (IBAction)Delect:(UIButton *)sender {
    int j=[self.number.text intValue];
    if(j>0){
    self.i--;
    self.number.text=[NSString stringWithFormat:@"%d",self.i];
    APPDELEGATE.shopnumber=[NSString stringWithFormat:@"%d",self.i];
    }
}

@end
