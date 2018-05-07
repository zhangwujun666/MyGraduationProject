//
//  SYJGood.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJGood.h"

@implementation SYJGood
-(SYJGood *)initWithDic:(NSDictionary *)dic{
    //SYJGood *good=[[SYJGood alloc] init];
    if (self=[super init]) {
        self.car_user_id=[dic[@"car_user_id"] intValue];
        self.car_cargoods_id=[dic[@"car_cargoods_id"] intValue];
        self.car_namegoods=dic[@"car_namegoods"];
        self.car_imagegoods=dic[@"car_imagegoods"];
        self.car_pricegoods=[dic[@"car_pricegoods"] intValue];
        self.car_colourgood=dic[@"car_colourgood"];
        self.car_sizegood=dic[@"car_sizegood"];
        self.car_store_id=[dic[@"car_store_id"] intValue];
        self.car_store_name=dic[@"car_store_name"];
        self.car_numbercar=[dic[@"car_numbercar"] intValue];
        self.car_id=dic[@"car_id"];
    }
    return self;
}
@end
