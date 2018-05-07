//
//  SYJSheZhiTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/13.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJSheZhiTableViewController.h"
#import "SYJRegisterViewController.h"
#import "SYJLoginViewController.h"
#import "AppDelegate.h"
#import "UMSocial.h"
@interface SYJSheZhiTableViewController ()<UMSocialUIDelegate>
{
    int size;
    UIAlertView *uialerr;
}
@end

@implementation SYJSheZhiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.Exit.layer.cornerRadius=8;
    [self huangcun];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0&&indexPath.row==1){
        
            UIAlertView *uialer=[[UIAlertView alloc]initWithTitle:nil message:@"已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [uialer show];
        
    }
    else if (indexPath.section==0&&indexPath.row==2){
        uialerr=[[UIAlertView alloc]initWithTitle:nil message:@"是否清除缓存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        uialerr.tag=1;
        [uialerr show];
        
    }
    else if (indexPath.section==1&&indexPath.row==1){
        [self Um];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 0&&alertView.tag==1)
    {
        [self qingchu];
        self.huancun.text=[NSString stringWithFormat:@"0KB"];
    }
}
-(void)qingchu{
    dispatch_async(
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%lu",[files count]);
    
        for (NSString *p in files) {
            
            NSError *error;
            
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            NSDictionary * dict=[[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
            NSLog(@"bb%@",[dict objectForKey:NSFileSize]);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                
            }
            
        }
    });
}
-(void)huangcun{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];//缓存文件数量
                       NSLog(@"files :%lu",[files count]);
                       
                       for (NSString *p in files) {//遍历每一个文件
                           
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           NSDictionary * dict=[[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
                           int hc=[[dict objectForKey:NSFileSize]intValue];
                           NSLog(@"%d",hc);
                          
                           size=size+hc;
                       }
                       NSLog(@"aa%d",size);
                       if(1048576>size&&size>1024){
                           double hc1=size/1024;
                           self.huancun.text=[NSString stringWithFormat:@"%.2lfKB",hc1];
                       }
                       else if (size>1048576){
                           double hc1=size/1048576;
                           self.huancun.text=[NSString stringWithFormat:@"%.2lfM",hc1];
                       }
                       else{
                           double hc1=size;
                           self.huancun.text=[NSString stringWithFormat:@"%.2lfKB",hc1];
                           
                       }
                   });
}

- (IBAction)TuiChuButton:(UIButton *)sender {
    SYJLoginViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"tijiao"];
    
    //清除登录的数据
    [self logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPersonImage" object:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)logOut{
    [APPDELEGATE.defaults setObject:@"0" forKey:@"isLogin"];
    APPDELEGATE.user.email = nil;
    APPDELEGATE.user = nil;
    [APPDELEGATE.defaults setObject:nil forKey:@"username"];
    [APPDELEGATE.defaults setObject:nil forKey:@"headImage"];
    [APPDELEGATE.defaults setObject:nil forKey:@"user_sex"];
    [APPDELEGATE.defaults setObject:nil forKey:@"constellation"];
    [APPDELEGATE.defaults setObject:nil forKey:@"user_id"];
    [APPDELEGATE.defaults setObject:nil forKey:@"brithday"];
    [APPDELEGATE.defaults setObject:nil forKey:@"lovestate"];
    [APPDELEGATE.defaults setObject:nil forKey:@"adress"];
    [APPDELEGATE.defaults setObject:nil forKey:@"user_age"];
    [APPDELEGATE.defaults setObject:nil forKey:@"age"];
}

-(void)Um{
    NSString *str=[NSString stringWithFormat:@"尚衣街app下载地址http://10.204.1.31:8887/SYiJieAppServicer/index.php/home/babydetail/detaill?id=2"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55d7ed8967e58e9cf10076a4"
                                      shareText:str
                                     shareImage:[UIImage imageNamed:@"back1.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToQzone,nil]
                                       delegate:self];
}
@end
