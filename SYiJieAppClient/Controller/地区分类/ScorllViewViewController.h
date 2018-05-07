//
//  ScorllViewViewController.h
//  引导页面之ScrollView
//
//  Created by administrator on 15/7/4.
//  Copyright (c) 2015年 wanderer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();

@interface ScorllViewViewController : UIViewController

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@end
