//
//  SYJYanzhenViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/13.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ViewControllerDelegate <NSObject>
-(void)ViewControllerWithName:(NSString *)name;
@end
@interface SYJYanzhenViewController : UIViewController
@property NSMutableString *str;
@property (weak, nonatomic)id<ViewControllerDelegate> delegate;
@end
