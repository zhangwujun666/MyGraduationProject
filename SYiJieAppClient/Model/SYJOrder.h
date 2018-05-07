//
//  SYJOrder.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/2.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJOrder : NSObject
@property int  age;
@property (copy, nonatomic)NSString *order_id;
@property (copy, nonatomic)NSString *order_number;
@property (copy, nonatomic)NSString *order_pruduttime;
@property (copy, nonatomic)NSString *order_type;
@property (copy, nonatomic)NSString *order_address;
@property  (copy, nonatomic)NSString *order_user_id;
@property  (copy, nonatomic)NSString *order_storename;
@property  (copy, nonatomic)NSString *order_goodsimage;
@property  (copy, nonatomic)NSString *order_goodsname;//order_goodsprice
@property  (copy, nonatomic)NSString *order_goodsprice;
+(SYJUser *)initWithOrderDic:(NSDictionary *)dic;
@end
