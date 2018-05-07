//
//  AppDelegate.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "AppDelegate.h"
#import "ScorllViewViewController.h"


@interface AppDelegate ()
{
    BMKLocationService *locService;//初始化一个全局的管理器对象
    BMKGeoCodeSearch *_geocodesearch;//搜索得出经纬度或者搜索反编码经纬度
}
@property (strong, nonatomic)ScorllViewViewController *scrollViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //授权友盟分享
    //[UMSocialData setAppKey:@"55d7ed8967e58e9cf10076a4"];
    
    //授权百度地图
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"6jK2dQafvkxNxoFOzZ9rmgZz"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self SetMain];
    
    [self startLocating];//开始定位
    
    //[NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    [self showWelcome];
    
    return YES;
}


- (void)showWelcome{
    UIImageView *splashScreen  = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *launchImageName = @"LaunchImage-700-568h";
    if ([[UIScreen mainScreen] bounds].size.height == 736) {
        launchImageName = @"LaunchImage-800-Portrait-736h";
    }else if ([[UIScreen mainScreen] bounds].size.height == 667){
        launchImageName = @"LaunchImage-800-667h";
    }else if ([[UIScreen mainScreen] bounds].size.height == 568){
        launchImageName = @"LaunchImage-700-568h";
    }else{
        launchImageName = @"LaunchImage-700";
    }
    splashScreen.image = [UIImage imageNamed:launchImageName];
    [self.window addSubview:splashScreen];
    
    [UIView animateWithDuration:1.0 animations:^{
        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
        splashScreen.layer.transform = transform;
        splashScreen.alpha = 0.0;
    } completion:^(BOOL finished) {
        [splashScreen removeFromSuperview];
    }];
}

//开始定位
-(void)startLocating{
    CLLocationManager *manager=[[CLLocationManager alloc] init];
    manager.delegate=self;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"设备上的定位服务没有启动。");
        return;
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [manager requestWhenInUseAuthorization];
    }else{
        //设置精度
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        //设置最小距离更新
        [BMKLocationService setLocationDistanceFilter:CLLocationDistanceMax];
        //初始化管理器对象
        locService=[[BMKLocationService alloc] init];
        locService.delegate=self;
        
        //开始定位
        [locService startUserLocationService];
    }
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.userCoordinate=userLocation.location.coordinate;
    NSLog(@"APPDELEGATE:精度%f,纬度%f",self.userCoordinate.latitude,self.userCoordinate.longitude);
    self.currentCoordinate=CLLocationCoordinate2DMake(self.userCoordinate.latitude, self.userCoordinate.longitude);
    [locService stopUserLocationService];
    
    //反编码之前进行代理和编码设置
    _geocodesearch=[[BMKGeoCodeSearch alloc] init];
    //设置代理
    _geocodesearch.delegate=self;
    //进行反编码
    [self showDetailOf:userLocation];
}

//反编码
-(void)showDetailOf:(BMKUserLocation *)userLocation{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption=[[BMKReverseGeoCodeOption alloc] init];
    
    reverseGeocodeSearchOption.reverseGeoPoint=userLocation.location.coordinate;
    BOOL flag=[_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        NSLog(@"反编码成功");
    }else{
        NSLog(@"反编码失败");
    }
}

//反编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error==0) {
        self.cityName=result.addressDetail.city;
        
        NSLog(@"反编码结果:%@",result);
        NSLog(@"address--%@",result.address);
        NSLog(@"province--%@",result.addressDetail.province);
        NSLog(@"city--%@",result.addressDetail.city);
        NSLog(@"district--%@",result.addressDetail.district);
        NSLog(@"streetName--%@",result.addressDetail.streetName);
        NSLog(@"streetNumber--%@",result.addressDetail.streetNumber);
    }
    
    //编码完成，销毁指针
    _geocodesearch.delegate=nil;
    locService.delegate=nil;
}

- (void)SetMain{
    
    self.allid=[NSMutableArray array];
    self.selectid=[NSMutableArray array];
    self.cartCalculateArray=[NSMutableArray array];
    self.pathArray=[NSMutableArray array];
    
    
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.window = [[UIWindow alloc]initWithFrame:rect];
    UIViewController *vc = [[UIViewController alloc] init];
    self.window.rootViewController = vc;
    
    
    //读取用户配置，判断当前是否已 经登录
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isLogin = [self.defaults valueForKey:@"isLogin"];
    
    //NSString *firstindex = [self.defaults valueForKey:@"firstindex"];
    
    if (isLogin != nil && [isLogin isEqualToString:@"1"]) {
        //已登录进入主页面
        //        UITabBarController
        //登入后把缓存中的数据读取出来
        self.user = [[SYJUser alloc]init];
        self.user.username = [self.defaults valueForKey:@"username"];
        self.user.telephone = [self.defaults valueForKey:@"telephone"];
        self.user.email = [self.defaults valueForKey:@"email"];
        self.user.headImage = [self.defaults valueForKey:@"headImage"];
        self.user.sex=[self.defaults valueForKey:@"user_sex"];
        self.user.user_brithday=[self.defaults valueForKey:@"brithday"] ;
        self.user.user_Constellation=[self.defaults valueForKey:@"constellation"];
        self.user.age=[[self.defaults valueForKey:@"age"]intValue];
        self.user.userID=[[self.defaults valueForKey:@"user_id"]integerValue] ;
        self.user.lovestate=[self.defaults valueForKey:@"lovestate"];
        self.user.home=[self.defaults valueForKey:@"user_address"];
        self.user.email=[self.defaults valueForKey:@"email"];
        SYJMainTabViewController *tabs = [[SYJMainTabViewController alloc]init];
        self.window.rootViewController = tabs;   
    }
    else{
//        if([firstindex isEqualToString:@"1"]){
            SYJMainTabViewController *tabs = [[SYJMainTabViewController alloc]init];
            self.window.rootViewController = tabs;
//        }
        //else{
//            //未登录进入主页面
//            self.scrollViewController=[[ScorllViewViewController alloc] init];
//            //[self.window addSubview:self.scrollViewController.view];
//            
//            __weak AppDelegate *weakSelf=self;
//            self.scrollViewController.didSelectedEnter=^(){
//                //移除引导页面
//                [weakSelf.scrollViewController.view removeFromSuperview];
//                weakSelf.scrollViewController=nil;
//                
//                //设置登录标志
//                //[weakSelf.defaults setValue:@"1" forKey:@"isLogin"];
//                [weakSelf.defaults setValue:@"1" forKey:@"firstindex"];
//                
//                //UITabBarController
//                SYJMainTabViewController *tabs = [[SYJMainTabViewController alloc]init];
//                weakSelf.window.rootViewController = tabs;
//            };
//        }
    }
    
    [self.window makeKeyAndVisible];
    //沙盒路径*
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
