//
//  SYJPersondataTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SexViewDelegateee <NSObject>

-(void)appear;
@end
@interface SYJPersondataTableViewController : UITableViewController
@property( nonatomic) NSNumber *useragee;
@property(weak,nonatomic) id<SexViewDelegateee>delegate;
@end
