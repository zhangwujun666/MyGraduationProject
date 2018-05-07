//
//  AppDelegate.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapManager* mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SYJUser * user;
@property  NSUserDefaults *defaults;
@property(nonatomic)   int allprice;
@property(nonatomic)   int allprice1;
@property(nonatomic)BOOL Carstatus;
@property(assign,nonatomic)BOOL ColourctState;
@property(assign,nonatomic)BOOL Stateone;
@property(assign,nonatomic)BOOL outrightplay;
@property(assign,nonatomic)BOOL communityjud;
@property(assign,nonatomic)BOOL isaddress;//判断是否有地址
@property(assign,nonatomic)BOOL State1;//判断用户是否有勾选宝贝，没有的话，给他提示
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate;//声明用户当前的位置
@property(nonatomic, assign)CLLocationCoordinate2D currentCoordinate;//当前定位得到的经纬度
@property(nonatomic, copy)NSString *cityName;//城市名称

@property(assign,nonatomic)BOOL niming;
@property (strong,nonatomic) NSString *shopnumber;
@property (strong,nonatomic) NSString *orderprice;
@property (strong,nonatomic)NSMutableArray *allid;
@property (strong,nonatomic) NSMutableArray *selectid;
@property (strong,nonatomic) NSMutableArray *cartCalculateArray;//存储购物车中的商品
@property  (strong,nonatomic)NSMutableArray *cartstorearr;
@property (strong,nonatomic) NSMutableArray *pathArray;//路径

@property (strong,nonatomic) NSMutableArray *pathrowArray;
@property (strong,nonatomic) NSIndexPath *xiaorderpath;
@property(assign,nonatomic) BOOL Loginstatus;
@property (copy,nonatomic) NSString *searchKey;//搜索的关键字
@property (copy,nonatomic) NSString *areaName;//保存选择的城市
@property (assign,nonatomic) int  Carnumber;//购物数量
@property(assign,nonatomic) int CollectStoreid;
@property(assign,nonatomic) BOOL SW;//默认地址的判断
@end