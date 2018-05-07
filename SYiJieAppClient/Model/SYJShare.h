//
//  SYJShare.h
//  SYiJieAppClient
//
//  Created by administrator on 15/9/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJShare : NSObject
@property (assign,nonatomic) int share_id;
@property (assign,nonatomic) int share_user_id;
@property (copy,nonatomic) NSString *share_user_name;
@property (copy,nonatomic) NSString *share_user_image;
@property (copy,nonatomic) NSString *share_contenet;
@property (assign,nonatomic) int share_imagenumber;
@property (assign,nonatomic) int share_like;
@property (assign,nonatomic) int share_good_id;
@property (copy,nonatomic) NSString *share_goodsname;
@property (copy,nonatomic) NSString *share_address;
@property (assign,nonatomic) int share_time;
@property (assign,nonatomic) int like_count;
@property (strong,nonatomic) NSArray *allpics;
-(SYJShare *)initWithDic:(NSDictionary *)dic;
@end
