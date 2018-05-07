//
//  SYJOrder.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/2.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJOrder.h"

@implementation SYJOrder


+(SYJOrder *)initWithOrderDic:(NSDictionary *)dic{
    SYJOrder *Order=[[SYJOrder alloc]init];
    Order.order_address=[dic objectForKey:@"order_address"];
    Order.order_id=[dic objectForKey:@"order_id"];
    Order.order_number=[dic objectForKey:@"order_number"];
    Order.order_pruduttime=[dic objectForKey:@"order_pruduttime"];
    Order.order_storename=[dic objectForKey:@"order_storename"];
    Order.order_type=[dic objectForKey:@"order_type"];
    Order.order_user_id=[dic objectForKey:@"order_user_id"];
    Order.order_goodsname=[dic objectForKey:@"order_goodsname"];
    Order.order_goodsimage=[dic objectForKey:@"order_goodsimage"];
    Order.order_goodsprice=[dic objectForKey:@"order_goodsprice"];
    return Order;
}
@end
