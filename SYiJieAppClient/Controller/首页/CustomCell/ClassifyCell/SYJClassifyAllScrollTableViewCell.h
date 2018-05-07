//
//  SYJClassifyAllScrollTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/6.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJClassifyAllScrollTableViewCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageContrl;
@property (strong, nonatomic)NSString * type;
-(void)getScrollImage;
@end
