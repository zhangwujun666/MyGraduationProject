//
//  SYJcar.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJcar.h"
static  SYJcar *Cart=nil;

@implementation SYJcar
+(SYJcar *)sharedInstance{
    @synchronized(self){
        if(Cart==nil){
            Cart=[[SYJcar alloc]init];
        }
    }
    return  Cart;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if (Cart == nil) {
            Cart = [super allocWithZone:zone];
        }
    }
    return Cart;
}
@end