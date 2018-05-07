//
//  SYJSelectGoodsViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/29.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJSelectGoodsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *goodsFinishTableView;
- (void)getFinshGoodsData;
@end
