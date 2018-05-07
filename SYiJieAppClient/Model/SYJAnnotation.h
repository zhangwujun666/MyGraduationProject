//
//  SYJAnnotation.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/12.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h> //引入百度地图所有的头文件

@interface SYJAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign)int type;//0:起点 1:终点 2:公交 3:地铁 4:驾乘 5:途径点
@property (nonatomic, assign)int degree;
@property (nonatomic, strong) UIImage *image;

+(id)localAnnotationWith:(NSString *)newTitle subTitle:(NSString *)newSubtitle latitude:(float)newLatitude longitude:(float)newLongitude;

@end
