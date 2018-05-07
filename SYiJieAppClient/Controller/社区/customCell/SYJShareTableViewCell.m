//
//  SYJShareTableViewCell.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/17.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJShareTableViewCell.h"
#import "SYJCommentViewController.h"

#define kStatusTableViewCellCreateAtFontSize 12
#define kStatusTableViewCellSourceFontSize 12
#define kStatusTableViewCellTextFontSize 12
#define kCellNum 3//每行显示的单元格数目
@implementation SYJShareTableViewCell{
    NSMutableArray * sharePhotoArray;
    BOOL isCollenctionClicked;
}

- (void)awakeFromNib {
    //[self setUpInit];
    // Initialization code
}
- (IBAction)collectionClicked:(UIButton *)sender {
    if (isCollenctionClicked) {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"card_icon_favorite"] forState:UIControlStateNormal];
        isCollenctionClicked = NO;
    }
    else{
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"card_icon_favorite_highlighted"] forState:UIControlStateNormal];

        isCollenctionClicked = YES;
    }
}

- (IBAction)showOtherPalce:(UIButton *)sender {
    NSLog(@"点击le转发按钮..");
    if ([self.delegate respondsToSelector:@selector(showOtherPlace:)]) {
        [self.delegate showOtherPlace:(int)(self.tag-commentTag)];
    }
}

//点击评论按钮的时候
- (IBAction)commentClicked:(UIButton *)sender {
    int cellTag=(int)(self.tag-commentTag);
    //如果存在这个代理就将这个tag值传递过去
    if ([self.delegate respondsToSelector:@selector(commentClicked:)]) {
        [self.delegate commentClicked:cellTag];
    }
}

- (IBAction)likeClicked:(UIButton *)sender {
    //NSLog(@"点击点赞按钮..");
    int cellTag=(int)(self.tag-commentTag);
    //如果存在这个代理就将这个tag值传递过去
    
    if ([self.delegate respondsToSelector:@selector(likeClicked:andLikeLabel:andImageView:)]) {
        [self.delegate likeClicked:cellTag andLikeLabel:self.likeName andImageView:self.likeImage];
    }
}
-(void)recommendButtonClicked:(UIButton *)sender {
    NSLog(@"点击点赞按钮..dfgdfgdfg ");
    if ([self.delegate respondsToSelector:@selector(recommendButtonClicked:)]) {
        [self.delegate recommendButtonClicked:self.goodsId];
    }
    
}


#pragma mark - 获取collection数据资源和配置
-(void)getDataSource{
    NSString *urlPath = [NSString stringWithFormat:@"%@Share/getSharePhoto?shareid=%d",SYJHTTP,[self.dataDic[@"share_id"] intValue]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success!");
        //接收响应数据responseObject，已经经过JSon解析-》id对象
        NSDictionary * dicdescription = (NSDictionary *)responseObject;
        sharePhotoArray = dicdescription[@"data"];
        NSLog(@"dic=%@",sharePhotoArray);
        [self setUpInit];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail!");
    }];
    //self.goodsCollectionView.
    //    self.activityCollenctionView.pagingEnabled = YES;
    //self.activityCollenctionView.contentSize = CGSizeMake(80, 110);
}
-(void)setUpInit{
    //获取图片路径
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPUSER,self.dataDic[@"share_user_image"]]];
    
    [self.shareImage sd_setImageWithURL:urlPath placeholderImage:nil] ;
    //取消收藏
    [self.collectButton setBackgroundImage:[UIImage imageNamed:@"card_icon_favorite"] forState:UIControlStateNormal];
    isCollenctionClicked = NO;
    //设主cell的tag值
    self.tag=[self.dataDic[@"share_id"] intValue]+commentTag;
    self.likeName.text=[NSString stringWithFormat:@"点赞 %d",[self.dataDic[@"like_count"] intValue]];
    int islike=[self.dataDic[@"share_like"] intValue];
    
    if (islike==0) {
        UIImage *img=[UIImage imageNamed:@"market_icon_dislike.png"];
        [self.likeImage setImage:img];
    }else{
        UIImage *img=[UIImage imageNamed:@"market_icon_liked.png"];
        [self.likeImage setImage:img];
    }
    
    self.shareName.text = self.dataDic[@"share_user_name"];
    self.shareName.textColor = cellTextColor;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.dataDic[@"share_time"] intValue]];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:confromTimesp];
    //设置时间
    self.shareTime.text = locationString;
    self.shareTime.textColor = cellTextColor;
    
    if (self.repeatLabel!=nil) {
        [self.repeatLabel removeFromSuperview];
    }
    
    if ([self.dataDic[@"share_repeat_content"] isEqualToString:@""]) {
        //设置分享内容
        if (self.shareContent ==  nil) {
            self.shareContent = [[UILabel alloc]init];
        }
        CGFloat textX = 10;
        CGFloat textY = self.shareImage.frame.size.height+20;
        //CGFloat textY = self.repeatLabel.frame.origin.y+self.repeatLabel.frame.size.height;
        CGFloat textWidth = self.frame.size.width - 2 * 10;
        //根据内容长度判断label的高度
        NSString * text = [NSString stringWithFormat:@"   %@" ,self.dataDic[@"share_content"] ];
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
        //设置显示内容
        self.shareContent.text = self.dataDic[@"share_content"];
        //将获取的长宽高设置到控件中去
        [self.shareContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+5*((int)textSize.height/14))];
        //设置文本框的字体
        self.shareContent.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
        //设置显示任意行
        self.shareContent.numberOfLines = 0;
        //调整文本框中的行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dataDic[@"share_content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];//调整行间距
        //[attributedString addAttribute:NSParagraphStyleAttributeName value:<#(id)#> range:<#(NSRange)#>];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.shareContent.text length])];
        self.shareContent.attributedText = attributedString;
        //将Label加到cell中
        [self.contentView addSubview:self.shareContent];
    }else{
        //设置转发的心情
        if (self.repeatLabel == nil) {
            self.repeatLabel = [[UILabel alloc] init];
        }
        CGFloat repeatLabelX = 10;
        CGFloat repeatLabelY = self.shareImage.frame.size.height+20;
        CGFloat repeatLabelWidth = self.frame.size.width - 2*10;
        //根据内容判断label的高度
        NSString *repeatLabelText=[NSString stringWithFormat:@"   %@" ,self.dataDic[@"share_repeat_content"] ];
        CGSize repeatTextSize = [repeatLabelText boundingRectWithSize:CGSizeMake(repeatLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
        //设置显示的内容
        self.repeatLabel.text = self.dataDic[@"share_repeat_content"];
        //将获得的长宽设置到控件中去
        [self.repeatLabel setFrame:CGRectMake(repeatLabelX, repeatLabelY, repeatLabelWidth, repeatTextSize.height+5*((int)repeatTextSize.height/14))];
        //设置文本框的字体
        self.repeatLabel.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
        //设置显示任意行
        self.repeatLabel.numberOfLines=0;
        //调整文本框中的行间距
        NSMutableAttributedString *repeatAttributeString = [[NSMutableAttributedString alloc] initWithString:self.dataDic[@"share_repeat_content"]];
        NSMutableParagraphStyle *repeatParagraphStyle=[[NSMutableParagraphStyle alloc] init];
        [repeatParagraphStyle setLineSpacing:5.0];
        [repeatAttributeString addAttribute:NSPaperMarginDocumentAttribute value:repeatParagraphStyle range:NSMakeRange(0, [self.repeatLabel.text length])];
        self.repeatLabel.attributedText=repeatAttributeString;
        //将label
        [self.contentView addSubview:self.repeatLabel];
        
        //设置分享内容
        if (self.shareContent ==  nil) {
            self.shareContent = [[UILabel alloc]init];
        }
        CGFloat textX = 10;
        //CGFloat textY = self.shareImage.frame.size.height+20;
        CGFloat textY = self.repeatLabel.frame.origin.y+self.repeatLabel.frame.size.height;
        CGFloat textWidth = self.frame.size.width - 2 * 10;
        //根据内容长度判断label的高度
        NSString * text = [NSString stringWithFormat:@"转发自%@:%@",self.dataDic[@"share_repeat_user_name"],self.dataDic[@"share_content"] ];
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
        //设置显示内容
        //self.shareContent.text = self.dataDic[@"share_content"];
        self.shareContent.text = text;
        //将获取的长宽高设置到控件中去
        [self.shareContent setFrame:CGRectMake(textX, textY, textSize.width, textSize.height+5*((int)textSize.height/14))];
        //设置文本框的字体
        self.shareContent.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
        //设置显示任意行
        self.shareContent.numberOfLines = 0;
        //调整文本框中的行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];//调整行间距
        //[attributedString addAttribute:NSParagraphStyleAttributeName value:<#(id)#> range:<#(NSRange)#>];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.shareContent.text length])];
        self.shareContent.attributedText = attributedString;
        //将Label加到cell中
        [self.contentView addSubview:self.shareContent];
    }
    
    
    //获取商品连接
    self.goodsId = self.dataDic[@"share_good_id"];
    //设置链接钮
    if (self.recommendButton == nil) {
        self.recommendButton = [[UIButton alloc]init];
    }
    CGFloat recommendButtonX = 10;
    CGFloat recommendButtonY = self.shareContent.frame.size.height + self.shareContent.frame.origin.y + 0;
    CGFloat recommendButtonHeight = 20.0;
    CGFloat recommendButtonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
    [self.recommendButton setFrame:CGRectMake(recommendButtonX, recommendButtonY, recommendButtonWidth, recommendButtonHeight)];//设置框高
    [self.recommendButton addTarget:self action:@selector(recommendButtonClicked:) forControlEvents:UIControlEventTouchDown];//添加点击事件
    [self.recommendButton.layer setBorderWidth:0.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30.0/255, 144.0/255, 255.0/255, 0.8 });
    //self.recommendButton.backgroundColor = [UIColor redColor];
    self.recommendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.recommendButton.layer setBorderColor:colorref];//边框颜色
    self.recommendButton.layer.cornerRadius = 4.0f;//边框弧度
    self.recommendButton.titleLabel.font = [UIFont systemFontOfSize: 12]; //设置字体大小
    [self.recommendButton setTitleColor:[[UIColor alloc] initWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];//字体颜色
    //[self.recommendButton setBackgroundColor:[UIColor greenColor]];
    [self.recommendButton setTitle:[NSString stringWithFormat:@"宝贝链接：%@", self.dataDic[@"share_goodsname"]] forState:UIControlStateNormal];//设置显示内容
    [self.recommendButton setTag:[self.dataDic[@"share_good_id"] intValue]];//设置tag值为商品id
    if ([self.dataDic[@"share_goodsname"] isEqualToString:@"nil"]) {
        [self.recommendButton setFrame:CGRectMake(0, recommendButtonY,0,0)];
    }
    else{
        [self.contentView addSubview:self.recommendButton];
    }
    
    
    //设置显示分享图片
    if (self.shareImageView == nil) {
        self.shareImageView = [[UIView alloc] init];
    }
    //设置尺寸
    CGFloat shareCollectionX = 10.0;
    CGFloat shareCollectionY = self.recommendButton.frame.size.height + self.recommendButton.frame.origin.y + 3;
    CGFloat shareCollectionWidth = self.frame.size.width - 2 * 15;
    CGFloat shareCollectionheight = 0.0;
    if([sharePhotoArray count] == 0){
        shareCollectionheight = 0;
    }
    if([sharePhotoArray count] > 0 && [sharePhotoArray count] < 4){
        shareCollectionheight = 150.0;
    }
    if([sharePhotoArray count] >= 4 && [sharePhotoArray count] < 7){
        shareCollectionheight = 300.0;
    }
    if([sharePhotoArray count] >= 7 && [sharePhotoArray count] < 10){
        shareCollectionheight = 450.0;
    }
    
    NSLog(@"%f",shareCollectionheight);
    //self.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:250.0/250.0 blue:240.0/250.0 alpha:1.0];
    [self.shareImageView setFrame:CGRectMake(shareCollectionX, shareCollectionY, shareCollectionWidth, shareCollectionheight)];
    [self.shareImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //显示图片
    for (int i = 0 ; i< [sharePhotoArray count]; i++) {
        UIImageView * image = [[UIImageView alloc] init];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        NSDictionary *dic = [sharePhotoArray objectAtIndex:i];
        //获取图片路径
        NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYJHTTPSHARE,dic[@"photosshare_photos"]]];
        [image sd_setImageWithURL:urlPath placeholderImage:nil];
         //[image setImageWithURL:urlPath placeholderImage:nil];
        
        
        CGFloat imageX = 90*(i%3)+(i%3)*10;
        CGFloat imageY = 140*(i/3)+(i/3)*7;
        CGFloat imageWidth = 90.0;
        CGFloat imageHeight = 140.0;
        [image setFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        //为每一个UIImageView添加一个手势
        UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        image.userInteractionEnabled=YES;
        [image addGestureRecognizer:recognizer];
        
        //让UIView添加多个UIImageView
        [self.shareImageView addSubview:image];
    }
    
    //加入到视图中
    if ([sharePhotoArray count] != 0) {
        //self.shareImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.shareImageView];
    }
}

- (void)clicked:(UITapGestureRecognizer *)gesture{
    //添加一个UIScrollView并且将图片选中到相应的位置
    //UIView *allView=gesture.view.superview;
    if ([self.delegate respondsToSelector:@selector(imageClicked:)]) {
        [self.delegate imageClicked:gesture];
    }
    
}



- (CGFloat)getCellHight{
    [self getDataSource];

    NSString * text = [NSString stringWithFormat:@"   %@" ,self.dataDic[@"share_content"] ];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
    //将获取的长宽高设置到控件中去
    CGFloat h1 = textSize.height+5*((int)textSize.height/14);

    CGFloat h2 = 150*(1 + [sharePhotoArray count]/3);
    
    return h1+h2+80+35;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
