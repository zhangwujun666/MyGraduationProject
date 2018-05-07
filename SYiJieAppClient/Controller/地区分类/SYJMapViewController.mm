//
//  SYJMapViewController.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/12.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJMapViewController.h"
#import <BaiduMapAPI/BMapKit.h> //引入百度地图所有的头文件
#import "SYJNavigationView.h" //自定义导航条
#import <CoreLocation/CoreLocation.h>//导入定位
#import "SYJAnnotation.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SYJCustomPickerView.h"
#import "UIImage+Rotate.h"
#import "AppDelegate.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface SYJMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,SearchDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BMKMapView *custMapView;
    SYJNavigationView *naviagtionView;//声明自定义导航的view
    UISearchBar *bar;//声明自定义的searchBar
    BMKLocationService *_locService;//声明定位服务
    CLLocationManager *_locManager;//设置定位的管理器
    SYJAnnotation *currentAnnotation;//当前定位的点
    CLLocationCoordinate2D coordinate1;//店铺的坐标
    CLLocationCoordinate2D currentCoordinate2D;//当前的定位到的点
    BMKGeoCodeSearch *_geocodesearch;//搜索得出经纬度或者搜索反编码经纬度
    BMKRouteSearch *_routesearch;//搜索类对象
    NSString *routeType;//搜索路线的类型
    NSMutableArray *allRoute;//存储所有的路线
    UIColor *coverColor;//覆盖物的颜色
    float coverBorderWidth;//覆盖路线的宽度
    NSString *storeName;//店铺的名称
    NSString *currentPlace;//当前经纬度反编码得到的位置
}
@property (strong, nonatomic) UIPickerView *routeChosePickerView;
@property (strong, nonatomic) NSArray *pickerViewDataArray;
@property (strong, nonatomic) NSMutableArray *pickerViewSecondDataArray;
@end

@implementation SYJMapViewController

-(NSString *)getMyBundlePath1:(NSString *)filename{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark-开始定位
-(void)startLocation{
     //初始定位管理器对象
    _locManager=[[CLLocationManager alloc] init];
    _locManager.delegate=self;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"设备上的定位服务没有启动.");
        return;
    }
    
    if (([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)||([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)||([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)) {
        [_locManager requestWhenInUseAuthorization];
    }else{
        //设置精确度
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        //设置最小距离更新(米)
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        //初始化管理对象
        _locService=[[BMKLocationService alloc] init];
        _locService.delegate=self;

        //开始定位
        [_locService startUserLocationService];
        custMapView.showsUserLocation=NO;
        custMapView.userTrackingMode=BMKUserTrackingModeFollowWithHeading;
        custMapView.showsUserLocation=YES;
    }
}

#pragma mark-处理方向变更信息
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [custMapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

#pragma mark-处理坐标更新
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //如果开始有定位,就先清除地标
    if (currentAnnotation!=nil) {
        [custMapView removeAnnotation:currentAnnotation];
    }
    
    //将当前的经纬度存储起来
    currentCoordinate2D=userLocation.location.coordinate;
    [custMapView updateLocationData:userLocation];
    
    //设置第一个componenet选中第二行
    [self.routeChosePickerView selectRow:1 inComponent:0 animated:YES];
    
    //进行反编码
    [self showDetailOf:userLocation];
}

#pragma mark-反编码,开始反编码
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

#pragma mark-反编码,输出反编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error==0) {
        //NSLog(@"address--%@",result.address);
        //将当前位置存储起来
        currentPlace=result.address;
    }
    
    //检索并绘制路线
    if ([routeType isEqualToString:@"步行路线"]) {
        BMKPlanNode* start=[[BMKPlanNode alloc] init];
        start.pt=currentCoordinate2D;
        BMKPlanNode* end=[[BMKPlanNode alloc] init];
        end.pt=coordinate1;
        BMKWalkingRoutePlanOption *walkingRouteSearchOperation=[[BMKWalkingRoutePlanOption alloc] init];
        //walkingRouteSearchOperation.from=
        walkingRouteSearchOperation.from=start;
        walkingRouteSearchOperation.to=end;
        
        BOOL flag=[_routesearch walkingSearch:walkingRouteSearchOperation];
        if (flag) {
            NSLog(@"walk检索成功");
        }else{
            NSLog(@"walk检索失败");
        }
    }else if([routeType isEqualToString:@"自驾路线"]){
        BMKPlanNode* start=[[BMKPlanNode alloc] init];
        start.pt=currentCoordinate2D;
        BMKPlanNode* end=[[BMKPlanNode alloc] init];
        end.pt=coordinate1;
        
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        drivingRouteSearchOption.drivingRequestTrafficType=BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
        
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
    }else{
        BMKPlanNode* start=[[BMKPlanNode alloc] init];
        start.pt=currentCoordinate2D;
        BMKPlanNode* end=[[BMKPlanNode alloc] init];
        end.pt=coordinate1;
        
        BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
        transitRouteSearchOption.city= APPDELEGATE.cityName;
        transitRouteSearchOption.from = start;
        transitRouteSearchOption.to = end;
        
        BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
        if(flag)
        {
            NSLog(@"bus检索发送成功");
        }
        else
        {
            NSLog(@"bus检索发送失败");
        }
    }
}

#pragma mark-编码,将地名转化成经纬度
-(void)showCoordinate:(NSString *)cityName andAddressName:(NSString *)addressName{
    BMKGeoCodeSearchOption *geocodeSearchOption=[[BMKGeoCodeSearchOption alloc] init];
    geocodeSearchOption.city=cityName;
    geocodeSearchOption.address=addressName;
    BOOL flag=[_geocodesearch geoCode:geocodeSearchOption];
    if (flag) {
        NSLog(@"geo检索成功");
    }else{
        NSLog(@"geo检索失败");
    }
}

#pragma mark-编码结果,将地名转化成经纬度
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error==0) {
        NSLog(@"正向编码:%@",result);
    }
}

#pragma mark-移动完成之后的执行的方法
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-为地图设置代理
-(void)viewWillAppear:(BOOL)animated{
    //初始化为步行路线
    //routeType=@"步行路线";
    allRoute=[NSMutableArray array];
    coverColor=[UIColor blueColor];
    coverBorderWidth=2.0f;
    
    //初始化地图控件
    [custMapView viewWillAppear];
    custMapView.centerCoordinate=currentCoordinate2D;
    
    //初始化查询路线的实例
    _routesearch=[[BMKRouteSearch alloc] init];
    _routesearch.delegate=self;
    
    
    
    //添加一个地图视图
    custMapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 415)];
    [custMapView setRegion:BMKCoordinateRegionMake(APPDELEGATE.userCoordinate,BMKCoordinateSpanMake(0.055, 0.055)) animated:YES];
    [self.view addSubview:custMapView];
    custMapView.delegate=self;
    
    //初始pickerView控件
    //CGRect sysFrame=[[UIScreen mainScreen] bounds];
    self.routeChosePickerView=[[UIPickerView alloc] init];
    //self.routeChosePickerView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGFloat routeY = custMapView.frame.origin.y + custMapView.frame.size.height;
    CGFloat routeH = kAllHeight - routeY;
    self.routeChosePickerView.frame=CGRectMake(0,routeY, 320, routeH);
    //self.routeChosePickerView.showsSelectionIndicator=YES;
    [self.view addSubview:self.routeChosePickerView];
    
    //初始化选择器的数组
    self.pickerViewDataArray=[NSArray arrayWithObjects:@"步行路线",@"公交路线",@"自驾路线", nil];
    self.pickerViewSecondDataArray=[NSMutableArray array];//初始化第二列的数据源
    self.routeChosePickerView.dataSource=self;
    self.routeChosePickerView.delegate=self;
    //self.routeChosePickerView.backgroundColor=[UIColor orangeColor];
    
    //地图添加了之后，显示默认的用户当前的位置,将用户当前的点显示在地图上
    currentAnnotation.coordinate=APPDELEGATE.currentCoordinate;
    currentAnnotation.title=@"这个是当前位置";
    currentAnnotation.subtitle=@"高博";
    [custMapView addAnnotation:currentAnnotation];
    
    _geocodesearch=[[BMKGeoCodeSearch alloc] init];
    //设置代理
    _geocodesearch.delegate=self;
    
    //设置底部的tabBar
    self.tabBarController.tabBar.hidden=YES;
    //mapView.delegate=self;
    
    //设置导航
    [self setNavigation];
    
    //开始定位
    //[self startLocation];
    
    //开始获取数据
    [self getDataOfStore];
}

#pragma mark-设置UIPickerView的代理
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

#pragma mark-返回UIPickerView的每一个Component的row的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [self.pickerViewDataArray count];
    }else if (component==1){
//        if ((self.pickerViewSecondDataArray!=nil)&&(self.pickerViewSecondDataArray.count!=0)&&![self.pickerViewSecondDataArray.class isSubclassOfClass:[NSNull class]]) {
//            return [self.pickerViewSecondDataArray count];
//        }
        if ((allRoute!=nil)&&(allRoute.count!=0)&&![allRoute.class isSubclassOfClass:[NSNull class]]) {
            return [allRoute count];
        }
        return 1;
    }else{
        return 1;
    }
}

#pragma mark-返回UIPickerView的每一个row的title
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [self.pickerViewDataArray objectAtIndexedSubscript:row];
//}

#pragma mark-返回UIPickerView的每一个row的高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

#pragma mark-返回UIPickerView的每一个row的view
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (component==0) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=cellTextColor;
        
        label.textAlignment=NSTextAlignmentCenter;
        label.text=[self.pickerViewDataArray objectAtIndex:row];
        return label;
    }else if(component==1){
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=cellTextColor;
        
        label.textAlignment=NSTextAlignmentCenter;
        
        /**
         *  if ((self.pickerViewSecondDataArray==nil)||(self.pickerViewSecondDataArray.count==0)||[self.pickerViewSecondDataArray isKindOfClass:[NSNull class]]) {
         label.text=@"抱歉，暂时不提供相关路线，可能太近了。";
         */
        
        if ((allRoute==nil)||(allRoute.count==0)||[allRoute isKindOfClass:[NSNull class]]) {
            label.text=@"抱歉，暂不提供相关路线，请切换其他路线。";
            label.adjustsFontSizeToFitWidth=YES;
        }else{
            NSDictionary *routeDic=[allRoute objectAtIndex:row];
            /**
             *  NSDictionary *dic=@{
             @"routeLength":[NSNumber numberWithDouble:routeLeght/1000],
             @"currentRoute":plan,
             @"busyRate":[NSNumber numberWithDouble:routeBusy/routeBusyCount]
             };
             */
            //NSString *textDesc=[NSString stringWithFormat:@"路线%d:大约%.2lf公里",row+1,[[self.pickerViewSecondDataArray objectAtIndex:row] doubleValue]];
            NSString *textDesc;
            if ([routeType isEqualToString:@"自驾路线"]) {
                textDesc=[NSString stringWithFormat:@"路线%ld:约%.2lf公里,拥挤指数:%.3f",row+1,[routeDic[@"routeLength"] floatValue],[routeDic[@"busyRate"] floatValue]];
            }else if ([routeType isEqualToString:@"公交路线"]){
                //BMKTime *time=(BMKTime *)routeDic[@"duration"];
                /**
                 *  BMKWalkingRouteLine *plan in result.routes
                 @"currentRoute":plan
                 */
                BMKTransitRouteLine *currentLine=routeDic[@"currentRoute"];
                textDesc=[NSString stringWithFormat:@"路线%ld:约%.2lf公里;耗时:约%@",row+1,[routeDic[@"routeLength"] floatValue],[NSString stringWithFormat:@"%d时%d分%d秒",currentLine.duration.hours,currentLine.duration.minutes,currentLine.duration.seconds]];
                //textDesc=[NSString stringWithFormat:@"路线%d:大约%.2lf公里",row+1,[routeDic[@"routeLength"] floatValue]];
            }else{
                if (routeDic!=nil) {
                    BMKWalkingRouteLine *currentLine=routeDic[@"currentRoute"];
                    textDesc=[NSString stringWithFormat:@"路线%ld:约%.2lf公里;耗时:约%@",row+1,[routeDic[@"routeLength"] floatValue],[NSString stringWithFormat:@"%d时%d分%d秒",currentLine.duration.hours,currentLine.duration.minutes,currentLine.duration.seconds]];
                }
            }
            
            label.text=textDesc;
        }
        return label;
    }else{
        return nil;
    }
}

#pragma mark-设置每一列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return 80;
    }else if (component==1){
        return 240;
    }else{
        return 0;
    }
}

#pragma mark-UIPickerView的选中事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        //初始化路线的颜色
        coverColor=[UIColor blueColor];
        coverBorderWidth=2.0;
        
        if ([self.routeChosePickerView selectedRowInComponent:0]==0) {
            NSLog(@"步行路线");
            routeType=@"步行路线";
            BMKPlanNode* start=[[BMKPlanNode alloc] init];
            start.pt=currentCoordinate2D;
            BMKPlanNode* end=[[BMKPlanNode alloc] init];
            end.pt=coordinate1;
            BMKWalkingRoutePlanOption *walkingRouteSearchOperation=[[BMKWalkingRoutePlanOption alloc] init];
            walkingRouteSearchOperation.from=start;
            walkingRouteSearchOperation.to=end;
            
            BOOL flag=[_routesearch walkingSearch:walkingRouteSearchOperation];
            if (flag) {
                NSLog(@"walk检索成功");
            }else{
                NSLog(@"walk检索失败");
            }
        }else if([self.routeChosePickerView selectedRowInComponent:0]==1){
            NSLog(@"公交路线");
            routeType=@"公交路线";
            BMKPlanNode* start=[[BMKPlanNode alloc] init];
            start.pt=currentCoordinate2D;
            BMKPlanNode* end=[[BMKPlanNode alloc] init];
            end.pt=coordinate1;
            
            BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
            transitRouteSearchOption.city=APPDELEGATE.cityName;
            transitRouteSearchOption.from = start;
            transitRouteSearchOption.to = end;
            
            BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
            if(flag)
            {
                NSLog(@"bus检索发送成功");
            }
            else
            {
                NSLog(@"bus检索发送失败");
            }
        }else{
            NSLog(@"自驾路线");
            routeType=@"自驾路线";
            BMKPlanNode* start=[[BMKPlanNode alloc] init];
            start.pt=currentCoordinate2D;
            BMKPlanNode* end=[[BMKPlanNode alloc] init];
            end.pt=coordinate1;
            
            BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = start;
            drivingRouteSearchOption.to = end;
            drivingRouteSearchOption.drivingRequestTrafficType=BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
            
            BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
            if(flag)
            {
                NSLog(@"car检索发送成功");
            }
            else
            {
                NSLog(@"car检索发送失败");
            }
        }
        [self.routeChosePickerView selectRow:0 inComponent:1 animated:YES];
    }else if (component==1){
        if ([self.routeChosePickerView selectedRowInComponent:0]==1) {
            //画公交车的路线
            [self drawTransitWay];
        }else if([self.routeChosePickerView selectedRowInComponent:0]==2){
            //画自驾路线
            [self drawDriveWay];
        }else if([self.routeChosePickerView selectedRowInComponent:0]==0){
            //画步行路线
            [self drawWalkWay];
        }
    }else{}
}

#pragma mark-开始请求店铺数据
-(void)getDataOfStore{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *parameter=@{@"store_id":[NSNumber numberWithInt:self.storeId]};
    NSString *url=[NSString stringWithFormat:@"%@Shop/getStoreById",SYJHTTP];
    //NSString *url=@"http://localhost:8888/SYJ/index.php/home/shop/getStoreById";
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSString *code=dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dataDic=dic[@"data"];
            
            //添加店铺锚点
            SYJAnnotation *cusAnnotation=[SYJAnnotation localAnnotationWith:dataDic[@"store_name"] subTitle:dataDic[@"store_place"] latitude:[dataDic[@"store_wd"] floatValue] longitude:[dataDic[@"store_jd"] floatValue]];//[dic[@"store_wd"] floatValue]
            coordinate1=CLLocationCoordinate2DMake([dataDic[@"store_wd"] floatValue], [dataDic[@"store_jd"] floatValue]);
            
            storeName=dataDic[@"store_name"];
            
            //NSLog(@"获取到店铺的数据了。。。。。。。");
            //获取到店铺的数据之后开始定位
            [self startLocation];
            //添加店铺锚点
            [custMapView addAnnotation:cusAnnotation];
        }else{
            NSLog(@"网络数据获取失败,请重试.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络连接有问题,请检查网络连接.");
    }];
}

#pragma mark-设置导航
-(void)setNavigation{
    //添加一个自定义view
    naviagtionView=[[[NSBundle mainBundle] loadNibNamed:@"SYJNavigationView" owner:self options:nil] objectAtIndex:0];
    naviagtionView.frame=CGRectMake(0, 0, 320, 64);
    
    //设置searchBar为白色
    UIView *backgroundView=[[[naviagtionView.customSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
    [backgroundView removeFromSuperview];
    [naviagtionView.searchButton removeFromSuperview];
    [naviagtionView.customSearchBar removeFromSuperview];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 27, 40, 30)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:btnColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backImageGoBack) forControlEvents:UIControlEventTouchUpInside];
    [naviagtionView addSubview:btn];
    
    //添加中间的label部分
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(61, 20, 200, 40)];
    label.textColor=btnColor;
    //label.backgroundColor=[UIColor blueColor];
    label.text=@"去店铺";
    label.textAlignment=NSTextAlignmentCenter;
    [naviagtionView addSubview:label];

    naviagtionView.backgroundColor=navigationViewBgcolor;
    
    [self.navigationController.view addSubview:naviagtionView];
    naviagtionView.delegate=self;
}

#pragma mark-导航栏的返回按钮点击事件
-(void)backImageGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-为地图消除代理
-(void)viewWillDisappear:(BOOL)animated{
    [custMapView viewWillDisappear];
    _locManager.delegate=nil;
    _locService.delegate=nil;
    custMapView.delegate=nil;
    _geocodesearch.delegate=nil;
    _routesearch.delegate=nil;
    
    //显示TabBar
    self.tabBarController.tabBar.hidden=NO;
    [naviagtionView removeFromSuperview];
}

#pragma mark-获取路线中的点的view,返回并显示在地图上
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(SYJAnnotation *)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark-计算步行的路线
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
    //检索之前，先清除数组中的数据
    if (self.pickerViewSecondDataArray!=nil) {
        [self.pickerViewSecondDataArray removeAllObjects];
    }
    
    //将路线存储起来
    if (allRoute!=nil) {
        [allRoute removeAllObjects];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //记录是第几条路径
        int currentCount=1;
        
        for (BMKWalkingRouteLine *plan in result.routes) {
            //BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
            int size = (int)[plan.steps count];
            int planPointCounts = 0;
            //声明路径长度记录变量
            double routeLeght=0.0;
            //声明路径时间记录变量
            double timeLength=0.0;
            for (int i = 0; i < size; i++) {
                BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
                //轨迹点总数累计
                planPointCounts += transitStep.pointsCount;
                //路径长度记录
                routeLeght+=transitStep.distance;
                //路径时间记录
                timeLength+=transitStep.duration;
            }
            
            NSLog(@"第%d路线的长度约为%.2lf公里",currentCount,routeLeght/1000);
            [self.pickerViewSecondDataArray addObject:[NSNumber numberWithDouble:routeLeght/1000]];
            //NSLog(@"第%d路线的大约需要%lf分钟",currentCount,timeLength/60);
            NSDictionary *dic=@{
                                @"routeLength":[NSNumber numberWithDouble:routeLeght/1000],
                                @"currentRoute":plan
                                };
            [allRoute addObject:dic];
            currentCount++;
        }
    }
    
    //对路线数组排序
    [allRoute sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1=(NSDictionary *)obj1;
        NSDictionary *dic2=(NSDictionary *)obj2;
        NSNumber *n1=[dic1 valueForKey:@"routeLength"];
        NSNumber *n2=[dic2 valueForKey:@"routeLength"];
        return [n1 compare:n2];
    }];
    
    //刷新数据
    [self.routeChosePickerView reloadComponent:1];
    
    //绘制地图
    [self drawWalkWay];
}

#pragma mark-公交路线计算
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
    //打开路况图层
    [custMapView setTrafficEnabled:NO];
    
    //检索之前，先清除数组中的数据
    if (self.pickerViewSecondDataArray!=nil) {
        [self.pickerViewSecondDataArray removeAllObjects];
    }
    
    //将路线存储起来
    if (allRoute!=nil) {
        [allRoute removeAllObjects];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //记录是第几条路径
        int currentCount=1;
        
        for (BMKTransitRouteLine* plan in result.routes) {
            //BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
            // 计算路线方案中的路段数目
            int size = (int)[plan.steps count];
            int planPointCounts = 0;
            //声明路径长度记录变量
            double routeLeght=0.0;
            
            for (int i = 0; i < size; i++) {
                BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
                //轨迹点总数累计
                planPointCounts += transitStep.pointsCount;
                //路径长度记录
                routeLeght+=transitStep.distance;
            }
           
            [self.pickerViewSecondDataArray addObject:[NSNumber numberWithDouble:routeLeght/1000]];
            NSDictionary *dic=@{
                                @"routeLength":[NSNumber numberWithDouble:routeLeght/1000],
                                @"currentRoute":plan
                                };
            [allRoute addObject:dic];
            currentCount++;
        }
    }else{
        //获取到了新的数据,刷新UIPickerView的数据
        [self.routeChosePickerView reloadComponent:1];
        //NSLog(@"开始打印数组了%@",self.pickerViewSecondDataArray);
        return;
    }
    
    //排序方法
    [self.pickerViewSecondDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2];
    }];
    
    //对路线数组排序
    [allRoute sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1=(NSDictionary *)obj1;
        NSDictionary *dic2=(NSDictionary *)obj2;
        NSNumber *n1=[dic1 valueForKey:@"routeLength"];
        NSNumber *n2=[dic2 valueForKey:@"routeLength"];
        return [n1 compare:n2];
    }];
    
    //获取到了新的数据,刷新UIPickerView的数据
    [self.routeChosePickerView reloadComponent:1];
    
    //开始绘制公交路线
    [self drawTransitWay];
}

#pragma mark-自驾路线计算
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
    //打开路况图层
    [custMapView setTrafficEnabled:NO];
    
    //检索之前，先清除数组中的数据
    if (self.pickerViewSecondDataArray!=nil) {
        [self.pickerViewSecondDataArray removeAllObjects];
    }
    
    //将路线存储起来
    if (allRoute!=nil) {
        [allRoute removeAllObjects];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //记录是第几条路径
        int currentCount=1;
        
        for (BMKDrivingRouteLine* plan in result.routes) {
            //BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
            // 计算路线方案中的路段数目
            int size = (int)[plan.steps count];
            int planPointCounts = 0;
            //声明路径长度记录变量
            double routeLeght=0.0;
            //声明路径时间记录变量
            double timeLength=0.0;
            
            //声明一个变量来存储路线的拥堵程度
            double routeBusy=0.0;
            int routeBusyCount=0;
            
            for (int i = 0; i < size; i++) {
                BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
                
                //轨迹点总数累计
                planPointCounts += transitStep.pointsCount;
                //路径长度记录
                routeLeght+=transitStep.distance;
                //路径时间记录
                timeLength+=transitStep.duration;
                //NSLog(@"%d",transitStep.duration);
                //NSLog(@"打印拥挤程度...");
                //NSLog(@"%@--count:%d",transitStep.traffics,[transitStep.traffics count]);
                
                //开始计算拥挤程度
                for (int i=0; i<transitStep.traffics.count; i++) {
                    NSArray *routeTrafic=transitStep.traffics;
                    int temp=[[routeTrafic objectAtIndex:i] intValue];
                    if (temp==1) {
                        routeBusy+=0.1;
                    }else if (temp==2){
                        routeBusy+=0.2;
                    }else if (temp==3){
                        routeBusy+=0.3;
                    }else{
                        routeBusy+=0.4;
                    }
                    routeBusyCount++;
                }
                
            }

            NSLog(@"第%d路线的长度约为%.2lf公里,拥挤程度:%lf",currentCount,routeLeght/1000,routeBusy/routeBusyCount);
            [self.pickerViewSecondDataArray addObject:[NSNumber numberWithDouble:routeLeght/1000]];
            //NSLog(@"第%d路线的大约需要%lf分钟",currentCount,timeLength/60);
            NSDictionary *dic=@{
                                @"routeLength":[NSNumber numberWithDouble:routeLeght/1000],
                                @"currentRoute":plan,
                                @"busyRate":[NSNumber numberWithDouble:routeBusy/routeBusyCount]
                                };
            [allRoute addObject:dic];
            currentCount++;
        }
        
    }
    
    //排序方法
    [self.pickerViewSecondDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2];
    }];
    
    //对路线数组排序
    [allRoute sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1=(NSDictionary *)obj1;
        NSDictionary *dic2=(NSDictionary *)obj2;
        NSNumber *n1=[dic1 valueForKey:@"routeLength"];
        NSNumber *n2=[dic2 valueForKey:@"routeLength"];
        return [n1 compare:n2];
    }];
    
    //刷新路线
    [self.routeChosePickerView reloadComponent:1];
    
    //开始绘制自驾的路线
    [self drawDriveWay];
    
}

#pragma mark-根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [custMapView setVisibleMapRect:rect];
    custMapView.zoomLevel = custMapView.zoomLevel - 0.3;
}

#pragma mark-画出每一个点的view
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SYJAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(SYJAnnotation*)annotation];
    }
    return nil;
}

#pragma mark-画出路线view
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    //BMKOverlay *tempOverlay=(BMKOverlay *)overlay;
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [coverColor colorWithAlphaComponent:1];
        polylineView.strokeColor = [coverColor colorWithAlphaComponent:0.7];
        polylineView.lineWidth = coverBorderWidth;
        return polylineView;
    }
    return nil;
}

#pragma mark-绘制公交车的路线
-(void)drawTransitWay{
    //重新绘制地图,使用2种颜色
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
    //记录是第几条路径
    int currentCount=0;
    
    for (NSDictionary *currentDic in allRoute) {
        
        BMKTransitRouteLine *plan=[currentDic valueForKey:@"currentRoute"];
        
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = currentPlace;
                item.type = 0;
                [custMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = storeName;
                item.type = 1;
                [custMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            SYJAnnotation* item = [[SYJAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            //item.degree = transitStep.direction * 30;
            item.type = 4;
            [custMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        if (currentCount==[self.routeChosePickerView selectedRowInComponent:1]) {
            coverColor=[UIColor greenColor];
            coverBorderWidth=3.0;
        }else{
            coverColor=[UIColor blueColor];
            coverBorderWidth=2.0;
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [custMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
        currentCount++;
    }
}

#pragma mark-画自驾路线
-(void)drawDriveWay{
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
    //打开路况图层
    [custMapView setTrafficEnabled:NO];
    
    int currentCount=0;
    
    for (NSDictionary *currentDic in allRoute) {
        
        BMKDrivingRouteLine *plan=[currentDic valueForKey:@"currentRoute"];
        
        //BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = currentPlace;
                item.type = 0;
                [custMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = storeName;
                item.type = 1;
                [custMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            SYJAnnotation* item = [[SYJAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [custMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item = [[SYJAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [custMapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        //切换颜色
        if (currentCount==[self.routeChosePickerView selectedRowInComponent:1]) {
            coverColor=[UIColor greenColor];
            coverBorderWidth=3.0;
        }else{
            coverColor=[UIColor blueColor];
            coverBorderWidth=2.0;
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [custMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
        currentCount++;
    }
}

#pragma mark-画步行路线
-(void)drawWalkWay{
    NSArray* array = [NSArray arrayWithArray:custMapView.annotations];
    [custMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:custMapView.overlays];
    [custMapView removeOverlays:array];
    
        //记录是第几条路径
        int currentCount=0;
        
        for (NSDictionary *currentDic in allRoute) {
            
            BMKDrivingRouteLine *plan=[currentDic valueForKey:@"currentRoute"];
            
            //BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
            int size = (int)[plan.steps count];
            int planPointCounts = 0;
            for (int i = 0; i < size; i++) {
                BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
                if(i==0){
                    SYJAnnotation* item = [[SYJAnnotation alloc]init];
                    item.coordinate = plan.starting.location;
                    item.title =currentPlace;
                    item.type = 0;
                    [custMapView addAnnotation:item]; // 添加起点标注
                    
                }else if(i==size-1){
                    SYJAnnotation* item = [[SYJAnnotation alloc]init];
                    item.coordinate = plan.terminal.location;
                    item.title = storeName;
                    item.type = 1;
                    [custMapView addAnnotation:item]; // 添加起点标注
                }
                //添加annotation节点
                SYJAnnotation* item = [[SYJAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.instruction;
                item.degree = transitStep.direction * 30;
                item.type = 4;
                [custMapView addAnnotation:item];
                
                //轨迹点总数累计
                planPointCounts += transitStep.pointsCount;
            }
            
            //轨迹点
            BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
            int i = 0;
            for (int j = 0; j < size; j++) {
                BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
                int k=0;
                for(k=0;k<transitStep.pointsCount;k++) {
                    temppoints[i].x = transitStep.points[k].x;
                    temppoints[i].y = transitStep.points[k].y;
                    i++;
                }
                
            }
            
            // 通过points构建BMKPolyline
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
            [custMapView addOverlay:polyLine]; // 添加路线overlay
            delete []temppoints;
            [self mapViewFitPolyLine:polyLine];
            
            currentCount++;
        }
}
@end
