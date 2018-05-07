//
//  SYJcommentTowTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/25.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJcommentTowTableViewCell.h"

@implementation SYJcommentTowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUpInitOne{
    if (self.commentContent == nil) {
        self.commentContent = [[UILabel alloc]init];
    }

    //设置分享内容
    CGFloat textX = 10;
    CGFloat textY = 3;
    //根据内容长度判断label的高度
    NSString * text = [NSString stringWithFormat:@"%@：%@" ,self.dataDic[@"sharecomment_name"],self.dataDic[@"sharecomment_content"] ];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    //设置显示内容
    self.commentContent.text = self.dataDic[@"sharecomment_content"];
    //将获取的长宽高设置到控件中去
    [self.commentContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+3*((int)textSize.height/14))];
    //设置文本框的字体
    self.commentContent.font = [UIFont systemFontOfSize:12];
    //设置显示任意行
    self.commentContent.numberOfLines = 0;
    //调整文本框中的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@" ,self.dataDic[@"sharecomment_name"],self.dataDic[@"sharecomment_content"] ]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [self.dataDic[@"sharecomment_name"] length])];
    
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.commentContent.text length])];
    
    self.commentContent.attributedText = attributedString;
    //将Label加到cell中
    [self addSubview:self.commentContent];
}
- (void)setUpInitTow{
    
    if (self.commentContent == nil) {
        self.commentContent = [[UILabel alloc]init];
    }
    //设置分享内容
    CGFloat textX = 30;
    CGFloat textY = 3;
    //根据内容长度判断label的高度
    NSDictionary * dic = self.dataDic;
    NSString * text = [NSString stringWithFormat:@"%@回复%@：%@",dic[@"sharecommenttow_name"],dic[@"sharecommenttow_toname"],dic[@"sharecommenttow_content"] ];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    //设置显示内容
    self.commentContent.text = text;
    //将获取的长宽高设置到控件中去
    [self.commentContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+3*((int)textSize.height/14))];
    //设置文本框的字体
    self.commentContent.font = [UIFont systemFontOfSize:12];
    //设置显示任意行
    self.commentContent.numberOfLines = 0;
    //调整文本框中的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@回复%@：%@",dic[@"sharecommenttow_name"],dic[@"sharecommenttow_toname"],dic[@"sharecommenttow_content"] ]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6.0];//调整行间距
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [dic[@"sharecommenttow_name"] length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange([dic[@"sharecommenttow_name"] length]+2, [dic[@"sharecommenttow_toname"] length])];
    
    //[attributedString addAttribute:NSParagraphStyleAttributeName value:<#(id)#> range:<#(NSRange)#>];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.commentContent.text length])];
    self.commentContent.attributedText = attributedString;
    //将Label加到cell中
    [self addSubview:self.commentContent];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
