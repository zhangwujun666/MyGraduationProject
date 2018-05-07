//
//  SYJUser.m
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJUser.h"

@implementation SYJUser
-(SYJUser *)initWithUsername:(NSString *)username andTelephone:(NSString *)telephone andHeadImage:(NSString *)headImage andEmail:(NSString *)email andpasward:(NSString *)pasward andsex:(NSString *)sex andUserbrithday:(NSString *)brithday andConstellation:(NSString *)Constellation andage:(NSUInteger)age{
    if (self = [super init]) {
        self.telephone = telephone;
    }
    return self;
}

+(SYJUser *)initWithDic:(NSDictionary *)dic{
    SYJUser *user=[[SYJUser alloc]init];
    user.userID=[[dic valueForKey:@"user_id"]integerValue];
    user.telephone=[dic valueForKey:@"user_telephone"];
    user.username=[dic valueForKey:@"user_name"];
    user.pasward=[dic valueForKey:@"user_password"];
    user.headImage=[dic valueForKey:@"user_image"];
    user.email=[dic valueForKey:@"user_email"];
    user.sex=[dic valueForKey:@"user_sex"];
    if ([dic valueForKey:@"user_age"]==NULL) {
        user.age = 0;
    }else{
        user.age=[[dic valueForKey:@"user_age"]intValue];
    }
    //user.age=[[dic valueForKey:@"user_age"]intValue];
    user.user_brithday=[dic valueForKey:@"user_brithday"];
    user.user_Constellation=[dic valueForKey:@"user_constellation"];
    user.lovestate=[dic valueForKey:@"user_lovestate"];
    user.home=[dic valueForKey:@"user_address"];
    NSLog(@"%@",[dic valueForKey:@"user_constellation"]);
    return user;
    
    
}
@end
