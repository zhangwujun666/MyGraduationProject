//
//  HTTPDefine.h
//  MyShopAPP
//
//  Created by administrator on 15/7/16.
//  Copyright (c) 2015年 韦忠添. All rights reserved.
//

#ifndef MyShopAPP_HTTPDefine_h
#define MyShopAPP_HTTPDefine_h

//全局头文件的定义
#import "AFNetworking.h"
#import "SYJUser.h"
#import "SYJMainTabViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"
#import "NSString+Extension.h"
#import "UIViewController+Example.h"
#import "SYJOrder.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"


#import "MJRefreshNormalHeader.h"
#import "MJRefresh.h"
#import "MJRefreshConst.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+MJExtension.h"


//接口地址定义
#define SYJHTTP @"http://localhost:8888/SYiJieAppServicer/index.php/home/"
#define SYJHTTPHOME @"http://localhost:8888/SYiJieAppServicer/home/images/home/"
#define SYJHTTPIMG @"http://localhost:8888/SYiJieAppServicer/home/images/"
#define korderimage @"http://localhost:8888/SYiJieAppServicer/home/images/"
#define SYJHTTPSHOPIMG @"http://localhost:8888/SYiJieAppServicer/home/images/shopimg/"
#define SYJHTTPCLOTHES @"http://localhost:8888/SYiJieAppServicer/home/images/clothes/"
#define SYJHTTPGOODIMG @"http://localhost:8888/SYiJieAppServicer/home/images/goodimg/"
#define SYJHTTPUSER @"http://localhost:8888/SYiJieAppServicer/home/images/"
#define SYJHTTPSHARE @"http://localhost:8888/SYiJieAppServicer/home/images/share/"
#define SYJHTTPCOMMENT @"http://localhost:8888/SYiJieAppServicer/home/images/comment/"

#define klogin @"http://localhost:8888/SYiJieAppServicer/index.php/home/User/login"
#define kheader @"http://localhost:8888/SYiJieAppServicer/home/images/"
#define kRegister @"http://localhost:8888/SYiJieAppServicer/index.php/home/User/register"
#define kchangedata @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/change?id="
#define korderr @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/getOrderr?"//

#define korder @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/order?id="
#define korderyp @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/getOrder?userId="
#define kheadimage @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/upload"
#define kbabytail @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/detaill?id="
#define kscrollview @"http://localhost:8888/SYiJieAppServicer/home/images/clothes/baby2/"
#define  KPersondetail @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/babydetail?id="
#define  kaddcar @"http://localhost:8888/SYiJieAppServicer/index.php/home/Car/addcar"
#define  kaddress @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/address?id="
#define kCar @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/getCar?userId="
//#define commentPath @"http://localhost:8888/SYJ/index.php/home/Share/"
#define Kdelecadress @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/delectaddress?"
#define kaddressa @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/addadress"
#define Kupdata @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/updataSavedress?id="
#define kheadimgupdat @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/updataheandimg?id="
#define kbabycomment @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/commentbaby?id="
#define kcommentimage @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/commentimage"
#define kaddcomment @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/addBabyComment"
#define Kselectorder @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/orderseselect?id="
#define kchangestatue @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/changeStatus?orderId="
#define kdetailcommentimage @"http://localhost:8888/SYiJieAppServicer/home/images/"
#define kshopdetail @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/goodsubmite?"
#define krequertgoods  @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/ordergoods?id="
#define kchangerstatutwo @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/changeStatustwo?orderId="
#define Ksumbitorder @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/getAllData"
#define kGetAddress @"http://localhost:8888/SYiJieAppServicer/index.php/home/Car/getAddressDetail?userId="
#define kaddorder @"http://localhost:8888/SYiJieAppServicer/index.php/home/User/addOrder"

#define kselcetorderdetail @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/selectorder?id="
#define ksubmite @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/submit?"
#define Kcollect @"http://localhost:8888/SYiJieAppServicer/index.php/home/person/collection?id="
//字体、颜色
#define kupmr @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/addressmangerr"
#define judge @"http://localhost:8888/SYiJieAppServicer/index.php/home/User/judgeregister"
#define delectcargoodis @"http://localhost:8888/SYiJieAppServicer/index.php/home/babydetail/delectcarid?cargoodsid="

#define registnext [UIColor colorWithNext:191/255 green:191.0/255 blue:191.0/255 alpha:1]
#define titleFont [UIFont systemFontOfSize:15]//所有标题的字体大小
#define textFont [UIFont systemFontOfSize:12]//所有正文的字体大小
#define navigationViewBgcolor [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1]//导航栏的背景色
#define lineColor [UIColor colorWithRed:214.0/255 green:214.0/255 blue:214.0/255 alpha:1.0]//导航栏下边框的颜色
#define btnColor [UIColor colorWithRed:118.0/255 green:118.0/255 blue:118.0/255 alpha:1.0]//搜素按钮的背景颜色
#define cellSelectedColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]//cell选中时的颜色
#define cellTextColor [UIColor colorWithRed:48.0/255 green:48.0/255 blue:48.0/255 alpha:1.0]//文字的颜色
#define tableViewColor [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0]
#define collectionViewHeaderTextColor [UIColor colorWithRed:118.0/255 green:118.0/255 blue:118.0/255 alpha:1.0]//collectionView的头中的字体颜色
    //颜色
#define pink [UIColor colorWithRed:255.0/255 green:192.0/255 blue:203.0/255 alpha:1.0]
#define Green [UIColor colorWithRed:0.0/255 green:201.0/255 blue:87.0/255 alpha:1.0]

#define homeViewHead1 [UIColor colorWithRed:255.0/255 green:105.0/255 blue:126.0/255 alpha:1.0]//collectionView的头中的字体颜色
#define homeViewHead [UIColor colorWithRed:254.0/255 green:101.0/255 blue:123.0/255 alpha:1.0]//collectionView的头中的字体颜色
#define titleColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]
//tag的增量
#define storeTag 100//店铺tag的增量
#define goodTag 2000//商品tag的增量
#define commentTag 5000//评论cell的tag值

// 表情选择通知
#define DSEmotionDidSelectedNotification @"EmotionDidSelectedNotification"
#define DSEmotionDidDeletedNotification @"EmotionDidDeletedNotification"
// 表情选择通知
#define DSSelectedEmotion @"SelectEmotionKey"
// 表情的最大列数
#define DSEmotionMaxCols 7
// 表情的最大行数
#define DSEmotionMaxRows 3
// 每页最多显示多少个表情
#define DSEmotionMaxCountPerPage (DSEmotionMaxRows * DSEmotionMaxCols - 1)
//屏幕宽度
#define DSScreenWidth [UIScreen mainScreen].bounds.size.width

#define kAllWidth [[UIScreen mainScreen] bounds].size.width

#define kAllHeight [[UIScreen mainScreen] bounds].size.height


#define APPDELEGATE [[UIApplication sharedApplication]delegate]
#endif
