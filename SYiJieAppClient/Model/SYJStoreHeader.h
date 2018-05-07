//
//  SYJStoreHeader.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJStoreHeader : NSObject
/**
 *  本模型用于存储店铺页面中,页面的头的信息，包括店铺的名称，logo，关注数量，关注的图片
 */
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,strong) UIImage *storelogo;
@property (nonatomic,assign) int likeCount;
@property (nonatomic,strong) UIImage *likeImage;
@property (nonatomic,copy) NSString *allgood;
@property (nonatomic,copy) NSString *allgoodcount;
@property (nonatomic,strong) UIColor *allgoodcolor;
@property (nonatomic,copy) NSString *upnewgood;
@property (nonatomic,copy) NSString *upnewgoodcount;
@property (nonatomic,strong) UIColor *upnewgoodcolor;
@property (nonatomic,copy) NSString *promotegood;
@property (nonatomic,copy) NSString *promotegoodcount;
@property (nonatomic,strong) UIColor *promotegoodcolor;
@end
