//
//  SYJcar.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJcar : NSObject
@property int  Carcount;
+(SYJcar *)sharedInstance;
@end