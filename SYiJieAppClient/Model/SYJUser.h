//
//  SYJUser.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/27.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJUser : NSObject
@property NSUInteger userID;
@property int  age;
@property (copy, nonatomic)NSString *username;
@property (copy, nonatomic)NSString *telephone;
@property (copy, nonatomic)NSString *headImage;
@property (copy, nonatomic)NSString *email;
@property (copy, nonatomic)NSString *pasward;
@property  (copy, nonatomic)NSString *sex;
@property  (copy, nonatomic)NSString *user_brithday;
@property  (copy, nonatomic)NSString *user_Constellation;
@property  (copy, nonatomic)NSString *lovestate;
@property  (copy, nonatomic)NSString *home;
-(SYJUser *)initWithUsername:(NSString *)username andTelephone:(NSString *)telephone andHeadImage:(NSString *)headImage andEmail:(NSString *)email andpasward:(NSString *)pasward andsex:(NSString*)sex andUserbrithday:(NSString *)brithday andConstellation:(NSString *)Constellation andage:(NSUInteger)age;

+(SYJUser *)initWithDic:(NSDictionary *)dic;
@end
