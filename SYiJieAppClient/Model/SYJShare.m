//
//  SYJShare.m
//  SYiJieAppClient
//
//  Created by administrator on 15/9/3.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJShare.h"

@implementation SYJShare
-(SYJShare *)initWithDic:(NSDictionary *)dic{
    if (self=[super init]) {
        self.share_id=[dic[@"share_id"] intValue];
        self.share_user_id=[dic[@"share_user_id"] intValue];
        self.share_user_name=dic[@"share_user_name"];
        self.share_user_image=dic[@"share_user_image"];
        self.share_contenet=dic[@"share_content"];
        self.share_imagenumber=[dic[@"share_imagenumber"] intValue];
        self.share_like=[dic[@"share_like"] intValue];
        self.share_good_id=[dic[@"share_good_id"] intValue];
        self.share_goodsname=dic[@"share_goodsname"];
        self.share_time=[dic[@"share_time"] intValue];
        self.like_count=[dic[@"like_count"] intValue];
        self.allpics=dic[@"allpics"];
    }
    return self;
}
@end
