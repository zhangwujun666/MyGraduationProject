//
//  SYJHomeViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/28.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SYJHomeViewControllerDelegate <NSObject>

-(void)SYJHomeViewControllerDelegateLoadMoreData;

@end
@interface SYJHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *goodsSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *areaShowButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *homeHeadView;
@property (weak, nonatomic) IBOutlet UILabel *miaoShaLabel;
@property (weak , nonatomic)id<SYJHomeViewControllerDelegate>delegate;

@end
