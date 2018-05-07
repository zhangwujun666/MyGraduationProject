//
//  SYJShouCommentTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/19.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJShouCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Commentcontent;

@property (weak, nonatomic) IBOutlet UILabel *CommentTime;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userimager;
@property (weak, nonatomic) IBOutlet UIButton *commentxingji;
@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property  UILabel *ssize;
@property (strong, nonatomic) UIView *footView;
@property (strong,nonatomic) UIView* footimageview;


@end
