//
//  SYJCommentTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/15.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJCommentTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *CommentContentField;
@property (weak, nonatomic) IBOutlet UIButton *SureimgButton;
@property (weak, nonatomic) IBOutlet UIImageView *GoodsImage;
@property (weak, nonatomic) IBOutlet UILabel *GoodsNameLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsPricelable;
@property (weak, nonatomic) IBOutlet UIButton *goodsone;

@property (weak, nonatomic) IBOutlet UIButton *goodstwo;

@property (weak, nonatomic) IBOutlet UIButton *goodsstress;
@property (weak, nonatomic) IBOutlet UIButton *goodsfore;
@property (weak, nonatomic) IBOutlet UIButton *goodfin;
@property NSString *Commentgoodsid;
@property (weak, nonatomic) IBOutlet UIButton *StoreOne;
@property (weak, nonatomic) IBOutlet UIButton *StoreTwo;

@property (weak, nonatomic) IBOutlet UIButton *StoreStree;
@property (weak, nonatomic) IBOutlet UIButton *Storefore;
@property (weak, nonatomic) IBOutlet UIButton *Storefine;

@property (weak, nonatomic) IBOutlet UILabel *Sizelable;

@property (weak, nonatomic) IBOutlet UILabel *ColourLable;
@end
