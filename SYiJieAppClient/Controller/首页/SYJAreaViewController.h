//
//  SYJAreaViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/1.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJAreaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *headNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *searchBarTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *areaSearchBar;


@end
