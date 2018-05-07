//
//  SYJHeadView.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/14.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol headviewDelegate <NSObject>

-(void)requestt;
-(void)requesttwo;
-(void)requeststree;
-(void)requestfore;
@end

@interface SYJHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *stree;
@property (weak, nonatomic) IBOutlet UIButton *fore;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic)id<headviewDelegate>delegate;
@property UILabel *lb;
@property UIView *view;
@property int i;
@end
