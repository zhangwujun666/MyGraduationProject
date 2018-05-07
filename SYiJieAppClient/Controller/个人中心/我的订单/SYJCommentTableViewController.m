//
//  SYJCommentTableViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/15.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCommentTableViewController.h"
#import "AppDelegate.h"
#import "SYJOKCommentView.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SYJThinkViewController.h"
#import "SYJCommentView.h"
@interface SYJCommentTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    SYJOKCommentView *OKView;
    SYJCommentView *headVc;
    int i;
    int j;
    int k;
    int n;
    int gesturetag;
    UIImageView *imgview;
    NSMutableArray *arr;
    UIImage *img;
    int  ii;
    int jj;
    int arrnumber;
    int d;
    NSMutableArray *imgarr;
    NSString *commentimagename;
    NSString *star;
    NSString *size;
    NSString *colour;
    NSDictionary *lastid;
    NSDictionary*  goodid;
    NSString *   goodsid;
    BOOL *buttonstatus;
    
    __weak IBOutlet UIActivityIndicatorView *loadClict;
}
@end

@implementation SYJCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetordergoodsid];
    imgarr=[NSMutableArray array];
    UITapGestureRecognizer *hand=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(YinChan)];
    hand.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:hand];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(niming) name:@"niming" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendHeaderImagee) name:@"comment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReturnButton) name:@"SYJCommentView" object:nil];
    arr=[NSMutableArray array];
    OKView=[[[NSBundle mainBundle]loadNibNamed:@"SYJOKCommentView" owner:self options:nil]objectAtIndex:0];
    OKView.frame=CGRectMake(0, [[UIScreen mainScreen]bounds].size.height-70, [[UIScreen mainScreen]bounds].size.width, 100);
    self.tabBarController.tabBar.hidden=YES;
    [self creathead];
    i=0;
    j=335;
    k=0;
    n=1;
    ii=0;
    jj=335;
    d=1;
    buttonstatus=NO;
   
    [self.navigationController.view addSubview:OKView];
}
-(void)niming{
    d++;
    if(d%2==0){
        [OKView.SelectButton setImage:[UIImage imageNamed:@"Nobabyselect.jpg"] forState:UIControlStateNormal];
    }
    else{
        [OKView.SelectButton setImage:[UIImage imageNamed:@"babyselect.jpg"] forState:UIControlStateNormal];
    }
}
- (IBAction)GoodsSoreButton:(UIButton *)sender {
    buttonstatus=YES;
    if(sender.tag==1){
        
        [self.goodstwo setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodsstress setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodsfore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodfin setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        star=@"1";
    }
    if(sender.tag==2){
        [self.goodstwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsstress setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodsfore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodfin setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        star=@"2";
    }
    if(sender.tag==3){
        [self.goodstwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsstress setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsfore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.goodfin setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        star=@"3";
    }
    if(sender.tag==4){
        [self.goodstwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsstress setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsfore setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodfin setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        star=@"4";
    }
    if(sender.tag==5){
        [self.goodstwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsstress setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodsfore setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.goodfin setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        star=@"5";
        
    }
}

- (IBAction)StoreSoreButton:(UIButton *)sender {
    
    if(sender.tag==11){
        
        [self.StoreTwo setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.StoreStree setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.Storefore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.Storefine setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        
    }
    if(sender.tag==22){
        [self.StoreTwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.StoreStree setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.Storefore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.Storefine setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
    }
    if(sender.tag==33){
        [self.StoreTwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.StoreStree setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.Storefore setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
        [self.Storefine setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
    }
    if(sender.tag==44){
        [self.StoreTwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.StoreStree setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.Storefore setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.Storefine setImage:[UIImage imageNamed:@"Noxing1"] forState:UIControlStateNormal];
    }
    if(sender.tag==55){
        [self.StoreTwo setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.StoreStree setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.Storefore setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [self.Storefine setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)SelectimgButton:(UIButton *)sender {
    if(i<=5){
        UIActionSheet *Sheet=[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"上传照片" otherButtonTitles: nil];
        [Sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self OpenCamera];
    }
}
-(void)OpenCamera{
    UIImagePickerController *IPC=[[UIImagePickerController alloc]init];
    IPC.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    IPC.delegate=self;
    [self presentViewController:IPC animated:YES completion:nil];//从下往上跳转至照片的页面
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    img=info[UIImagePickerControllerOriginalImage];
    [imgarr addObject:img];
    [self Showimage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//给图片和手势添加tag
-(void)Showimage{
    if (i<3) {
        imgview=[[UIImageView alloc]initWithFrame:CGRectMake(20+100*i, j, 90, 70)];
        
        [imgview setImage:img];
        imgview.tag=n;
        UITapGestureRecognizer *imagedelet=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTapEvent:)];
        
        [imgview addGestureRecognizer:imagedelet];
        imgview.userInteractionEnabled=YES;
        [arr addObject:imgview];
        [self.tableView addSubview:imgview];
        
    }
    else{
        imgview=[[UIImageView alloc]initWithFrame:CGRectMake(20+100*(i%3), j+80, 90, 70)];
        UITapGestureRecognizer *imagedelet=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTapEvent:)];
        
        [imgview addGestureRecognizer:imagedelet];
        imgview.userInteractionEnabled=YES;
        [self.tableView addSubview:imgview];
        
        [imgview setImage:img];
        imgview.tag=n;
        [arr addObject:imgview];
        [self.tableView addSubview:imgview];
    }
    i++;
    n++;
    arrnumber=(int)arr.count;
}//手势的添加到什么上，什么上德tag就是手势的tag
-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture {
    gesturetag=(int)gesture.view.tag;
    UIAlertView *tishi=[[UIAlertView alloc]initWithTitle:@"删除图片"message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    tishi.delegate=self;
    [tishi show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self delect];
        [self ReShow];
    }
}

-(void)delect{
    NSLog(@"%@",arr);
    for(int t=0;t<arrnumber;){
        UIImageView *imgviewwt=[arr objectAtIndex:t];
        [imgviewwt removeFromSuperview];
        NSInteger tag = imgviewwt.tag;
        
        if(gesturetag==tag){
            [arr removeObjectAtIndex:t];
            [imgarr removeObjectAtIndex:t];
            arrnumber--;
        }
        else{
            t++;
        }
    }
    i--;
}


-(void)ReShow{
    ii=0;
    for (int w=0; w<arr.count; w++) {
        
        UIImageView *imgvieww=[arr objectAtIndex:w];
        
        imgvieww.frame=CGRectMake(20+100*ii, jj, 90, 70);
        [self.tableView addSubview:imgvieww];
        
        ii++;
    }
    
}
-(void)requsetordergoodsid{
    
    {
        
        NSString *str=[NSString stringWithFormat:@"%@%@",krequertgoods,self.Commentgoodsid];
        AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
        [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功");
            NSDictionary *dicc=(NSDictionary *)responseObject;
            NSDictionary *dic=[dicc objectForKey:@"orderlist"];
            goodid=[dic objectForKey:@"order_goods_id"];
            NSLog(@"%@",[dic objectForKey:@"order_goodsimage"]);
            NSString *imageurl=[[NSString alloc]initWithFormat:@"%@%@",kscrollview,[dic objectForKey:@"order_goodsimage"]];
            NSURL *url=[NSURL URLWithString:imageurl];
            [self.GoodsImage setImageWithURL:url];
            self.GoodsNameLable.text=[dic objectForKey:@"order_goodsname"];
            NSString *price=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"order_goodsprice"]];
            self.goodsPricelable.text=price;
            size=[dic objectForKey:@"order_goodssize"];
            colour=[dic objectForKey:@"order_goodcolour"];
            [loadClict stopAnimating];
            loadClict.hidden=YES;
            self.Sizelable.text=[NSString stringWithFormat:@"颜色：%@",[dic objectForKey:@"order_goodssize"]];
            self.ColourLable.text=[NSString stringWithFormat:@"尺码：%@",[dic objectForKey:@"order_goodcolour"]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
}
-(void)requestbabyShow{
    NSString *str=[NSString stringWithFormat:@"%@%@",Kselectorder,goodid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicc=(NSDictionary *)responseObject;
        NSDictionary *dic=[dicc objectForKey:@"data"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return 120;
        }
        else{
            return 150;
        }
    }
    else{
        if(indexPath.row==0){
            if (i>3) {
                return 240;
            }
            else{
                return 120;
            }
        }
        else{
            return 100;
        }
    }
}
-(void)YinChan{
    [self.view endEditing:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    OKView.hidden=YES;
    headVc.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    OKView.hidden=NO;
    headVc.hidden=NO;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)sendHeaderImagee{
    
    if(buttonstatus==YES){
    [self requestaddcomment];
    [self requestiheadimg];
    
    [self requetschangstatustwo];
    
    UILabel *tishi=[[UILabel alloc]initWithFrame:CGRectMake(120, 400, 100, 30)];
    [tishi setText:@"评论成功"];
    tishi.backgroundColor=[UIColor blackColor];
    tishi.font=[UIFont systemFontOfSize:12];
    tishi.textAlignment=NSTextAlignmentCenter;
    tishi.textColor=[UIColor whiteColor];
    tishi.layer.cornerRadius=10;
    [tishi.layer setCornerRadius:20.0];
    [self.navigationController.view addSubview:tishi];
    
    SYJThinkViewController *think=[self.storyboard instantiateViewControllerWithIdentifier:@"finsh"];
    [self.navigationController pushViewController:think animated:YES];
    [UIView animateWithDuration:1.5 animations:^{
        tishi.alpha=0;
    }
                     completion:^(BOOL finished) {
                         [tishi removeFromSuperview];
                         
                     }];
    
}
    else{
        UIAlertView *NOsore=[[UIAlertView alloc]initWithTitle:nil message:@"您还未打分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [NOsore show];
    }
}

-(void)requetschangstatustwo{
    
    NSString *str=[NSString stringWithFormat:@"%@%@",kchangerstatutwo,self.Commentgoodsid];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"5555成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}
-(void)requestiheadimg{
    
    for (UIImage *obj in imgarr) {
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        
        NSString *url = [NSString stringWithFormat:kheadimage];
        
        NSDictionary *dict = @{@"userid":@(APPDELEGATE.user.userID)};
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript", nil];
        
        [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            UIImage *image = obj;
            NSString *filename = [NSString stringWithFormat:@"header.jpg"];
            NSString *name = [NSString stringWithFormat:@"%lu",APPDELEGATE.user.userID];
            
            NSData *imggdata =  UIImageJPEGRepresentation(image, 1);
            
            [formData appendPartWithFileData:imggdata name:name fileName:filename mimeType:@"image/png"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dic=(NSDictionary *)responseObject;
            NSDictionary *data=[dic objectForKey:@"data"];
            NSString *userid=[NSString stringWithFormat:@"%lu",APPDELEGATE.user.userID];
            NSDictionary *commentid=[data objectForKey:userid];
            
            NSLog(@"%@",commentid);
            commentimagename=[commentid objectForKey:@"savename"];
            [self requerstcommentimage];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"失败");
            
        }];
    }
    
}
-(void)requestaddcomment{
    NSNumber *userid=[NSNumber numberWithInteger:APPDELEGATE.user.userID];
    NSDictionary *dic=@{@"babycomment_content":self.CommentContentField.text,
                        @"babycomment_star":star,
                        @"babycomment_user_id":userid,
                        @"babycomment_size":size,
                        @"babycomment_colour":colour,
                        @"babycomment_goods_id":goodid};
    AFHTTPRequestOperationManager *mangerone=[AFHTTPRequestOperationManager manager];
    [mangerone POST:kaddcomment parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSLog(@"%@",dic);
        lastid=[dic objectForKey:@"lastId"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
-(void)requerstcommentimage{
    
    NSDictionary *dic=@{@"goodscommentimage_name":commentimagename,
                        @"t_goodscommentiamge_commentid":lastid};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger POST:kcommentimage parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}
-(void)ReturnButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creathead{
    headVc=[[[NSBundle mainBundle]loadNibNamed:@"SYJCommentView" owner:self options:nil]objectAtIndex:0];
    headVc.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 63);
    [self.tabBarController.view addSubview:headVc];
}
@end
