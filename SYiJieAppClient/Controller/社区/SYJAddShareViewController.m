//
//  SYJAddShareViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/20.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJAddShareViewController.h"
#import "SYJUser.h"
#import "AppDelegate.h"
#import "UIView+Extension.h"
#import "DSEmotionTextView.h"
#import "DSComposeToolbar.h"
#import "DSComposePhotosView.h"
#import "JKImagePickerController.h"
#import "DSEmotionKeyboard.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "SYJUser.h"
#import "SYJCommunityViewController.h"
#import "SYJCommentViewController.h"
#import "SYJSelectShareGoods.h"

#define SourceCompose @"compose"
#define SourceComment @"comment"
#define SourceCommenttow @"commenttow"
@interface SYJAddShareViewController ()<UITextViewDelegate,DSComposeToolbarDelegate,JKImagePickerControllerDelegate,UINavigationControllerDelegate , JKImagePickerControllerDelegate,presentToImageSelectDelegate>
//是否正在切换键盘
@property (nonatomic ,assign, getter=isChangingKeyboard) BOOL ChangingKeyboard;
@property (nonatomic , weak) DSComposeToolbar *toolbar;
@property (nonatomic , weak) DSEmotionTextView *textView;
@property (nonatomic , weak) DSComposePhotosView *photosView;
@property (nonatomic , weak) DSEmotionKeyboard *keyboard;
@property (nonatomic , copy) NSString *titleText;
@end

@implementation SYJAddShareViewController
#pragma mark - 初始化

- (DSEmotionKeyboard *)keyboard {
    
    if (_keyboard==nil) {
        self.keyboard = [DSEmotionKeyboard keyboard];
        self.keyboard.width = kAllWidth;
        self.keyboard.height = 216;
    }
    
    return _keyboard;
}

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = YES;
    [super viewDidLoad];
    //设置导航标题
    [self setupNavigationItem];
    //添加输入控件
    [self setupTextView];
    /*
    UIView * viewBackground = [[UIView alloc] init];
    viewBackground.backgroundColor = [[UIColor alloc]initWithRed:225/255.0 green:225.0/255 blue:225.0/255 alpha:1.0];
    [viewBackground setFrame:CGRectMake(0, 235, 320, 410)];
//    UIView * viewGoods = [[UIView alloc] init];
//    viewGoods.backgroundColor = [UIColor redColor];//[[UIColor alloc]initWithRed:255.0/255.0 green:255.0/255 blue:255.0/255 alpha:1.0];
//    [viewGoods setFrame:CGRectMake(0, 0, 320, 35)];
    
    //SYJMiaoShaHeadView * miaoshaHead = ;
    SYJSelectShareGoods * selectsharegoods = [[[NSBundle mainBundle] loadNibNamed:@"SYJSelectShareGoods" owner:self options:nil]objectAtIndex:0];
    [viewBackground addSubview:selectsharegoods];
    [self.view addSubview:viewBackground];
    
    */
    
    //UILabel *label = (UILabel *)self.navigationItem.titleView;
    if (![self.titleText isEqualToString:@"评论"]) {
        //添加工具条
        [self setupToolbar];
        
        //添加显示图片相册控件
        [self setupPhotosView];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:DSEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:DSEmotionDidDeletedNotification object:nil];
    
    
    
}
#pragma mark -设置导航标题
- (void)setupNavigationItem {
    
    NSString *name = APPDELEGATE.user.username;
//    self.source = @"compose";
    if (name) {
        NSString *prefix = @"";
        if ([self.source isEqual:SourceCompose]){
            prefix = @"分享";
        }
        if ([self.source isEqual:SourceComment]){
            prefix = @"评论";
        }
        if ([self.source isEqual:SourceCommenttow]){
            prefix = @"评论";
        }
        self.titleText = prefix;
        NSString *text = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[text rangeOfString:name]];
        
        
        //创建label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.attributedText = string;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.width = 100.0;
        titleLabel.height = 44;
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = @"未登入";
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
}
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)send {
    NSLog(@"send button clicked!");
    //发分享是调用
    if ([self.source isEqual:SourceCompose]){
        [self sendShareCompose];
    }
    //发评论是调用
    if ([self.source isEqual:SourceComment]){
        [self sendShareComment];
    }
    //二级评论调用
    if ([self.source isEqual:SourceCommenttow]) {
        [self sendShareCommentTow];
    }

}

#pragma mark - 发送分享，上传图片到服务器
/**
 * 发送分享，上传图片到服务器
 */
-(void)sendShareCompose{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@Share/addshare",SYJHTTP];
    NSDictionary *dict = @{
                           @"share_user_id":@(APPDELEGATE.user.userID),
                           @"share_user_name":APPDELEGATE.user.username,
                           @"share_user_image":APPDELEGATE.user.headImage,
                           @"share_content":self.textView.realText,
                           @"share_imagenumber":@([self.photosView.selectedPhotos count]),
                           @"share_address":@"吴中区",
                           @"share_good_id":self.goodsId,
                           @"share_goodsname":self.goodsName,
                           };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0 ;i < [self.photosView.selectedPhotos count]; i++) {
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            //时间转时间戳的方法:
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            NSLog(@"timeSp:%@",timeSp); //时间戳的值
            NSString *filename = [NSString stringWithFormat:@"header.jpg"];
            NSString *name = [NSString stringWithFormat:@"%@%d%lu",timeSp,i,APPDELEGATE.user.userID];
            NSData *d =  UIImageJPEGRepresentation([self.photosView.selectedPhotos objectAtIndex:i], 0.1);
            [formData appendPartWithFileData:d name:name fileName:filename mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //发送成功
        NSLog(@"%@",responseObject);
        //跳转返回
        UIStoryboard *storyBoard = self.storyboard;
        SYJCommunityViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"community"];
        [vcc getDataSource];
        [self.navigationController pushViewController:vcc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"no");
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 发送评论到服务器
-(void)sendShareComment{
    NSString *urlPath = [NSString stringWithFormat:@"%@Share/addcomment",SYJHTTP];
    NSDictionary *dict = @{
                           @"sharecomment_content":self.textView.realText,
                           @"sharecomment_share_id":self.shareId,
                           @"sharecomment_name":APPDELEGATE.user.username,
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        NSArray * result = dicdescription[@"data"];
        if (result != nil) {
            //发送成功
            NSLog(@"%@",responseObject);
            //跳转返回
//            UIStoryboard *storyBoard = self.storyboard;
//            SYJCommentViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"comment"];
//            vcc.shareId = self.shareId;
//            [vcc setUpInit];
//            [self.navigationController pushViewController:vcc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYJCommentViewControllerNC" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
}


#pragma mark - 发送二级评论到服务器
-(void)sendShareCommentTow{
    NSString *urlPath = [NSString stringWithFormat:@"%@Share/addcommenttow",SYJHTTP];
    NSDictionary *dict = @{
                           @"sharecommenttow_content":self.textView.realText,
                           @"sharecommenttow_sharecomment_id":self.commentId,
                           @"sharecommenttow_name":APPDELEGATE.user.username,
                           @"sharecommenttow_toname":self.commentTowToName,
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        NSArray * result = dicdescription[@"data"];
        if (result != nil) {
            //发送成功
            NSLog(@"%@",responseObject);
//            //跳转返回
//            UIStoryboard *storyBoard = self.storyboard;
//            SYJCommentViewController *vcc= [storyBoard instantiateViewControllerWithIdentifier:@"comment"];
//            vcc.shareId = self.shareId;
//            [vcc setUpInit];
//            [self.navigationController pushViewController:vcc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYJCommentViewControllerNC" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
}

#pragma mark -添加输入控件
- (void)setupTextView {
    
    // 1.创建输入控件
    DSEmotionTextView *textView = [[DSEmotionTextView alloc] init];
    
    textView.alwaysBounceVertical = YES ;//垂直方向上有弹簧效果
    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 2.设置提醒文字
    textView.placeholder = @"发布新Share...(120字以内)";
    
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

// 添加工具条
- (void)setupToolbar {
    
    DSComposeToolbar *toolbar = [[DSComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.delegate = self;
    self.toolbar = toolbar;
    
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}


// 添加显示图片的相册控件
- (void)setupPhotosView {
    
    DSComposePhotosView *photosView = [[DSComposePhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    //photosView.backgroundColor = [UIColor redColor];
    photosView.y = 70;
    //[photosView.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    photosView.addButton.hidden = NO;
    photosView.delegate = self;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
    
    //实例化下面添加数据的数据源，并刷新UICollectionView
    //self.photosView.assetsArray = [[NSMutableArray alloc] init];
    //JKAssets *asset = [[JKAssets alloc] init];
    //UIImage *image = [UIImage imageNamed:@"compose_pic_add_highlighted"];
    //asset.photo = [UIImage imageNamed:@"compose_pic_add_highlighted"];
    //[self.photosView.assetsArray addObject:asset];
    
    [self.photosView.collectionView reloadData];
}

- (void)presentToImageViewCotroller{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    NSLog(@"button clicked");
}

//- (void)addButtonClicked {
//    
//    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.showsCancelButton = YES;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.minimumNumberOfSelection = 1;
//    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:NULL];
//    NSLog(@"button clicked");
//}





-(void)showProgress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.photosView.assetsArray = [NSMutableArray arrayWithArray:assets];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.photosView.assetsArray count] > 0){
            
            self.photosView.addButton.hidden = NO;
        }
        [self.photosView.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


/**
 *  view显示完毕的时候再弹出键盘，避免显示控制器view的时候会卡住
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（叫出键盘）
    [self.textView becomeFirstResponder];
}



#pragma mark - 键盘处理
/**
 *  键盘即将隐藏：工具条（toolbar）随着键盘移动
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    //需要判断是否自定义切换的键盘
    if (self.isChangingKeyboard) {
        self.ChangingKeyboard = NO;
        return;
    }
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;//回复之前的位置
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}


#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - SWComposeToolbarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeTool:(DSComposeToolbar *)toolbar didClickedButton:(DSComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case DSComposeToolbarButtonTypeCamera: // 照相机
            [self openCamera];
            break;
            
        case DSComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case DSComposeToolbarButtonTypeEmotion: // 表情
            [self openEmotion];
            break;
            
        default:
            break;
    }
}

/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openAlbum
{
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

/**
 *  打开表情
 */
- (void)openEmotion
{
    // 正在切换键盘
    self.ChangingKeyboard = YES;
    
    if (self.textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
        self.textView.inputView = nil;
        //self.textView.keyboardType = ;
        // 显示表情图片
        self.toolbar.showEmotionButton = YES;
    } else { // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        //self.textView.inputView = self.keyboard;
        
        //NSLog(@"%@",self.keyboard.description);
        // 不显示表情图片
        //self.toolbar.showEmotionButton = NO;
    }
    
    // 关闭键盘
    [self.textView resignFirstResponder];
    // 关闭键盘只后，changKeyboard 为no
    self.ChangingKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textView becomeFirstResponder];
    });
    
}


/**
 *  监听文字该表
 *
 *  @param textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;;
    
}

/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    DSEmotion *emotion = note.userInfo[DSSelectedEmotion];
    
    // 1.拼接表情
    [self.textView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.textView];
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.textView deleteBackward];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
