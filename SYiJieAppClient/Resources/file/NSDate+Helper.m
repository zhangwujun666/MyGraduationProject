//
//  NSDate+Helper.m
//  demo-使用类别
//
//  Created by administrator on 15/6/5.
//  Copyright (c) 2015年 廖雪真. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

-(NSString *)stringFromNSDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

@end
