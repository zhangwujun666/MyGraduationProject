//
//  SYJGood.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJGood : NSObject
@property (nonatomic,assign) int car_user_id;
@property (nonatomic,assign) int car_cargoods_id;
@property (nonatomic,copy) NSString *car_namegoods;
@property (nonatomic,copy) NSString *car_imagegoods;
@property (nonatomic,assign) int car_pricegoods;
@property (nonatomic,copy) NSString *car_colourgood;
@property (nonatomic,copy) NSString *car_sizegood;
@property (nonatomic,assign) int car_store_id;
@property (nonatomic,copy) NSString *car_store_name;
@property (nonatomic,assign) int car_numbercar;
@property (nonatomic,copy) NSString *car_id;
-(SYJGood *)initWithDic:(NSDictionary *)dic;
@end
