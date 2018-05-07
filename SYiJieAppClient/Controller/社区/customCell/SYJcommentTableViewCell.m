//
//  SYJcommentTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/24.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJcommentTableViewCell.h"
#import "SYJcommentTowTableViewCell.h"
#import "SYJAddShareViewController.h"

@implementation SYJcommentTableViewCell{
    NSMutableArray *commentCellHightArray;
    NSMutableArray *commentListArray;
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setUpInit{
    
    //设置tableview的代理
    self.commentCellTableView.delegate = self;
    self.commentCellTableView.dataSource = self;
    [self.commentCellTableView setFrame:CGRectMake(0, 10, self.frame.size.width, self.tableHight)];
    
    self.commentCellTableView.showsVerticalScrollIndicator = NO;
    self.commentCellTableView.separatorStyle = NO;
    self.commentCellTableView.alwaysBounceVertical = YES;
    self.commentCellTableView.scrollEnabled =NO;
    commentListArray =self.dataDic[@"sharecomment_towcomment"];
    self.sharecomment_id = self.dataDic[@"sharecomment_id"];
    [self getCellHight];
    [self.commentCellTableView reloadData];
}
-(void)getCellHight{
    commentCellHightArray = [[NSMutableArray alloc]init];
    NSString * text = [NSString stringWithFormat:@"%@：%@" ,self.dataDic[@"sharecomment_name"],self.dataDic[@"sharecomment_content"] ];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    //将获取的长宽高设置到控件中去
    CGFloat h1 = textSize.height+5*((int)textSize.height/14);
    [commentCellHightArray addObject:[NSString stringWithFormat:@"%f",h1]];
    for (int i = 0; i<[commentListArray count]; i++) {
        NSDictionary * commentList = [commentListArray objectAtIndex:i];
        NSString * commentTowtext = [NSString stringWithFormat:@"%@回复%@：%@",commentList[@"sharecommenttow_name"],commentList[@"sharecommenttow_toname"],commentList[@"sharecommenttow_content"] ];
        
        CGSize textTowSize = [commentTowtext boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        CGFloat h2  = textTowSize.height + 5*((int)textTowSize.height/14);

        [commentCellHightArray addObject:[NSString stringWithFormat:@"%f",h2]];
    }
}



#pragma mark - 设置TableView显示几个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
#pragma mark - 设置TableView每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([commentListArray count]==0) {
        return 1;
    }
    return [commentListArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYJcommentTowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commenttow"];
    //[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.row == 0) {
        cell.dataDic = self.dataDic;
        [cell setUpInitOne];
    }
    else{
        cell.dataDic = [commentListArray objectAtIndex:indexPath.row-1];
        [cell setUpInitTow];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[commentCellHightArray objectAtIndex:indexPath.row] floatValue];
    
}


#pragma mark - 每一行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",[self.sharecomment_id intValue]);
    if (indexPath.row == 0) {
        if ([self.delegate respondsToSelector:@selector(addCommentTowSharecommentId:andSharecommentName:)]) {
            [self.delegate addCommentTowSharecommentId:self.sharecomment_id andSharecommentName:self.dataDic[@"sharecomment_name"]];
        }
    }else{
        NSDictionary * dic = [commentListArray objectAtIndex:indexPath.row-1];
        if ([self.delegate respondsToSelector:@selector(addCommentTowSharecommentId:andSharecommentName:)]) {
            [self.delegate addCommentTowSharecommentId:self.sharecomment_id andSharecommentName:dic[@"sharecommenttow_name"]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
