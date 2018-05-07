//
//  SYJStore.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJStore : NSObject

@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,assign) int goodCount;
@property (nonatomic,strong) NSMutableArray *goodArray;

-(SYJStore *)initWithStoreName:(NSString *)storeName andGoodCount:(int)goodCount andGoodArray:(NSArray *)goodArray;

@end
