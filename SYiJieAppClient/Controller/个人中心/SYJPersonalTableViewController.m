//
//  SYJPersonalTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//


#import "SYJPersonalTableViewController.h"
#import "AppDelegate.h"
#import "SYJPersondataTableViewController.h"
#import "AFNetworking.h"
#import "SYJOrdderTableViewController.h"
#import "SYJSheZhiTableViewController.h"
#import "SYJaddressmangerTableViewController.h"
#import "SYJLoginViewController.h"
#import "SYJCommunityViewController.h"
#import "SYJShopdetailTableViewController.h"
#import "SYJMainTabViewController.h"
#import "SYJCollectTableViewController.h"
#import "SYJSheZhiTableViewController.h"
@interface SYJPersonalTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage *imgg ;
    NSDictionary *useid;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *usersexLable;
@property (weak, nonatomic) IBOutlet UILabel *userarea;
@property (weak, nonatomic) IBOutlet UILabel *useragelable;
@property (weak, nonatomic) IBOutlet UIButton *headimage;

@end

@implementation SYJPersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationController.navigationBar.topItem.leftBarButtonItem=backItem;
    
    //self.tableView.separatorStyle=NO;
    [self.tableView  reloadData];
    [self headimagee];
    //   self.tabBarController.tabBar.hidden=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.navigationController.navigationBar.hidden=YES;
    self.tableView.scrollEnabled=YES;
    self.tableView.tableFooterView=[[UIView alloc]init];
}

-(void)headimagee{
    self.headerImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.headerImageView.image=[UIImage imageNamed:@"header.jpg"];
    self.headerImageView.layer.cornerRadius=self.headerImageView.frame.size.width/2;
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
}

- (IBAction)SheZhi:(UIButton *)sender {
    SYJSheZhiTableViewController *SheZhi=[self.storyboard instantiateViewControllerWithIdentifier:@"shezhi"];
    [self.navigationController pushViewController:SheZhi animated:YES];
    
}

- (IBAction)ShowHeadImage:(id)sender {
    
    
    UIActionSheet *userimage=[[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [userimage showInView:self.view];
}

-(void)openAlbum{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    ipc.delegate=self;
    ipc.allowsEditing = NO;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//表明当前图片的来源为相册
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)pickImageFromCamera{
    UIImagePickerController *camera=[[UIImagePickerController alloc]init];
    camera.delegate = self;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    camera.allowsEditing=YES;
    [self presentViewController:camera animated:YES completion:nil];
}
-(void)savaimage:(UIImage *)temimage withName:(NSString *)imagename{
    NSData *data= UIImagePNGRepresentation(temimage);//外部传入UImage
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);//获取所有的文件
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *fullpathtofile=[documentsDirectory stringByAppendingPathComponent:imagename];
    [data writeToFile:fullpathtofile  atomically:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self openAlbum];
        
    }
    else if(buttonIndex==1){
        [self pickImageFromCamera];
    }
}
#pragma mark 相册的调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//   
  imgg = info[UIImagePickerControllerOriginalImage]; //获取图像数据
//  
//
//
//    
//    //上传头像到服务器
//    
//
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(imgg, nil, nil, nil);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        self.headerImageView.image = imgg;  //显示头像
       //[self sendHeaderImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)sendHeaderImage{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    NSString *url = [NSString stringWithFormat:kheadimage];
    
    NSDictionary *dict = @{@"userid":@(APPDELEGATE.user.userID)};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript", nil];
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage *image = self.headerImageView.image;
        NSString *filename = [NSString stringWithFormat:@"header.jpg"];
        NSString *name = [NSString stringWithFormat:@"%lu",APPDELEGATE.user.userID];
        
        NSData *d =  UIImageJPEGRepresentation(image, 1);
        
        [formData appendPartWithFileData:d name:name fileName:filename mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSDictionary *data=[dic objectForKey:@"data"];
        useid=[data objectForKey:@"11"];
        [self updatathinkphp];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"no");
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark个人中心个人资料显示
/**
 * 个人中心个人资料显示
 */
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.usernameLable.text=APPDELEGATE.user.username;
    self.usersexLable.text=APPDELEGATE.user.sex;
    self.userarea.text=APPDELEGATE.user.home;
    NSString *age=[NSString stringWithFormat:@"%d岁",APPDELEGATE.user.age];
    self.useragelable.text=age;
    self.tabBarController.tabBar.hidden=NO;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url=[NSString stringWithFormat:@"%@%@",kheader,APPDELEGATE.user.headImage];
        NSURL *path=[NSURL URLWithString:url];
        
        NSData *data=[NSData dataWithContentsOfURL:path];
        UIImage *img=[UIImage imageWithData:data];
        if(imgg==nil){
            [self.userImage setImage:img];
        }
        else{
            self.userImage.image=[UIImage imageNamed:@"UMS_User_profile_default"];
        }
    });
}

#pragma mark 判断跳转方向
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[APPDELEGATE.defaults valueForKey:@"isLogin"] isEqualToString:@"1"] ){
        if(indexPath.section==0){
            if(indexPath.row==0){
                NSLog(@"No");
            }
            else{
                SYJPersonalTableViewController *person=[self.storyboard instantiateViewControllerWithIdentifier:@"userdata"];
                [self.navigationController pushViewController:person animated:YES];
            }
            
        }
        else if (indexPath.section==1){
            if(indexPath.row==0){
                SYJOrdderTableViewController *order=[self.storyboard instantiateViewControllerWithIdentifier:@"order"];
                [self.navigationController pushViewController:order animated:YES];
            }
            else if (indexPath.row==1){
                SYJaddressmangerTableViewController *adress=[self.storyboard instantiateViewControllerWithIdentifier:@"address"];
                [self.navigationController pushViewController:adress animated:YES];
            }
            else{
                SYJCollectTableViewController *CollectVc=[self.storyboard instantiateViewControllerWithIdentifier:@"collect"];
                [self.navigationController pushViewController:CollectVc animated:YES];
            }
            
        }
        else if (indexPath.section==2){
            if(indexPath.row==0){

                self.tabBarController.selectedIndex = 3;
            }
           
            
        }
        else{
            SYJSheZhiTableViewController *shezhi=[self.storyboard instantiateViewControllerWithIdentifier:@"shezhi"];
            [self.navigationController pushViewController:shezhi animated:YES];
        }
       
    }
    else{
        SYJLoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"tijiao"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==4){
        return 40;
    }
    else if (section==0){
        return 0;
    }
    else{
        return 15;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
    
}

-(void)updatathinkphp{
    NSString *str=[NSString stringWithFormat:@"%@%lu",kheadimgupdat,APPDELEGATE.user.userID];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    NSDictionary *info=@{@"user_image":[useid objectForKey:@"savename"]};
    
    [manger POST:str parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
@end