//
//  SYJSearchStoreReusbleHeaderView.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/8.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowAllDetailDelegate <NSObject>

-(void)showAllData:(UITableViewHeaderFooterView *)headerView;

@end

@interface SYJSearchStoreReusbleHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) UILabel *storeNameLabel;
@property (strong, nonatomic) UIButton *showAllButton;
@property (weak, nonatomic) id<ShowAllDetailDelegate> delegate;
@end
