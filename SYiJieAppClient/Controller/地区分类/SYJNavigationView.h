//
//  SYJNavigationView.h
//  SYiJieAppClient
//
//  Created by administrator on 15/7/30.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate<NSObject>

-(void)backImageGoBack;

@end

/**
 *  searchArray存储最近搜索的记录，倒叙显示
 *  backImage是左边的后退的那张图片
 *  customSearchBar是中间的搜索框
 *  searchButton是右边的搜索按钮
 *  SeachDelegate是通知底部的viewController后退的代理
 */
@interface SYJNavigationView : UIView<UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UISearchBar *customSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) id<SearchDelegate> delegate;
@end
