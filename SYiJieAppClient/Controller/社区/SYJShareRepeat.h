//
//  SYJShareRepeat.h
//  SYiJieAppClient
//
//  Created by administrator on 15/9/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJShareTableViewCell.h"

@interface SYJShareRepeat : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UITextView *shareRepeatTextView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) SYJShareTableViewCell *shareCell;
@property (assign, nonatomic) int shareId;//cell的shareId
@end
