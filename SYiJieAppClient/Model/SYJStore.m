//
//  SYJStore.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJStore.h"
#import "SYJGood.h"

@implementation SYJStore
-(SYJStore *)initWithStoreName:(NSString *)storeName andGoodCount:(int)goodCount andGoodArray:(NSArray *)goodArray{
    
    if (self=[super init]) {
        self.storeName=storeName;
        self.goodCount=goodCount;
        //初始化数组
        self.goodArray=[[NSMutableArray alloc] init];
        for (int i=0; i<goodCount; i++) {
            //获取商品的字典数据
            NSDictionary *goodDic=[goodArray objectAtIndex:i];
            //SYJGood *good=[SYJGood initWithDic:goodDic];
            SYJGood *good=[[SYJGood alloc] initWithDic:goodDic];
            [self.goodArray addObject:good];
        }
    }
    return self;
}
@end
