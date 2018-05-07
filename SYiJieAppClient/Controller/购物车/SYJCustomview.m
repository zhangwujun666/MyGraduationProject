//
//  SYJCustomview.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCustomview.h"
#import "AppDelegate.h"
#import "SYJGood.h"
#import "SYJStore.h"
@implementation SYJCustomview
int i=1;
-(void)awakeFromNib{
    self.GoPlayMoney.layer.cornerRadius=8;
}
- (IBAction)paymoneyButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"return" object:nil];

}

- (IBAction)allselectButton:(UIButton *)sender {
    i++;
    APPDELEGATE.allprice=0;
    if(i%2==0){
        [sender setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allselect" object:nil];
    }else{
        [sender setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Noallselect" object:nil];
    }
}
@end
