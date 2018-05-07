//
//  SYJShareRepeat.m
//  SYiJieAppClient
//
//  Created by administrator on 15/9/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJShareRepeat.h"
#import "AppDelegate.h"

@implementation SYJShareRepeat
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的标题
    
    //设置用户头像
    [self.headerImageView setImage:self.shareCell.shareImage.image];
    //设置用户昵称
    self.nameLabel.text=self.shareCell.shareName.text;
    //设置用户分享的内容
    self.descLabel.text=self.shareCell.shareContent.text;
    //给textView设置代理
    self.shareRepeatTextView.delegate=self;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.shareRepeatTextView.text=@"";
    return YES;
}

//取消编辑
- (IBAction)cancleClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//提交编辑
- (IBAction)certenClicked:(UIButton *)sender {
    //user的信息
    NSLog(@"userId:%ld,userName:%@,userImage:%@",APPDELEGATE.user.userID,APPDELEGATE.user.username,APPDELEGATE.user.headImage);
    //转发的信息
    NSLog(@"share_content:%@",self.shareCell.shareContent.text);
    //自己编写的信息
    NSLog(@"转发时自己的心情感受:%@",self.shareRepeatTextView.text);
    //转发时的shareId
    NSLog(@"原作的shareId:%d",self.shareId);
    

    NSString *path=[NSString stringWithFormat:@"%@Share/repeat",SYJHTTP];

    NSDictionary *parameter=@{
                              @"share_user_id":@(APPDELEGATE.user.userID),
                              @"share_user_name":APPDELEGATE.user.username,
                              @"share_user_image":APPDELEGATE.user.headImage,
                              @"share_content":self.shareCell.shareContent.text,
                              @"share_image":@"",
                              @"share_like":@(0),
                              @"share_repeat_content":self.shareRepeatTextView.text,
                              @"shareId":@(self.shareId)
                              };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"转发成功!");
        }else{
            NSLog(@"获取网络数据失败，请重试。");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题，请检查网络连接。");
    }];
}

@end
